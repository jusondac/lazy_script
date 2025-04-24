#!/bin/bash

echo "🛠️ Generating Rails auth setup..."

rails g authentication
rails db:migrate
echo "✅ default login system is ready"

rails g controller registrations_controller new
rails g controller home index
# Create registration view
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/signup.html.erb > app/views/registrations/new.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/signin.html.erb > app/views/sessions/new.html.erb
# Update registration controller
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/registrations_controller.rb > app/controllers/registrations_controller.rb
echo "✅ default registrations system is ready"

# Inject resource :registration route after resource :session in config/routes.rb
sed -i '/resource :session/a \  resource :registration, only: %i[new create]' config/routes.rb
# Add root route after home/index
sed -i '/get "home\/index"/a \  root "home#index"' config/routes.rb
echo "✅ update routes"

INJECT=$(curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/flash.html.erb)
awk -v html="$INJECT" '/<body>/ { print; print html; next } 1' app/views/layouts/application.html.erb > tmpfile && mv tmpfile app/views/layouts/application.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/sessions_controller.rb > app/controllers/sessions_controller.rb
# Inject flash message partial after <body> tag in app/views/layouts/application.html.erb
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/auth_setup/index.html.erb >> app/views/home/index.html.erb
echo "✅ Flash messages have been added"

echo "✅ Done! Registration and login system are now ready. Thanks for using lazy_script!🎉🥳"
