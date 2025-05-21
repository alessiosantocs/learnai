# LearnAI - Bridge Language Models with External Tools

This Rails application provides a unified interface for connecting language models with external tools. It allows users to connect their preferred applications and offers a single endpoint for language models to interact with these user-connected services.

## Features

- Connect to various external services through a unified interface
- Manage application connections through a user-friendly dashboard
- Secure API endpoints for language model interactions
- Initial integration with Google Calendar (read events and create new events)

## Getting Started

### Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Redis
- Node.js and Yarn

### Installation

1. Clone the repository
```bash
git clone https://github.com/alessiosantocs/learnai.git
cd learnai
```

2. Install dependencies
```bash
bin/setup
```

3. Start the server
```bash
bin/dev
```

4. Visit http://localhost:3000 in your browser

## Google Calendar Integration

The initial focus of this application is on integrating Google Calendar, with functionality to:
- Read events from the user's Google Calendar
- Create new events in the user's Google Calendar

To use the Google Calendar integration, you need to:
1. Configure Google OAuth credentials in your Rails credentials
2. Connect your Google account through the application
3. Use the API endpoints to interact with your calendar

## API Usage

Language models can interact with connected services through the API:

```
POST /api/v1/actions
```

Example request for listing calendar events:
```json
{
  "service": "google_calendar",
  "action_type": "list_events",
  "parameters": {
    "calendar_id": "primary",
    "max_results": 10
  }
}
```

Example request for creating a calendar event:
```json
{
  "service": "google_calendar",
  "action_type": "create_event",
  "parameters": {
    "calendar_id": "primary",
    "summary": "Meeting with Team",
    "description": "Discuss project progress",
    "start_time": "2023-06-15T10:00:00",
    "end_time": "2023-06-15T11:00:00",
    "attendees": ["team@example.com"]
  }
}
```

## Adding New Integrations

To add more services in the future:
1. Create a new Integration record
2. Implement the OAuth flow for that service (if needed)
3. Create a service class for API interactions
4. Add handling for the service in the API controller

## License

This project is licensed under the MIT License - see the LICENSE file for details.
