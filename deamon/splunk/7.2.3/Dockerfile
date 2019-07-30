FROM splunk/splunk:7.2.3

USER root
COPY splunkd /opt/splunk/bin/splunkd
COPY splunk-enterprise.lic /opt/splunk/etc/licenses/enterprise/splunk-enterprise.lic
# RUN chmod +x /opt/splunk/bin/splunkd