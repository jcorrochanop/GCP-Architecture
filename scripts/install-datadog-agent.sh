#!/bin/bash
set -e

sleep 10

curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh -o /tmp/install_dd.sh

DD_API_KEY="${DATADOG_API_KEY}" \
DD_SITE="${DATADOG_SITE}" \
DD_HOSTNAME="vm-${VM_VPC}-${VM_ENV}" \
DD_TAGS="env:${VM_ENV},vpc:${VM_VPC},project:gcp-landing-zone" \
DD_ENV="${VM_ENV}" \
bash /tmp/install_dd.sh

sed -i 's/^# logs_enabled: false/logs_enabled: true/' /etc/datadog-agent/datadog.yaml
sed -i 's/^# logs_config:/logs_config:/' /etc/datadog-agent/datadog.yaml

systemctl daemon-reload
systemctl restart datadog-agent
systemctl enable datadog-agent

