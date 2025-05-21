# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
# user = User.create(
#   name: "Admin User",
#   email: "email@example.org",
#   password: "password",
#   password_confirmation: "password",
#   terms_of_service: true
# )
# Jumpstart.grant_system_admin!(user)

# Create integrations
Integration.find_or_create_by(slug: 'google_calendar') do |integration|
  integration.name = 'Google Calendar'
  integration.description = 'Connect to your Google Calendar to read events and create new ones'
  integration.logo = 'google'
  integration.active = true
end

puts "Integrations created!"
