#!/bin/bash

echo "🛠️ Generating Rails auth setup..."

rails g authentication
rails db:migrate
echo "✅ default login system is ready"

rails g controller registrations_controller new

# Create registration view
curl -s https://raw.githubusercontent.com/jusondac/lazy_script/refs/heads/master/new.html.erb > app/views/registrations/new.html.erb
echo "✅ default registrations system is ready"

curl -s > app/controllers/sessions_controller.rb

# Patch sessions controller
cat <<'EOF' > app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new; end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Successfully signed in!"
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "Successfully signed out!"
  end
end
EOF

# Ask user if they want to add flash messages
read -p "Do you want to add flash message notifications? (y/n) " add_flash

if [[ "$add_flash" =~ ^[Yy]$ ]]; then
  # Inject flash message partial after <body> tag in app/views/layouts/application.html.erb
  sed -i '/<body>/a \
    <% if alert || notice %> \
      <div class="w-full fixed top-0 left-0 z-50 flex justify-center pt-10"> \
        <% if alert = flash[:alert] %> \
          <p class="py-2 px-3 bg-red-50 mb-5 text-red-500 font-medium rounded-lg inline-block" id="alert"><%= alert %></p> \
        <% end %> \
        <% if notice = flash[:notice] %> \
          <p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block" id="notice"><%= notice %></p> \
        <% end %> \
      </div> \
    <% end %>' app/views/layouts/application.html.erb
  echo "✅ Flash messages have been added"
else
  echo "⏩ Skipping flash message setup"
fi
echo "✅ Done! Registration and login system are now ready. Thanks for using lazy_script!🎉🥳"
