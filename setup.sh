#!/bin/bash

echo "📁 Creating Project Directories..."
mkdir -p Mzuri-Business/apps/web/src/components
mkdir -p Mzuri-Business/apps/mobile/src/screens
mkdir -p Mzuri-Business/backend/core  # Fix: Ensure this directory exists
mkdir -p Mzuri-Business/backend/api/models
mkdir -p Mzuri-Business/backend/api/views
mkdir -p Mzuri-Business/backend/api/serializers
mkdir -p Mzuri-Business/database/migrations
mkdir -p Mzuri-Business/docker

echo "📄 Creating and Populating Files..."

# Create Django settings.py
cat <<EOL > Mzuri-Business/backend/core/settings.py
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'rest_framework',
    'corsheaders',
    'api',
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'mzuri_db',
        'USER': 'root',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}

CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:8081",
]
EOL

# Create React Web Entry Point
cat <<EOL > Mzuri-Business/apps/web/src/main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOL

# Create React Native Entry Point
cat <<EOL > Mzuri-Business/apps/mobile/App.tsx
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>Mzuri Business Mobile App</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
EOL

# Create Docker Compose File
cat <<EOL > Mzuri-Business/docker/docker-compose.yml
version: '3.8'
services:
  backend:
    build: ../backend
    ports:
      - "8000:8000"
    depends_on:
      - db
  db:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: mzuri_db
      MYSQL_ROOT_PASSWORD: password
    ports:
      - "3306:3306"
EOL

echo "✅ Setup Complete! Your project structure is ready."
