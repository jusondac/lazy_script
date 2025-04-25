#!/usr/bin/env bash

echo "🛠️ Generating Sidebar, Navbar, darkmode..."

echo "🛠️ Adding the template to shared"
mkdir -p app/views/shared
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/_footer.html.erb > app/views/shared/_footer.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/_sidebar.html.erb > app/views/shared/_sidebar.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/nsf/_navbar.html.erb > app/views/shared/_navbar.html.erb
# Insert sidebar render under body tag
# Insert navbar render before main container
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<%= render partial: "shared\/navbar" %>\n    <main class="container mx-auto mt-28 px-5 flex">/' app/views/layouts/application.html.erb
echo "✅ Added navbar render"
sed -i 's/<main class="container mx-auto mt-28 px-5 flex">/<%= render partial: "shared\/sidebar" %>\n    <main class="container mx-auto mt-28 px-5 flex">/' app/views/layouts/application.html.erb
echo "✅ Added sidebar render"

sed -i 's/<%= yield %>/<%= yield %>\n    <%= render "shared/footer" %>/' app/views/layouts/application.html.erb
echo "✅ Added sidebar render"
# Add class to body element
sed -i 's/<body>/<body class="bg-white dark:bg-gray-900 text-gray-100">/' app/views/layouts/application.html.erb
echo "✅ Added dark mode classes to body element"
