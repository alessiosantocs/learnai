class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Jumpstart::Omniauth::Callbacks

  # Jumpstart Pro's Callbacks module handles:
  #
  #   1. Registering with OAuth
  #   2. Connecting OAuth when logged in
  #   3. Logging in with OAuth
  #   4. Rejecting OAuth if user already has account, but hasn't connected this OAuth account yet

  # For extra processing on the account that was just connected,
  # simply define a method like the following examples:
  #
  # def github_connected(connected_account)
  # end
  #
  # def twitter_connected(connected_account)
  # end
  #
  # etc...

  # To change the redirect URL after an account is connected, you can override the following methods:
  #
  # After sign up and sign in with OAuth
  # def after_sign_in_path_for(resource)
  #   root_path
  # end
  #
  # After connecting an OAuth account while logged in
  # def after_connect_redirect_path
  #   user_connected_accounts_path
  # end
  
  # Override google_oauth2 method to handle integration connections
  def google_oauth2_connected(connected_account)
    # If we have a pending integration to connect
    if session[:integration_id].present?
      integration = Integration.find_by(id: session[:integration_id])
      if integration && integration.slug.include?('google')
        # Create or update the application connection
        application_connection = current_user.application_connections.where(integration: integration).first_or_initialize
        application_connection.update(
          active: true,
          name: connected_account.auth.info.email
        )
        
        # Clean up the session
        session.delete(:integration_id)
        
        # Redirect to the connection detail page
        redirect_to application_connection_path(application_connection), notice: "Connected to #{integration.name} successfully!"
        return
      end
    end
  end
  
  # Override after_connect_redirect_path to handle integration connections
  def after_connect_redirect_path
    if session[:integration_id].present?
      integration = Integration.find_by(id: session[:integration_id])
      if integration
        application_connection = current_user.application_connections.find_by(integration: integration)
        return application_connection_path(application_connection) if application_connection
      end
    end
    
    # Default to the standard path
    user_connected_accounts_path
  end
end
