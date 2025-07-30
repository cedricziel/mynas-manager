# TrueNAS Client Examples

This directory contains examples demonstrating how to use the TrueNAS client library.

## Basic Pool Listing Example

The `main.dart` file shows a complete example of:

1. **Creating a TrueNAS client** with username/API key authentication
2. **Connecting** to TrueNAS server via WebSocket
3. **Authenticating** using the auth.login_ex method
4. **Fetching system information**
5. **Listing storage pools** with detailed information
6. **Error handling** for common scenarios
7. **Proper cleanup** and connection management

### Prerequisites

1. **TrueNAS SCALE server** running and accessible (version 25.10+ recommended)
2. **API key** generated in TrueNAS (System Settings > API Keys > Add)
3. **Username** with appropriate permissions
4. **Network access** to TrueNAS WebSocket endpoint

### Setup

1. **Set environment variables** with your TrueNAS connection details:
   ```bash
   export TRUENAS_URL="wss://your-truenas-ip/api/current"
   export TRUENAS_USERNAME="your-username"
   export TRUENAS_API_KEY="your-api-key-here"
   ```

2. **Replace the placeholders**:
   - `your-truenas-ip`: Your TrueNAS server IP address (e.g., `192.168.1.100`)
   - `your-username`: Your TrueNAS username
   - `your-api-key-here`: Your generated API key

⚠️ **Important**: Use `wss://` for secure connections when using API key authentication.

### Running the Example

```bash
# Set environment variables
export TRUENAS_URL="wss://192.168.1.100/api/current"
export TRUENAS_USERNAME="your-username"
export TRUENAS_API_KEY="1-AbCdEfGhIjKlMnOpQrStUvWxYz1234567890"

# Run the example from the truenas_client directory
dart run example/main.dart
```

#### Alternative: Using a .env file

For convenience during development, you can create a `.env` file:

```bash
# Create .env file in the example directory
cat > example/.env << EOF
TRUENAS_URL=wss://192.168.1.100/api/current
TRUENAS_USERNAME=your-username
TRUENAS_API_KEY=your-api-key-here
EOF

# Run with environment variables from .env
env $(cat example/.env | xargs) dart run example/main.dart
```

⚠️ **Never commit .env files to version control!** Add `*.env` to your `.gitignore`.

### Expected Output

```
🔧 TrueNAS Client Example - Pool Listing
=========================================
Connecting to: wss://192.168.1.100/api/current
Username: your-username

📡 Creating TrueNAS client with username/API key authentication...
🔌 Connecting to TrueNAS server...
✅ Connected and authenticated successfully!
ℹ️  Fetching system information...
📋 System: truenas.local (TrueNAS-SCALE-24.04.0)
⏱️  Uptime: 15 days, 8:42:30
💾 Memory: 12.3 GB/32.0 GB used

🏊 Fetching storage pools...
📦 Found 2 storage pool(s):

✅ tank (ONLINE)
   Size: 4.0 TB
   Used: 1.2 TB (30.5%)
   Free: 2.8 TB
   Path: /mnt/tank
   Fragmentation: 2.1%
   VDevs: 2

✅ backup (ONLINE)
   Size: 8.0 TB
   Used: 456.8 GB (5.6%)
   Free: 7.6 TB
   Path: /mnt/backup
   VDevs: 1

🧪 Testing error handling...
✅ Error handling working: Pool with id non-existent-pool not found
🧹 Cleaning up connection...
✅ Disconnected successfully!
```

### API Key Generation

To generate an API key in TrueNAS SCALE:

1. Go to **System Settings** → **API Keys**
2. Click **Add** to create a new API key
3. Set appropriate **Name** and **Reset Call Rate Limit**
4. Copy the generated key (you won't see it again!)

### Error Handling

The example demonstrates handling common errors:

- **Authentication failures** (invalid API key)
- **Connection failures** (network issues, wrong URL)
- **Resource not found** (invalid pool names)
- **General TrueNAS exceptions**

### Security Notes

⚠️ **Never commit API keys to version control!**

- Use environment variables for production
- Store keys securely
- Rotate keys regularly
- Use least-privilege principle for API key permissions
