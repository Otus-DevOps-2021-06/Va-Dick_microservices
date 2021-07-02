FROM grafana/grafana:8.0.4
RUN mkdir -p /var/lib/grafana/dashboards
ADD ./dashboards/* /var/lib/grafana/dashboards/
ADD ./datasource.yaml /etc/grafana/provisioning/datasources/
ADD ./dashboard.yaml /etc/grafana/provisioning/dashboards/
