#!/usr/bin/env bash

HOSTS=(
  "test1.example.com"
  "test2.example.com"
  "test3.example.com"
)

CHANGE_BATCH="/tmp/route53.json"

#Your Hosted Zone ID
HOSTED_ZONE_ID="XXXXXXXXXXXXXX"
IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cat << EOF > ${CHANGE_BATCH}
{
  "Changes": [
EOF

for host in "${HOSTS[@]}"; do
  cat << EOF >> ${CHANGE_BATCH}
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${host}",
        "Type": "A",
        "TTL": 600,
        "ResourceRecords": [
          {
            "Value": "${IP}"
          }
        ]
      }
    },
EOF
done
sed -i -e '$s/\},/\}/' ${CHANGE_BATCH}

cat << EOF >> ${CHANGE_BATCH}
  ]
}
EOF

aws route53 change-resource-record-sets \
--hosted-zone-id ${HOSTED_ZONE_ID} \
--change-batch file://${CHANGE_BATCH}

rm ${CHANGE_BATCH}