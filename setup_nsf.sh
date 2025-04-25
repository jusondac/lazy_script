#!/usr/bin/env bash

echo "🛠️ Generating Sidebar, Navbar, darkmode..."
echo "🛠️ Adding the template to shared"
mkdir -p app/views/shared

echo "🛠️ Setting up Auth"
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/setup_auth.sh | bash
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/setup_flowbite.sh | bash

curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/_footer.html.erb > app/views/shared/_footer.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/_sidebar.html.erb > app/views/shared/_sidebar.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/_navbar.html.erb > app/views/shared/_navbar.html.erb
# Insert sidebar render under body tag
# Insert navbar render before main container
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<%= render partial: "shared\/navbar" %>\n    <main class="container mx-auto mt-28 px-5 flex">/' app/views/layouts/application.html.erb
echo "✅ Added navbar render"
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<%= render partial: "shared\/sidebar" %>\n    <main class="container mx-auto mt-28 px-5 flex">/' app/views/layouts/application.html.erb
echo "✅ Added sidebar render"
# Add class to body element
INJECT_SCRIPT_HEAD=$(curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/dark_script_head)
INJECT_SCRIPT_BODY=$(curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/dark_script_body)

# Insert dark mode scripts into head section
awk -v html="$INJECT_SCRIPT_HEAD" '/<\/head>/ { print html; print; next } 1' app/views/layouts/application.html.erb > tmpfile && mv tmpfile app/views/layouts/application.html.erb
awk -v html="$INJECT_SCRIPT_BODY" '/<\/body>/ { print html; print; next } 1' app/views/layouts/application.html.erb > tmpfile && mv tmpfile app/views/layouts/application.html.erb

sed -i 's/@import "tailwindcss";/@import "tailwindcss";\n @custom-variant dark (&:where(.dark, .dark *));/' app/assets/stylesheets/application.tailwind.css
sed -i 's/<body>/<body class="bg-white dark:bg-gray-900 text-gray-100">/' app/views/layouts/application.html.erb
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<main class="container mx-auto mt-28 px-5 flex pl-24">/' app/views/layouts/application.html.erb
echo "✅ Added dark mode classes to body element"
