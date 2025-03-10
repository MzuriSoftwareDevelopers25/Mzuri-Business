from django.contrib import admin
from django.urls import path, include
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from django.http import JsonResponse

# Health check endpoint
def health_check(request):
    return JsonResponse({'status': 'ok'})

# Swagger/OpenAPI documentation setup
schema_view = get_schema_view(
    openapi.Info(
        title="Mzuri-Business API",
        default_version='v1',
        description="API documentation for the Mzuri-Business platform",
        terms_of_service="https://yourapp.com/terms/",
        contact=openapi.Contact(email="contact@yourapp.com"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
)

urlpatterns = [
    # Admin panel
    path('admin/', admin.site.urls),
    path('api/auth/', include('api.urls')),
    path('health/', health_check, name='health-check'),
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
]