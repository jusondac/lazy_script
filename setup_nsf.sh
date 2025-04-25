#!/usr/bin/env bash

echo "🛠️ Generating Sidebar, Navbar, darkmode..."

echo "🛠️ Adding the template to shared"
mkdir -p app/views/shared
curl -s  > app/views/shared/_footer.html.erb
curl -s  > app/views/shared/_sidebar.html.erb
curl -s  > app/views/shared/_navbar.html.erb
# Add class to body element
sed -i 's/<body>/<body class="bg-white dark:bg-gray-900 text-gray-100">/' app/views/layouts/application.html.erb
echo "✅ Added dark mode classes to body element"
