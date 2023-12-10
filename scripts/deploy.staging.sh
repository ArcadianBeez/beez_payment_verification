#!/usr/bin/env bash
echo "" >> /home/runner/work/beez_payment_verification/beez_payment_verification/assets/cfg/configurations.json
cat << EOF > /home/runner/work/beez_payment_verification/beez_payment_verification/assets/cfg/configurations.json
{
  "base_url": "https://service.staging.beez-delivery.com/",
  "api_base_url": "https://service.staging.beez-delivery.com/api/",
  "google_maps_key": "AIzaSyBbtM6hTqnRG4khh4dr6pyLZ18UBd4v1lE"
}
EOF
cat << EOF > firebase.json
{
  "hosting": {
    "public": "build/web",
    "site": "stg-payment-verification-app",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}

EOF