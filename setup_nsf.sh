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
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/_pagination.html.erb > app/views/shared/_pagination.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/scafftemplate/pagy.rb > config/initializers/pagy.rb

# Insert sidebar render under body tag
# Insert navbar render before main container
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<%= render partial: "shared\/navbar" %>\n    <main class="container mx-auto mt-28 px-5 flex">/' app/views/layouts/application.html.erb
echo "✅ Added navbar render"
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<%= render partial: "shared\/sidebar" %>\n    <main class="container mx-auto mt-28 px-5 flex">/' app/views/layouts/application.html.erb
echo "✅ Added sidebar render"
# Add class to body element
INJECT_SCRIPT_HEAD=$(curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/dark_script_head)
INJECT_SCRIPT_BODY=$(curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/dark_script_body)
INJECT_SCRIPT_YIELD=$(curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/auth_sidebar)

# Insert dark mode scripts into head section
awk -v inject='@custom-variant dark (&:where(.dark, .dark *));' '/@import "tailwindcss";/ { print;  print inject; next } 1' app/assets/tailwind/application.css > tmpfile && mv tmpfile app/assets/tailwind/application.css
awk -v html="$INJECT_SCRIPT_HEAD" '/<\/head>/ { print html; print; next } 1' app/views/layouts/application.html.erb > tmpfile && mv tmpfile app/views/layouts/application.html.erb
awk -v html="$INJECT_SCRIPT_BODY" '/<\/body>/ { print html; print; next } 1' app/views/layouts/application.html.erb > tmpfile && mv tmpfile app/views/layouts/application.html.erb
awk -v replacement="$INJECT_SCRIPT_YIELD" '{gsub(/<%= yield %>/, replacement)}1' app/views/layouts/application.html.erb > tmpfile && mv tmpfile app/views/layouts/application.html.erb

sed -i 's/<body>/<body class="bg-white dark:bg-gray-900 text-gray-100">/' app/views/layouts/application.html.erb
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<main class="mx-auto mt-18 flex">/' app/views/layouts/application.html.erb

# copying the template files
# Create lib/templates directory if it doesn't exist
mkdir -p lib/templates

# Download the templates folder from GitHub and move it to lib/templates
echo "🛠️ Downloading templates from GitHub..."
git clone --depth=1 --filter=blob:none --sparse https://github.com/jusondac/lazy_script.git temp_repo
cd temp_repo
git sparse-checkout set scafftemplate/templates
cd ..
cp -r temp_repo/scafftemplate/templates/* lib/templates/
rm -rf temp_repo

echo "✅ Templates installed in lib/templates"
# Add required gems silently
echo "🛠️ Installing necessary gems..."
bundle add pagy ransack
# Add Pagy::Backend to ApplicationController
if [ -f app/controllers/application_controller.rb ]; then
  sed -i '/class ApplicationController < ActionController::Base/a \  include Pagy::Backend' app/controllers/application_controller.rb
  echo "✅ Added Pagy::Backend to ApplicationController"
else
  echo "⚠️ Could not find application_controller.rb"
fi

if [ -f app/helpers/application_helper.rb ]; then
  sed -i '/module ApplicationHelper/a \  include Pagy::Frontend' app/helpers/application_helper.rb
  echo "✅ Added Pagy::Backend to ApplicationHelper"
else
  echo "⚠️ Could not find application_helper.rb"
fi

echo "✅ Setting up template"
echo "✅ Added dark mode classes to body element"
