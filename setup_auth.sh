#!/bin/bash

echo "🛠️ Generating Rails auth setup..."

rails g authentication
rails db:migrate
echo "✅ default login system is ready"

rails g controller registrations_controller new
rails g controller home index
# Create registration view
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/new.html.erb > app/views/registrations/new.html.erb
echo "✅ default registrations system is ready"

# Ask user if they want to add flash messages
read -p "Do you want to add flash message notifications? (y/n) " add_flash

# Inject resource :registration route after resource :session in config/routes.rb
sed -i '/resource :session/a \  resource :registration, only: %i[new create]' config/routes.rb
sed -i '/get "home/index"/a \  root "home#index"' config/routes.rb
echo "✅ update routes"

curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/sessions_controller.rb > app/controllers/sessions_controller.rb
# Inject flash message partial after <body> tag in app/views/layouts/application.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/index.html.erb > app/views/home/index.html.erb
echo "✅ Flash messages have been added"

echo "✅ Done! Registration and login system are now ready. Thanks for using lazy_script!🎉🥳"
