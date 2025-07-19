# Stage 1: Build the application
FROM dart:stable AS build

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter -b stable
ENV PATH="/flutter/bin:${PATH}"
RUN flutter doctor -v

# Set working directory
WORKDIR /app

# Copy all source code
COPY . .

# Get dependencies for all modules
RUN cd shared && dart pub get
RUN cd backend && dart pub get
RUN cd frontend && flutter pub get

# Build backend executable
RUN cd backend && dart compile exe bin/server.dart -o server

# Build frontend web
RUN cd frontend && flutter build web --release

# Stage 2: Runtime
FROM nginx:alpine

# Install runtime dependencies
RUN apk add --no-cache ca-certificates

# Copy backend executable
COPY --from=build /app/backend/server /app/server
RUN chmod +x /app/server

# Copy frontend build
COPY --from=build /app/frontend/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start both nginx and backend
CMD ["/bin/sh", "-c", "/app/server & nginx -g 'daemon off;'"]