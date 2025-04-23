#! /usr/bin/env bash
# This script sets up Flowbite in a Rails application

echo "🛠️  Setting up importmap"
echo 'pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.turbo.min.js"' >> config/importmap.rb
# Find the line containing import "controllers" and append import "flowbite" after it
sed -i '/import "controllers"/a import "flowbite"' app/javascript/application.js
echo "✅  Flowbite setup complete 🎉"