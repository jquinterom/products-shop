import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/config/router/app_router_notifier.dart';
import 'package:teslo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_app/features/auth/presentation/screens/screens.dart';
import 'package:teslo_app/features/products/presentation/screens/product_screen.dart';
import 'package:teslo_app/features/products/presentation/screens/products_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* First screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(path: '/', builder: (context, state) => const ProductsScreen()),
      GoRoute(
        path: '/product/:productId',
        builder: (context, state) => ProductScreen(
          productId: state.pathParameters['productId'] ?? 'no-id',
        ),
      ),
    ],

    redirect: (context, state) {
      final isGoingTo = state.fullPath;

      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return "/login";
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
