# app/controllers/api/v1/actions_controller.rb
module Api
  module V1
    class ActionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_api_key
      
      def create
        user = @api_key.user
        action = params[:action_type]
        service = params[:service]
        parameters = params[:parameters] || {}
        
        case service
        when 'google_calendar'
          handle_google_calendar_action(user, action, parameters)
        else
          render json: { error: "Unsupported service: #{service}" }, status: :unprocessable_entity
        end
      end
      
      private
      
      def authenticate_api_key
        api_key = request.headers['X-API-Key']
        @api_key = ApiKey.find_by(token: api_key)
        
        unless @api_key&.active?
          render json: { error: 'Invalid API key' }, status: :unauthorized
          return
        end
      end
      
      def handle_google_calendar_action(user, action, parameters)
        app_connection = user.application_connections.joins(:integration)
                           .where(integrations: { slug: 'google_calendar' })
                           .first
        
        unless app_connection&.active_and_valid?
          render json: { error: 'Google Calendar not connected or connection expired' }, status: :unprocessable_entity
          return
        end
        
        service = GoogleCalendarService.new(app_connection)
        
        case action
        when 'list_events'
          calendar_id = parameters[:calendar_id] || 'primary'
          max_results = parameters[:max_results] || 10
          time_min = parameters[:time_min] || Time.now.iso8601
          
          events = service.list_events(calendar_id, max_results, time_min)
          render json: { events: events.map(&:to_h) }
        
        when 'create_event'
          calendar_id = parameters[:calendar_id] || 'primary'
          summary = parameters[:summary]
          description = parameters[:description]
          start_time = parameters[:start_time]
          end_time = parameters[:end_time]
          attendees = parameters[:attendees] || []
          
          # Validate required parameters
          if summary.blank? || start_time.blank? || end_time.blank?
            render json: { error: 'Missing required parameters' }, status: :unprocessable_entity
            return
          end
          
          event = service.create_event(
            calendar_id, summary, description, 
            Time.parse(start_time), Time.parse(end_time), attendees
          )
          
          render json: { event: event.to_h }
        
        else
          render json: { error: "Unsupported action: #{action}" }, status: :unprocessable_entity
        end
      end
    end
  end
end
