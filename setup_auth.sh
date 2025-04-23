#!/bin/bash

echo "🛠️ Generating Rails auth setup..."

rails g authentication
rails db:migrate
rails g controller registrations_controller new

# Create registration view
curl -s https://raw.githubusercontent.com/your-username/your-repo/main/views/registrations/new.html.erb > app/views/registrations/new.html.erb

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

echo "✅ Done! Registration and login system are now ready."
