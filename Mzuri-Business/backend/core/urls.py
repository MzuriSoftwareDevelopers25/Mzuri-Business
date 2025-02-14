from django.contrib import admin
from django.urls import path, include
from api.views import api_home  # Import the home view

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
    path('', api_home, name='api_home'),  # ✅ Add this line to handle requests to `/`
]
