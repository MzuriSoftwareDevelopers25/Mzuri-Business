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
apps/web/venv/
apps/mobile/venv/

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

# Create virtual environments with error handling
echo "🐍 Creating Python Virtual Environments..."
python -m venv Mzuri-Business/backend/venv && echo "✅ Backend venv created." || { echo "❌ Failed to create backend venv"; exit 1; }
python -m venv Mzuri-Business/apps/web/venv && echo "✅ Web venv created." || { echo "❌ Failed to create web venv"; exit 1; }
python -m venv Mzuri-Business/apps/mobile/venv && echo "✅ Mobile venv created." || { echo "❌ Failed to create mobile venv"; exit 1; }

echo "📄 Creating and Populating Files..."

# Check OS to use correct virtual environment activation path
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    VENV_ACTIVATE_BACKEND="Mzuri-Business/backend/venv/Scripts/activate"
    VENV_ACTIVATE_WEB="Mzuri-Business/apps/web/venv/Scripts/activate"
    VENV_ACTIVATE_MOBILE="Mzuri-Business/apps/mobile/venv/Scripts/activate"
else
    VENV_ACTIVATE_BACKEND="Mzuri-Business/backend/venv/bin/activate"
    VENV_ACTIVATE_WEB="Mzuri-Business/apps/web/venv/bin/activate"
    VENV_ACTIVATE_MOBILE="Mzuri-Business/apps/mobile/venv/bin/activate"
fi

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

# Create requirements.txt for each part
cat <<EOL > Mzuri-Business/backend/requirements.txt
django
djangorestframework
mysqlclient
corsheaders
EOL

cat <<EOL > Mzuri-Business/apps/web/requirements.txt
react
vite
react-dom
axios
redux
EOL

cat <<EOL > Mzuri-Business/apps/mobile/requirements.txt
react-native
expo
react-navigation
axios
redux
EOL

# Create README file
cat <<EOL > Mzuri-Business/README.md
# Mzuri Business
## Setup Instructions
1. Install dependencies:
   - Backend: \`source $VENV_ACTIVATE_BACKEND && pip install -r Mzuri-Business/backend/requirements.txt\`
   - Web: \`source $VENV_ACTIVATE_WEB && npm install --prefix Mzuri-Business/apps/web\`
   - Mobile: \`source $VENV_ACTIVATE_MOBILE && npm install --prefix Mzuri-Business/apps/mobile\`
2. Start backend: \`cd Mzuri-Business/backend && python manage.py runserver\`
3. Start web app: \`cd Mzuri-Business/apps/web && npm run dev\`
4. Start mobile app: \`cd Mzuri-Business/apps/mobile && expo start\`
EOL

echo "✅ Setup Complete! Your project structure is now fully ready."
