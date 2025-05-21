# app/services/google_calendar_service.rb
require 'google/apis/calendar_v3'

class GoogleCalendarService
  attr_reader :application_connection
  
  def initialize(application_connection)
    @application_connection = application_connection
  end
  
  def client
    @client ||= Google::Apis::CalendarV3::CalendarService.new.tap do |client|
      client.authorization = authorization
    end
  end
  
  def authorization
    @authorization ||= begin
      auth = Signet::OAuth2::Client.new(
        token_credential_uri: 'https://oauth2.googleapis.com/token',
        client_id: Rails.application.credentials.dig(:omniauth, :google_oauth2, :public_key),
        client_secret: Rails.application.credentials.dig(:omniauth, :google_oauth2, :private_key),
        refresh_token: application_connection.refresh_token,
        access_token: application_connection.access_token
      )
      
      # Refresh the token if it's expired
      if application_connection.expired?
        auth.refresh!
        # Update the tokens in ConnectedAccount
        connected_account = application_connection.connected_account
        connected_account.update(
          access_token: auth.access_token,
          expires_at: Time.at(auth.expires_at)
        )
      end
      
      auth
    end
  end
  
  def list_calendars
    client.list_calendar_lists.items
  end
  
  def list_events(calendar_id = 'primary', max_results = 10, time_min = Time.now.iso8601)
    client.list_events(
      calendar_id,
      max_results: max_results,
      single_events: true,
      order_by: 'startTime',
      time_min: time_min
    ).items
  end
  
  def create_event(calendar_id = 'primary', summary, description, start_time, end_time, attendees = [])
    event = Google::Apis::CalendarV3::Event.new(
      summary: summary,
      description: description,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: start_time.to_datetime.rfc3339,
        time_zone: Time.zone.name
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: end_time.to_datetime.rfc3339,
        time_zone: Time.zone.name
      )
    )
    
    # Add attendees if provided
    if attendees.any?
      event.attendees = attendees.map { |email| Google::Apis::CalendarV3::EventAttendee.new(email: email) }
    end
    
    client.insert_event(calendar_id, event)
  end
end
