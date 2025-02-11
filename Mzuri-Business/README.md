# Mzuri Business
## Setup Instructions
1. Install dependencies:
   - Backend: `source Mzuri-Business/backend/venv/Scripts/activate && pip install -r Mzuri-Business/backend/requirements.txt`
   - Web: `source Mzuri-Business/apps/web/venv/Scripts/activate && npm install --prefix Mzuri-Business/apps/web`
   - Mobile: `source Mzuri-Business/apps/mobile/venv/Scripts/activate && npm install --prefix Mzuri-Business/apps/mobile`
2. Start backend: `cd Mzuri-Business/backend && python manage.py runserver`
3. Start web app: `cd Mzuri-Business/apps/web && npm run dev`
4. Start mobile app: `cd Mzuri-Business/apps/mobile && expo start`
