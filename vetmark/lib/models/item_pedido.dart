class ItemPedido {
  final int? id;
  final int produtoId;
  final String? produtoNome;
  final int quantidade;
  final double valorUnitario;
  final double valorTotal;

  ItemPedido({
    this.id,
    required this.produtoId,
    this.produtoNome,
    required this.quantidade,
    required this.valorUnitario,
    required this.valorTotal,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      id: json['id'],
      produtoId: json['produtoId'],
      produtoNome: json['produtoNome'],
      quantidade: json['quantidade'] ?? 0,
      valorUnitario:
          (json['valorUnitario'] as num?)?.toDouble() ?? 0.0,
      valorTotal:
          (json['valorTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produtoId': produtoId,
      'produtoNome': produtoNome,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
      'valorTotal': valorTotal,
    };
  }
}