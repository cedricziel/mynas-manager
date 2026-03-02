# Hybrid Authentication

MyNAS Manager supports three authentication modes:

## 1. Legacy Mode (Default)
- Single shared TrueNAS connection using API key
- All operations use the same credentials
- Set `AUTH_MODE=none` or leave unset

## 2. Session-Only Mode
- Users must log in with their TrueNAS credentials
- Each user gets their own TrueNAS connection
- Set `AUTH_MODE=truenas` or `USE_SESSION_AUTH=true`

## 3. Hybrid Mode (Recommended)
- Backend services use API key for background operations
- Frontend users authenticate with their TrueNAS credentials
- Both authentication methods work simultaneously
- Set `AUTH_MODE=hybrid` or `USE_HYBRID_AUTH=true`

## Configuration

### Environment Variables

```env
# TrueNAS connection
TRUENAS_URL=ws://your-truenas-ip/api/current

# For API key authentication (backend services)
TRUENAS_API_KEY=your-api-key-here
TRUENAS_USERNAME=service-account  # Optional, for username/API key auth

# Authentication mode
AUTH_MODE=hybrid  # Options: none, apiKey, truenas, hybrid
# OR
USE_HYBRID_AUTH=true  # Enable hybrid mode
```

### Hybrid Mode Benefits

1. **Security**: Users inherit their TrueNAS permissions
2. **Automation**: Backend services can run without user interaction
3. **Flexibility**: Supports both interactive and automated workflows
4. **Audit Trail**: User actions are tracked separately from system actions

### How It Works

In hybrid mode:
- The backend maintains a shared TrueNAS client using API key authentication
- When users log in via the frontend, they create their own session
- Each session has its own TrueNAS client with the user's permissions
- The system automatically selects the appropriate client for each operation:
  - User-initiated actions use the session client
  - Backend/automated actions use the shared API key client

### API Methods

All API methods work in hybrid mode:
- If a user is logged in, their session client is used
- If no user session exists, the shared API key client is used
- If neither exists, the method returns a 401 error

### Frontend Integration

The frontend automatically:
- Prompts for TrueNAS credentials on login
- Maintains session heartbeat to keep the connection alive
- Falls back gracefully if session expires

### Security Considerations

1. **API Key Storage**: Store API keys securely, never in code
2. **Session Timeout**: Sessions expire after inactivity (default: 15 minutes)
3. **Permission Isolation**: Each user session has only their TrueNAS permissions
4. **Audit Logging**: All actions are logged with the acting user/service

### Migration Guide

To migrate from legacy to hybrid mode:

1. Ensure you have a service account with API key in TrueNAS
2. Update your `.env` file:
   ```env
   TRUENAS_API_KEY=your-service-account-api-key
   TRUENAS_USERNAME=service-account
   AUTH_MODE=hybrid
   ```
3. Restart the backend
4. Users can now log in with their personal TrueNAS credentials
5. Backend services continue working with the API key