class Cliente {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String cpf;
  final DateTime? dataCadastro;

  Cliente({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cpf,
    required this.dataCadastro,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      dataCadastro: json['dataCadastro'] != null
          ? DateTime.parse(json['dataCadastro'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'cpf': cpf,
      'dataCadastro': dataCadastro?.toIso8601String(),
    };
  }
}
