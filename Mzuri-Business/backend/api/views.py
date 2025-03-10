from django.contrib.auth.models import User
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken, OutstandingToken, BlacklistedToken
from .serializers import UserSerializer, RegisterSerializer
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from .models import Product, Cart, CartItem, Order, OrderItem
from .serializers import ProductSerializer, CartSerializer, OrderSerializer
from django.shortcuts import get_object_or_404
from .serializers import SellerRegistrationSerializer, UserSerializer, SellerSerializer
from .permissions import IsApprovedSeller

# User Registration API
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

# Login API (JWT Token Generation)
class LoginView(generics.GenericAPIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        user = User.objects.filter(username=username).first()
        if user and user.check_password(password):
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': UserSerializer(user).data,  # Include user details
            })
        return Response({'error': 'Invalid Credentials'}, status=400)

# Get Authenticated User Details
class UserProfileView(generics.RetrieveAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user

# Logout API (Blacklist JWT Token)
class LogoutView(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get('refresh_token')
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response({'message': 'Logged out successfully'})
        except Exception as e:
            return Response({'error': str(e)}, status=400)
        
        
# Product API (Only sellers can create/edit products)
class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            # Only approved sellers can modify products
            return [permissions.IsAuthenticated(), IsApprovedSeller()]
        return [permissions.AllowAny()]

    def perform_create(self, serializer):
        seller = self.request.user.seller  # Ensure user has a Seller profile
        serializer.save(seller=seller)

# Cart API (Buyers can manage their cart)
class CartViewSet(viewsets.ModelViewSet):
    serializer_class = CartSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Cart.objects.filter(user=self.request.user)

    @action(detail=False, methods=['post'])
    def add_item(self, request):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        product_id = request.data.get('product_id')
        quantity = request.data.get('quantity', 1)
        product = get_object_or_404(Product, id=product_id)
        
        cart_item, created = CartItem.objects.get_or_create(cart=cart, product=product)
        if not created:
            cart_item.quantity += quantity
            cart_item.save()
        return Response({'message': 'Item added to cart'})

# Order API (Buyers can place orders, sellers can update status)
class OrderViewSet(viewsets.ModelViewSet):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        if self.request.user.is_seller:
            # Sellers see orders containing their products
            return Order.objects.filter(items__product__seller=self.request.user.seller).distinct()
        return Order.objects.filter(buyer=self.request.user)

    def create(self, request):
        cart = get_object_or_404(Cart, user=request.user)
        cart_items = cart.cartitem_set.all()

        # Validate stock and calculate total
        total_price = 0
        order_items = []
        for item in cart_items:
            if item.product.stock < item.quantity:
                return Response({'error': f'Insufficient stock for {item.product.name}'}, status=400)
            total_price += item.product.price * item.quantity
            order_items.append({
                'product': item.product,
                'quantity': item.quantity,
                'price_at_purchase': item.product.price,
            })

        # Create order
        order = Order.objects.create(buyer=request.user, total_price=total_price)
        for item in order_items:
            OrderItem.objects.create(order=order, **item)
            item['product'].stock -= item['quantity']  # Decrease stock
            item['product'].save()

        cart.items.all().delete()  # Clear cart
        return Response(OrderSerializer(order).data, status=201)
    
class SellerRegistrationView(generics.CreateAPIView):
    serializer_class = SellerRegistrationSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        seller = serializer.save()
        return Response({
            "user": UserSerializer(seller.user).data,
            "seller": SellerSerializer(seller).data
        }, status=status.HTTP_201_CREATED)