class ApplicationConnectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_application_connection, only: [:show, :destroy]
  
  def index
    @application_connections = current_user.application_connections.includes(:integration)
    @available_integrations = Integration.active
  end
  
  def new
    @integration = Integration.find(params[:integration_id])
    @application_connection = current_user.application_connections.new(integration: @integration)
  end
  
  def create
    @integration = Integration.find(params[:integration_id])
    
    # For Google services, redirect to OAuth
    if @integration.slug.include?('google')
      session[:integration_id] = @integration.id
      redirect_to user_google_oauth2_omniauth_authorize_path(prompt: 'consent')
      return
    end
    
    # Handle other services here
    
    redirect_to application_connections_path, notice: "Connection setup initiated."
  end
  
  def show
    @integration = @application_connection.integration
    
    case @integration.slug
    when 'google_calendar'
      @service = GoogleCalendarService.new(@application_connection)
      @calendars = @service.list_calendars
      @events = @service.list_events
    end
  end
  
  def destroy
    @application_connection.destroy
    redirect_to application_connections_path, notice: "Connection was removed."
  end
  
  private
  
  def set_application_connection
    @application_connection = current_user.application_connections.find(params[:id])
  end
end
