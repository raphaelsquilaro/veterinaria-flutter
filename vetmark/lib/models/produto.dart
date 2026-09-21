class Produto {
  final int? id;
  final String nome;
  final String? descricao;
  final double preco;
  final int estoque;
  final bool ativo;

  Produto({
    this.id,
    required this.nome,
    this.descricao,
    required this.preco,
    required this.estoque,
    required this.ativo,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      estoque: json['estoque'] ?? 0,
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque,
      'ativo': ativo,
    };
  }
}