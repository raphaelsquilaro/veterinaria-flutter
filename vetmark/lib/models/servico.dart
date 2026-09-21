class Servico {
  final int? id;
  final String nome;
  final String? descricao;
  final double valor;
  final bool ativo;

  Servico({
    this.id,
    required this.nome,
    this.descricao,
    required this.valor,
    required this.ativo,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'ativo': ativo,
    };
  }
}