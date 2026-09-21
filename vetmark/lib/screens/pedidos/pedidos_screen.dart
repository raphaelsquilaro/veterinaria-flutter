import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/pedido.dart';
import '../../services/pedido_service.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final PedidoService _service = PedidoService();

  late Future<List<Pedido>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  void _carregarPedidos() {
    _pedidosFuture = _service.listar();
  }

  Future<void> _atualizar() async {
    setState(() {
      _carregarPedidos();
    });

    await _pedidosFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Meus pedidos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: FutureBuilder<List<Pedido>>(
          future: _pedidosFuture,
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

            final pedidos = snapshot.data ?? [];

            if (pedidos.isEmpty) {
              return _buildEmptyState();
            }

            pedidos.sort(
              (a, b) =>
                  b.dataPedido.compareTo(a.dataPedido),
            );

            return ListView.separated(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: pedidos.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _buildPedidoCard(
                  pedidos[index],
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
            AppRoutes.cadastroPedido,
          );

          if (resultado == true && mounted) {
            setState(() {
              _carregarPedidos();
            });
          }
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo pedido'),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
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

  Widget _buildPedidoCard(Pedido pedido) {
    final status = _statusInfo(pedido.status);

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
                  color: AppTheme.secondaryLight,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppTheme.secondary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      pedido.id != null
                          ? 'Pedido #${pedido.id}'
                          : 'Pedido',
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatarData(
                        pedido.dataPedido,
                      ),
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

          ...pedido.itens.map(
            (item) => Padding(
              padding:
                  const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius:
                          BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: AppTheme.secondaryText,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      '${item.quantidade}x '
                      '${item.produtoNome ?? 'Produto'}',
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Text(
                    'R\$ ${item.valorTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Divider(
            color: AppTheme.border,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 14,
                ),
              ),

              Text(
                'R\$ ${pedido.valorTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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

  Map<String, dynamic> _statusInfo(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMADO':
        return {
          'label': 'Confirmado',
          'color': AppTheme.success,
        };

      case 'PROCESSANDO':
        return {
          'label': 'Processando',
          'color': AppTheme.secondary,
        };

      case 'CANCELADO':
        return {
          'label': 'Cancelado',
          'color': AppTheme.danger,
        };

      case 'CONCLUIDO':
        return {
          'label': 'Concluído',
          'color': AppTheme.success,
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
            color: AppTheme.secondaryLight,
            borderRadius:
                BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 48,
            color: AppTheme.secondary,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Nenhum pedido encontrado',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Você ainda não possui pedidos.',
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
              AppRoutes.cadastroPedido,
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Criar pedido'),
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
          'Não foi possível carregar os pedidos',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Verifique sua conexão com o servidor '
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
              _carregarPedidos();
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
}