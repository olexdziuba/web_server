PHP Audit Script

This script helps system administrators audit installed PHP versions and identify which ones are active for CLI, FPM, Apache, and Nginx. It is especially useful when cleaning up old PHP versions or preparing for a safe migration to a newer PHP release.

🔧 What It Does
	•	Lists all installed PHP versions
	•	Shows the currently active PHP CLI version
	•	Displays all running PHP-FPM services and their sockets
	•	Checks which PHP version is configured in Apache (if installed)
	•	Analyzes Nginx configurations for fastcgi_pass references
	•	Lists all sockets used by FPM pools
	•	Locates the php.ini used by CLI
	•	Gives tips on switching PHP versions in web servers

📜 Script Usage

chmod +x check_php_versions.sh
./check_php_versions.sh

🖥 Sample Output

=== 📦 Installed PHP Versions ===
php7.4
php8.0
php8.4

=== 🖥️ Active PHP CLI Version ===
PHP 8.4.7 (cli) (built: May  9 2025 06:54:08)

=== 🔧 Active PHP-FPM Services ===
php8.0-fpm.service                   loaded active running

=== 📡 Listening PHP-FPM Sockets ===
 - /run/php/php8.0-fpm.sock is active
🔸 php8.0 uses socket: /run/php/php8.0-fpm.sock

=== 🧩 Apache: Enabled PHP Modules ===
No PHP module enabled in Apache

=== 🌐 Nginx: PHP Usage in Virtual Hosts ===
--- File: /etc/nginx/sites-enabled/wordpress ---
fastcgi_pass unix:/run/php/php8.0-fpm.sock;

=== 🔍 Matching fastcgi_pass to PHP-FPM sockets ===
fastcgi_pass unix:/run/php/php8.0-fpm.sock;

=== 📄 php.ini used by CLI ===
Loaded Configuration File => /etc/php/8.4/cli/php.ini

💡 Tips

To switch PHP versions:
	•	Apache: Use a2dismod php8.0 && a2enmod php8.4 && systemctl restart apache2
	•	Nginx: Edit fastcgi_pass in your virtual host config to point to the desired PHP-FPM socket, then reload Nginx:

sudo systemctl reload nginx



📁 Location Suggestions

Store this script in /usr/local/bin or in your project directory and track it in your GitLab repo for server audits.

⸻

Author: Oleksandr Dziuba
Date: 2025-05-22
License: MIT
