#!/bin/bash

echo "📁 Creating Project Directories..."
mkdir -p Mzuri-Business/apps/web/src/components
mkdir -p Mzuri-Business/apps/web/src/pages
mkdir -p Mzuri-Business/apps/web/src/hooks
mkdir -p Mzuri-Business/apps/web/src/utils
mkdir -p Mzuri-Business/apps/web/src/context
mkdir -p Mzuri-Business/apps/web/src/services
mkdir -p Mzuri-Business/apps/web/src/styles
mkdir -p Mzuri-Business/apps/mobile/src/screens
mkdir -p Mzuri-Business/apps/mobile/src/components
mkdir -p Mzuri-Business/apps/mobile/src/context
mkdir -p Mzuri-Business/apps/mobile/src/services
mkdir -p Mzuri-Business/apps/mobile/src/utils
mkdir -p Mzuri-Business/backend/core
mkdir -p Mzuri-Business/backend/api/models
mkdir -p Mzuri-Business/backend/api/views
mkdir -p Mzuri-Business/backend/api/serializers
mkdir -p Mzuri-Business/backend/database/migrations
mkdir -p Mzuri-Business/database
mkdir -p Mzuri-Business/docker
mkdir -p Mzuri-Business/shared/constants
mkdir -p Mzuri-Business/shared/hooks
mkdir -p Mzuri-Business/shared/styles
mkdir -p Mzuri-Business/tests/unit
mkdir -p Mzuri-Business/tests/integration
mkdir -p Mzuri-Business/tests/e2e
mkdir -p Mzuri-Business/scripts

echo "✅ Directories created successfully."

# Add .gitkeep files to empty directories
find Mzuri-Business -type d -empty -exec touch {}/.gitkeep \;

echo "✅ Added .gitkeep files to all empty directories."

# Create .gitignore file
cat <<EOL > Mzuri-Business/.gitignore
# Ignore Python virtual environments
backend/venv/

# Ignore node_modules
apps/web/node_modules/
apps/mobile/node_modules/

# Ignore system files
.DS_Store
Thumbs.db

# Ignore compiled Python files
__pycache__/
*.pyc
*.pyo
EOL

echo "✅ Created .gitignore file."

# Create virtual environment for backend
echo "🐍 Creating Python Virtual Environment for Backend..."
python -m venv Mzuri-Business/backend/venv && echo "✅ Backend venv created." || { echo "❌ Failed to create backend venv"; exit 1; }

echo "📄 Creating and Populating Files..."

# Check OS to use correct virtual environment activation path
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    VENV_ACTIVATE_BACKEND="Mzuri-Business/backend/venv/Scripts/activate"
else
    VENV_ACTIVATE_BACKEND="Mzuri-Business/backend/venv/bin/activate"
fi

# Create backend requirements.txt
cat <<EOL > Mzuri-Business/backend/requirements.txt
django
djangorestframework
mysqlclient
corsheaders
EOL

# Create web package.json
cat <<EOL > Mzuri-Business/apps/web/package.json
{
  "name": "mzuri-web",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "serve": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^4.0.0"
  }
}
EOL

# Create mobile package.json
cat <<EOL > Mzuri-Business/apps/mobile/package.json
{
  "name": "mzuri-mobile",
  "version": "1.0.0",
  "main": "App.tsx",
  "dependencies": {
    "expo": "~48.0.0",
    "react-native": "0.72.0"
  }
}
EOL

# Create web entry point
cat <<EOL > Mzuri-Business/apps/web/src/main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './styles/global.css';

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOL

# Create mobile entry point
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

# Create README file
cat <<EOL > Mzuri-Business/README.md
# Mzuri Business
## Setup Instructions
1. Install dependencies:
   - Backend: \`source $VENV_ACTIVATE_BACKEND && pip install -r Mzuri-Business/backend/requirements.txt\`
   - Web: \`cd Mzuri-Business/apps/web && npm install\`
   - Mobile: \`cd Mzuri-Business/apps/mobile && npm install\`
2. Start backend: \`cd Mzuri-Business/backend && python manage.py runserver\`
3. Start web app: \`cd Mzuri-Business/apps/web && npm run dev\`
4. Start mobile app: \`cd Mzuri-Business/apps/mobile && expo start\`
EOL

echo "✅ Setup Complete! Your project structure is now fully ready."
