#!/bin/bash

read -p "Enter current PHP version (e.g. 8.0): " FROM
read -p "Enter target PHP version (e.g. 8.4): " TO

echo "🔍 Searching for installed PHP $FROM modules..."

modules=$(dpkg -l | grep "^ii" | grep "php$FROM-" | awk '{print $2}' | sed "s/php$FROM/php$TO/")

if [ -z "$modules" ]; then
  echo "⚠️ No PHP $FROM modules found."
  exit 1
fi

echo
echo "📦 Modules to install for PHP $TO:"
echo "$modules"
echo

read -p "❓ Do you want to install these modules for PHP $TO? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Aborted."
  exit 1
fi

echo
echo "⚙️ Installing PHP $TO core packages and modules..."
sudo apt update
sudo apt install -y php$TO php$TO-fpm $modules

echo
echo "✅ Installation complete. You can now configure Nginx or Apache to use PHP $TO."

