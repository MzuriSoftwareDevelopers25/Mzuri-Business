from django.urls import path
from . import views  # Import your views

urlpatterns = [
    path('', views.api_home, name='api_home'),  # Define a default API route
]
