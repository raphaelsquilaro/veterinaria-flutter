import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/pet.dart';
import '../../services/pet_service.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final PetService _petService = PetService();

  late Future<List<Pet>> _petsFuture;

  @override
  void initState() {
    super.initState();
    _carregarPets();
  }

  void _carregarPets() {
    _petsFuture = _petService.listar();
  }

  Future<void> _atualizar() async {
    setState(() {
      _carregarPets();
    });

    await _petsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Meus pets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: FutureBuilder<List<Pet>>(
          future: _petsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primary,
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildError();
            }

            final pets = snapshot.data ?? [];

            if (pets.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: pets.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildPetCard(pets[index]);
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(
            context,
            AppRoutes.cadastroPet,
          );

          if (resultado == true && mounted) {
            setState(() {
              _carregarPets();
            });
          }
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo pet'),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.home,
              );
              break;

            case 1:
              break;

            case 2:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.agendamentos,
              );
              break;

            case 3:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.usuario,
              );
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

  Widget _buildPetCard(Pet pet) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.pets,
              color: AppTheme.primary,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.nome,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _formatarEspecie(pet.especie),
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 14,
                  ),
                ),

                if (pet.raca != null &&
                    pet.raca!.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    pet.raca!,
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],

                if (pet.dataNascimento != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Nascimento: ${_formatarData(pet.dataNascimento!)}',
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              // Edição será adicionada depois.
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

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),

        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.pets,
            size: 48,
            color: AppTheme.primary,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Você ainda não possui pets cadastrados',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Cadastre seu pet para acompanhar consultas, '
          'agendamentos e informações importantes.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 28),

        ElevatedButton.icon(
          onPressed: () async {
            final resultado = await Navigator.pushNamed(
              context,
              AppRoutes.cadastroPet,
            );

            if (resultado == true && mounted) {
              setState(() {
                _carregarPets();
              });
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Cadastrar meu primeiro pet'),
        ),
      ],
    );
  }

  Widget _buildError() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 100),

        const Icon(
          Icons.cloud_off_outlined,
          size: 60,
          color: AppTheme.danger,
        ),

        const SizedBox(height: 20),

        const Text(
          'Não foi possível carregar seus pets',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Verifique sua conexão com o servidor e tente novamente.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryText,
          ),
        ),

        const SizedBox(height: 24),

        OutlinedButton(
          onPressed: () {
            setState(() {
              _carregarPets();
            });
          },
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }

  String _formatarEspecie(String especie) {
    switch (especie.toUpperCase()) {
      case 'CACHORRO':
        return 'Cachorro';
      case 'GATO':
        return 'Gato';
      case 'AVE':
        return 'Ave';
      case 'COELHO':
        return 'Coelho';
      default:
        return especie;
    }
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }
}