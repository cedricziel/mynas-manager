# MyNAS Manager

A user-friendly management interface for TrueNAS SCALE, inspired by Synology's DSM interface.

## Overview

MyNAS Manager provides a modern web-based interface to manage your TrueNAS SCALE server. It consists of:

- **Backend**: Dart server with JSON-RPC2 API that connects to TrueNAS
- **Frontend**: Flutter web application with a desktop-like experience
- **Shared**: Common models and utilities shared between frontend and backend

## Features

- **Dashboard**: System overview with real-time metrics
- **Storage Management**: Manage pools and datasets
- **Share Management**: Configure SMB, NFS, and other network shares
- **User-Friendly Interface**: Designed for both beginners and power users

## Project Structure

```
mynas-manager/
├── backend/          # Dart backend server
├── frontend/         # Flutter web application
├── shared/           # Shared Dart package
└── mynas-manager.code-workspace  # VS Code workspace
```

## Prerequisites

- Dart SDK 3.8.1 or later
- Flutter SDK 3.0 or later
- TrueNAS SCALE server with API access

## Getting Started

### 1. Install Dependencies

```bash
# Install dependencies for all packages (from root directory)
dart pub get
```

### 2. Configure Backend

Create a `.env` file in the backend directory:

```bash
cp backend/.env.example backend/.env
```

Edit the `.env` file with your TrueNAS configuration:

```env
TRUENAS_URL=http://your-truenas-ip/api/v2.0
TRUENAS_API_KEY=your-api-key-here
```

### 3. Run the Application

**Option 1: Using VS Code**

Open the workspace file `mynas-manager.code-workspace` in VS Code and use the "Full Stack" launch configuration.

**Option 2: Manual**

```bash
# Terminal 1 - Run backend
cd backend
dart run bin/server.dart

# Terminal 2 - Run frontend
cd frontend
flutter run -d chrome --web-port 3000
```

## Development

### Code Generation

The project uses code generation for models and providers:

```bash
# Generate code for shared models
cd shared
dart run build_runner build --delete-conflicting-outputs

# Generate code for frontend providers
cd frontend
dart run build_runner build --delete-conflicting-outputs
```

### Running Tests

```bash
# Run all tests
cd shared && dart test && cd ..
cd backend && dart test && cd ..
cd frontend && flutter test && cd ..
```

## Docker

The application can be containerized for easy deployment.

### Building the Docker Image

```bash
docker build -t mynas-manager .
```

### Running with Docker

```bash
# Using docker run
docker run -p 80:80 \
  -e TRUENAS_URL=ws://your-truenas-ip/api/current \
  -e TRUENAS_API_KEY=your-api-key \
  mynas-manager

# Using docker-compose
docker-compose up
```

### Environment Variables

Configure the container using these environment variables:

- `TRUENAS_URL`: TrueNAS WebSocket URL (e.g., `ws://192.168.1.100/api/current`)
- `TRUENAS_API_KEY`: Your TrueNAS API key

The container exposes port 80 and includes both the backend server and frontend web application.

## Workspace Structure

This project uses Dart pub workspaces for monorepo management, which provides:
- Single dependency resolution across all packages
- Improved performance and faster analysis
- Simplified dependency management

## Architecture

### Backend

- Built with Shelf for HTTP server
- JSON-RPC2 for API protocol
- Connects to TrueNAS SCALE API
- Provides abstraction layer for frontend

### Frontend

- Flutter web application
- Riverpod for state management
- Go Router for navigation
- Responsive design for desktop and mobile

### Shared

- Common data models using Freezed
- JSON serialization with json_serializable
- Shared utilities and constants

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0). See LICENSE file for details.