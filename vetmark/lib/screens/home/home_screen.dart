import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        Navigator.pushNamed(
          context,
          AppRoutes.pets,
        );
        break;

      case 2:
        Navigator.pushNamed(
          context,
          AppRoutes.agendamentos,
        );
        break;

      case 3:
        Navigator.pushNamed(
          context,
          AppRoutes.usuario,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'VetMark',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.usuario,
              );
            },
            icon: const Icon(
              Icons.account_circle_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _atualizarPagina,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(),

                const SizedBox(height: 24),

                _buildNextAppointment(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Acesso rápido',
                  'O que você deseja fazer?',
                ),

                const SizedBox(height: 14),

                _buildQuickActions(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Meus pets',
                  'Acompanhe seus companheiros',
                ),

                const SizedBox(height: 14),

                _buildPetsSummary(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Pedidos',
                  'Consulte seus pedidos recentes',
                ),

                const SizedBox(height: 14),

                _buildOrdersCard(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildGreeting() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá! 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Bem-vindo ao VetMark',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Próximo agendamento',
          null,
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nenhum agendamento',
                      style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Você ainda não possui consultas agendadas.',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.cadastroAgendamento,
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickAction(
            icon: Icons.pets_outlined,
            title: 'Meus pets',
            color: AppTheme.primary,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.pets,
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildQuickAction(
            icon: Icons.calendar_month_outlined,
            title: 'Agendar',
            color: AppTheme.secondary,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.cadastroAgendamento,
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildQuickAction(
            icon: Icons.receipt_long_outlined,
            title: 'Pedidos',
            color: AppTheme.warning,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.pedidos,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.text,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetsSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.pets,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seus pets',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Cadastre seus companheiros para acompanhar a saúde deles.',
                  style: TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.pets,
              );
            },
            icon: const Icon(
              Icons.chevron_right,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersCard() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.pedidos,
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.secondaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppTheme.secondary,
              ),
            ),

            const SizedBox(width: 14),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meus pedidos',
                    style: TextStyle(
                      color: AppTheme.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Veja seus pedidos e acompanhe seus itens.',
                    style: TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppTheme.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String? subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onNavigationTap,
      backgroundColor: AppTheme.surface,
      indicatorColor: AppTheme.primaryLight,
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home,
            color: AppTheme.primary,
          ),
          label: 'Início',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.pets_outlined,
          ),
          selectedIcon: Icon(
            Icons.pets,
            color: AppTheme.primary,
          ),
          label: 'Pets',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.calendar_month_outlined,
          ),
          selectedIcon: Icon(
            Icons.calendar_month,
            color: AppTheme.primary,
          ),
          label: 'Agenda',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
          ),
          selectedIcon: Icon(
            Icons.person,
            color: AppTheme.primary,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }

  Future<void> _atualizarPagina() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    setState(() {});
  }
}