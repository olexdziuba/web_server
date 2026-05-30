#!/bin/bash

echo "=== 📦 Installed PHP Versions ==="
dpkg -l | grep '^ii' | grep -oP 'php[0-9]+\.[0-9]+' | sort -u

echo
echo "=== 🖥️ Active PHP CLI Version ==="
php -v | head -n 1

echo
echo "=== 🔧 PHP-FPM Services (if used) ==="
systemctl list-units --type=service | grep php | grep fpm || echo "No PHP-FPM services running"

echo
echo "=== 📡 PHP-FPM Sockets (if applicable) ==="
shopt -s nullglob
sockets=("/run/php/php*.sock")
if [ ${#sockets[@]} -gt 0 ]; then
  for sock in "${sockets[@]}"; do
    [ -S "$sock" ] && echo " - $sock is active"
  done
else
  echo "No FPM sockets found (probably using mod_php with Apache)"
fi

echo
echo "=== 🧩 Apache: Enabled PHP Modules ==="
if command -v apache2ctl &>/dev/null; then
  apache2ctl -M 2>/dev/null | grep php || echo "No PHP module enabled in Apache"
else
  echo "Apache is not installed or not active."
fi

echo
echo "=== 🧩 Apache: PHP .ini Used by mod_php ==="
for dir in /etc/php/*; do
  version=$(basename "$dir")
  if [ -f "$dir/apache2/php.ini" ]; then
    echo "PHP $version with Apache uses: $dir/apache2/php.ini"
  fi
done

echo
echo "=== 🌐 Nginx: PHP Usage in Virtual Hosts ==="
if command -v nginx &>/dev/null; then
  find /etc/nginx/sites-enabled -type f | while read file; do
    echo "--- File: $file ---"
    grep -E 'fastcgi_pass' "$file" | grep php || echo "  ⛔ No fastcgi_pass found"
  done
else
  echo "Nginx is not installed or not active."
fi

echo
echo "=== 🔍 Matching fastcgi_pass to PHP-FPM sockets (Nginx only) ==="
grep -RhoP 'fastcgi_pass\s+(unix:/run/php/php[0-9.]+-fpm\.sock|127\.0\.0\.1:\d+);' /etc/nginx/sites-enabled 2>/dev/null | sort -u || echo "No fastcgi_pass php directives found"

echo
echo "=== 📄 php.ini used by CLI ==="
php -i | grep 'Loaded Configuration File'

echo
echo "=== 🧠 Tip ==="
echo "- Apache: utilisez 'a2dismod/a2enmod' pour changer la version PHP"
echo "- Nginx: modifiez fastcgi_pass pour pointer vers le bon socket PHP-FPM"
