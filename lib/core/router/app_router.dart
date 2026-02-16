import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cashpilot_v2/presentation/screens/login_screen.dart';
import 'package:cashpilot_v2/presentation/screens/register_screen.dart';
import 'package:cashpilot_v2/presentation/screens/dashboard_screen.dart';
import 'package:cashpilot_v2/presentation/screens/test_data_screen.dart';
import 'package:cashpilot_v2/data/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLogged = ref.read(isAuthenticatedProvider);
      final currentPath = state.uri.path;

      // Se não estiver logado e não estiver na tela de login/cadastro
      if (!isLogged && currentPath != '/login' && currentPath != '/register') {
        return '/login';
      }

      // Se estiver logado e estiver na tela de login/cadastro
      if (isLogged && (currentPath == '/login' || currentPath == '/register')) {
        return '/dashboard';
      }

      return null; // mantém rota atual
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/test-data',
        builder: (context, state) => const TestDataScreen(),
      ),
    ],
  );
});
