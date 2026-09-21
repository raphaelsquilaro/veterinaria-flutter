import 'item_pedido.dart';

class Pedido {
  final int? id;
  final DateTime dataPedido;
  final String status;
  final double valorTotal;

  final int? clienteId;
  final String? clienteNome;

  final List<ItemPedido> itens;

  Pedido({
    this.id,
    required this.dataPedido,
    required this.status,
    required this.valorTotal,
    this.clienteId,
    this.clienteNome,
    required this.itens,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      dataPedido: DateTime.parse(json['dataPedido']),
      status: json['status'] ?? '',
      valorTotal:
          (json['valorTotal'] as num?)?.toDouble() ?? 0.0,

      clienteId: json['clienteId'],
      clienteNome: json['clienteNome'],

      itens: (json['itens'] as List<dynamic>? ?? [])
          .map(
            (item) => ItemPedido.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataPedido': dataPedido.toIso8601String(),
      'status': status,
      'valorTotal': valorTotal,

      'clienteId': clienteId,
      'clienteNome': clienteNome,

      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }
}