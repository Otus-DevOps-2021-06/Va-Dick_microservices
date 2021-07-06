import yandexcloud
import argparse
import json
from google.protobuf.json_format import MessageToDict
from yandex.cloud.compute.v1.instance_service_pb2_grpc import InstanceServiceStub
from yandex.cloud.compute.v1.instance_service_pb2 import ListInstancesRequest


main_label = "stage"
group_labels = ["master", "worker"]
default_group_label = "other"
all_group_labels = group_labels.copy()
all_group_labels.extend([default_group_label])

class Ansible_inventory:
    def __init__(self, arguments):
        self.arguments = arguments
        self.__init_yandex_sdk()
        self.__get_hosts_data()
        self.__preparing_for_unloading()
        self.__upload_data_to_file()

    def __upload_data_to_file(self, file_name="inventory"):
        f = open(f'{file_name}.json', 'w')
        f.write(self.inventory_json)
        f.close()

    def __preparing_for_unloading(self):
        hosts = self.__prepare_list_of_hosts()
        inventory_dict = dict()
        for host_name, host_ip in hosts.items():
            host = {host_name: {"ansible_host": host_ip}}
            group_label = self.__group_label_by_host_name(host_name)
            if not inventory_dict.get(group_label):
                inventory_dict[group_label] = {"hosts": dict({})}
            inventory_dict[group_label]["hosts"].update(host)
        self.inventory_json = json.dumps(inventory_dict, indent=4, sort_keys=True)

    def __group_label_by_host_name(self, host_name):
        for group_label in group_labels:
            if group_label in host_name and main_label in host_name:
                return group_label
        return default_group_label

    def __init_yandex_sdk(self):
        with open(self.arguments.sa_json_path) as infile:
            self.sdk = yandexcloud.SDK(service_account_key=json.load(infile))

    def __get_external_ip_addres(self, host):
        try:
            for interface in host['networkInterfaces']:
                return interface['primaryV4Address']['oneToOneNat']['address']
        except:
            return None

    def __get_hosts_data(self):
        instance_service = self.sdk.client(InstanceServiceStub)
        hosts = MessageToDict(instance_service.List(ListInstancesRequest(folder_id=self.arguments.folder_id)))
        hosts_dict = dict()
        if not hosts.get('instances'):
            self.hosts_dict = hosts_dict
            return
        for host in hosts['instances']:
            interface = self.__get_external_ip_addres(host)
            if interface is not None:
                hosts_dict[host['name']] = interface
        self.hosts_dict = hosts_dict

    def __prepare_list_of_hosts(self):
        if self.arguments.list is True:
            return self.hosts_dict
        if self.hosts_dict.get(self.arguments.host):
            return {self.arguments.host: self.hosts_dict.get(self.arguments.host)}
        return {}


def parse_args():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--sa-json-path',
                        help='Path to the service account key JSON file.\nThis file can be created using YC CLI:\n'
                             'yc iam key create --output sa.json\n--service-account-id <id>', required=True)
    parser.add_argument('--folder-id',
                        help='Your Yandex.Cloud folder id',
                        required=True)
    select = parser.add_mutually_exclusive_group(required=True)
    select.add_argument('--list',
                        help='If you need to get a list of all instances',
                        action="store_true")
    select.add_argument('--host',
                        help='If you need to get one instance (you must also\n'
                             'specify the full name of the instance)')
    return parser.parse_args()

if __name__ == '__main__':
    arguments = parse_args()
    ansible_inventory = Ansible_inventory(arguments)
