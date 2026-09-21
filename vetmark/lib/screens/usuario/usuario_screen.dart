import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController =
      TextEditingController(text: 'Cliente VetMark');

  final _emailController =
      TextEditingController(text: 'cliente@email.com');

  final _telefoneController =
      TextEditingController(text: '(00) 00000-0000');

  final _cpfController =
      TextEditingController(text: '000.000.000-00');

  bool _editando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _salvarAlteracoes() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _editando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dados atualizados com sucesso!',
        ),
      ),
    );
  }

  void _sair() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.logout,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Meu perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_editando)
            IconButton(
              onPressed: () {
                setState(() {
                  _editando = true;
                });
              },
              icon: const Icon(
                Icons.edit_outlined,
              ),
              tooltip: 'Editar',
            ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProfileHeader(),

                const SizedBox(height: 28),

                _buildPersonalDataCard(),

                const SizedBox(height: 20),

                _buildAccountCard(),

                const SizedBox(height: 20),

                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.home,
              );
              break;

            case 1:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.pets,
              );
              break;

            case 2:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.agendamentos,
              );
              break;

            case 3:
              break;
          }
        },
        backgroundColor: AppTheme.surface,
        indicatorColor: AppTheme.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: AppTheme.primary,
            ),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(
              Icons.pets,
              color: AppTheme.primary,
            ),
            label: 'Pets',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(
              Icons.calendar_month,
              color: AppTheme.primary,
            ),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: AppTheme.primary,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primary.withValues(
                alpha: 0.2,
              ),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 52,
            color: AppTheme.primary,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          _nomeController.text,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          _emailController.text,
          style: const TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalDataCard() {
    return _buildCard(
      title: 'Dados pessoais',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _buildTextField(
            controller: _nomeController,
            label: 'Nome completo',
            icon: Icons.person_outline,
            enabled: _editando,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe seu nome';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _emailController,
            label: 'E-mail',
            icon: Icons.email_outlined,
            enabled: _editando,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe seu e-mail';
              }

              if (!value.contains('@')) {
                return 'Informe um e-mail válido';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _telefoneController,
            label: 'Telefone',
            icon: Icons.phone_outlined,
            enabled: _editando,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe seu telefone';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _cpfController,
            label: 'CPF',
            icon: Icons.badge_outlined,
            enabled: false,
          ),

          if (_editando) ...[
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvarAlteracoes,
                child: const Text(
                  'Salvar alterações',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: () {
                setState(() {
                  _editando = false;
                });
              },
              child: const Text(
                'Cancelar',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return _buildCard(
      title: 'Conta',
      icon: Icons.settings_outlined,
      child: Column(
        children: [
          _buildAccountOption(
            icon: Icons.lock_outline,
            title: 'Alterar senha',
            subtitle: 'Atualize sua senha de acesso',
            onTap: () {
              // Será conectado ao fluxo de alteração
              // de senha posteriormente.
            },
          ),

          const Divider(
            height: 24,
            color: AppTheme.border,
          ),

          _buildAccountOption(
            icon: Icons.notifications_none_outlined,
            title: 'Notificações',
            subtitle: 'Configure suas notificações',
            onTap: () {
              // Configurações de notificações.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
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
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _sair,
        icon: const Icon(
          Icons.logout,
          color: AppTheme.danger,
        ),
        label: const Text(
          'Sair da conta',
          style: TextStyle(
            color: AppTheme.danger,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          side: const BorderSide(
            color: AppTheme.danger,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primary,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}