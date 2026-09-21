import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/agendamento.dart';
import '../../services/agendamento_service.dart';

class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() =>
      _AgendamentosScreenState();
}

class _AgendamentosScreenState
    extends State<AgendamentosScreen> {
  final AgendamentoService _service =
      AgendamentoService();

  late Future<List<Agendamento>> _agendamentosFuture;

  @override
  void initState() {
    super.initState();
    _carregarAgendamentos();
  }

  void _carregarAgendamentos() {
    _agendamentosFuture = _service.listar();
  }

  Future<void> _atualizar() async {
    setState(() {
      _carregarAgendamentos();
    });

    await _agendamentosFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Meus agendamentos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: FutureBuilder<List<Agendamento>>(
          future: _agendamentosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primary,
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildError();
            }

            final agendamentos =
                snapshot.data ?? [];

            if (agendamentos.isEmpty) {
              return _buildEmptyState();
            }

            agendamentos.sort(
              (a, b) => a.dataHora.compareTo(b.dataHora),
            );

            return ListView.separated(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: agendamentos.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _buildAgendamentoCard(
                  agendamentos[index],
                );
              },
            );
          },
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () async {
          final resultado =
              await Navigator.pushNamed(
            context,
            AppRoutes.cadastroAgendamento,
          );

          if (resultado == true && mounted) {
            setState(() {
              _carregarAgendamentos();
            });
          }
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agendar'),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
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

  Widget _buildAgendamentoCard(
    Agendamento agendamento,
  ) {
    final status = _statusInfo(
      agendamento.status,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      agendamento.petNome ??
                          'Pet não informado',
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      agendamento.servicoNome ??
                          'Serviço não informado',
                      style: const TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              _buildStatusBadge(status),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(
            color: AppTheme.border,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.event_outlined,
                size: 20,
                color: AppTheme.secondaryText,
              ),

              const SizedBox(width: 10),

              Text(
                _formatarData(
                  agendamento.dataHora,
                ),
                style: const TextStyle(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                size: 20,
                color: AppTheme.secondaryText,
              ),

              const SizedBox(width: 10),

              Text(
                _formatarHora(
                  agendamento.dataHora,
                ),
                style: const TextStyle(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          if (agendamento.veterinarioNome !=
              null) ...[
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  size: 20,
                  color: AppTheme.secondaryText,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'Dr(a). ${agendamento.veterinarioNome}',
                    style: const TextStyle(
                      color: AppTheme.text,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (agendamento.observacoes !=
                  null &&
              agendamento.observacoes!
                  .trim()
                  .isNotEmpty) ...[
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notes_outlined,
                  size: 20,
                  color: AppTheme.secondaryText,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    agendamento.observacoes!,
                    style: const TextStyle(
                      color:
                          AppTheme.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
    Map<String, dynamic> status,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: (status['color'] as Color)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status['label'] as String,
        style: TextStyle(
          color: status['color'] as Color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Map<String, dynamic> _statusInfo(
    String status,
  ) {
    switch (status.toUpperCase()) {
      case 'CONFIRMADO':
        return {
          'label': 'Confirmado',
          'color': AppTheme.success,
        };

      case 'CANCELADO':
        return {
          'label': 'Cancelado',
          'color': AppTheme.danger,
        };

      case 'CONCLUIDO':
        return {
          'label': 'Concluído',
          'color': AppTheme.secondary,
        };

      case 'PENDENTE':
      default:
        return {
          'label': 'Pendente',
          'color': AppTheme.warning,
        };
    }
  }

  Widget _buildEmptyState() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),

        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius:
                BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            size: 48,
            color: AppTheme.primary,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Nenhum agendamento encontrado',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Agende uma consulta para o seu pet '
          'e acompanhe tudo pelo VetMark.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 28),

        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.cadastroAgendamento,
            );
          },
          icon: const Icon(Icons.add),
          label: const Text(
            'Novo agendamento',
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
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
          'Não foi possível carregar os agendamentos',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Verifique a conexão com o servidor '
          'e tente novamente.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryText,
          ),
        ),

        const SizedBox(height: 24),

        OutlinedButton(
          onPressed: () {
            setState(() {
              _carregarAgendamentos();
            });
          },
          child: const Text(
            'Tentar novamente',
          ),
        ),
      ],
    );
  }

  String _formatarData(DateTime data) {
    final dia =
        data.day.toString().padLeft(2, '0');
    final mes =
        data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  String _formatarHora(DateTime data) {
    final hora =
        data.hour.toString().padLeft(2, '0');
    final minuto =
        data.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }
}