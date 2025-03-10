from rest_framework import permissions

class IsSeller(permissions.BasePermission):
    def has_permission(self, request, view):
        # Check if user is authenticated and has a seller profile
        return request.user.is_authenticated and hasattr(request.user, 'seller')

class IsApprovedSeller(permissions.BasePermission):
    def has_permission(self, request, view):
        # Check if seller is approved by admin
        return request.user.is_authenticated and \
               hasattr(request.user, 'seller') and \
               request.user.seller.is_approved