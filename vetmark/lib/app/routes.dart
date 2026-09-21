import 'package:flutter/material.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/cadastro/cadastro_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/usuario/usuario_screen.dart';
import '../screens/pets/pets_screen.dart';
import '../screens/pets/cadastro_pet_screen.dart';
import '../screens/agendamentos/agendamentos_screen.dart';
import '../screens/agendamentos/cadastro_agendamento_screen.dart';
import '../screens/pedidos/pedidos_screen.dart';
import '../screens/pedidos/cadastro_pedido_screen.dart';
import '../screens/logout/logout_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';

  static const String home = '/home';
  static const String usuario = '/usuario';

  static const String pets = '/pets';
  static const String cadastroPet = '/pets/cadastro';

  static const String agendamentos = '/agendamentos';
  static const String cadastroAgendamento =
      '/agendamentos/cadastro';

  static const String pedidos = '/pedidos';
  static const String cadastroPedido =
      '/pedidos/cadastro';

  static const String logout = '/logout';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),

    login: (context) => const LoginScreen(),

    cadastro: (context) => const CadastroScreen(),

    home: (context) => const HomeScreen(),

    usuario: (context) => const UsuarioScreen(),

    pets: (context) => const PetsScreen(),

    cadastroPet: (context) =>
        const CadastroPetScreen(),

    agendamentos: (context) =>
        const AgendamentosScreen(),

    cadastroAgendamento: (context) =>
        const CadastroAgendamentoScreen(),

    pedidos: (context) =>
        const PedidosScreen(),

    cadastroPedido: (context) =>
        const CadastroPedidoScreen(),

    logout: (context) =>
        const LogoutScreen(),
  };
}