class Veterinario {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String cpf;
  final String crmv;
  final String especialidade;
  final bool ativo;

  Veterinario({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cpf,
    required this.crmv,
    required this.especialidade,
    required this.ativo,
  });

  factory Veterinario.fromJson(Map<String, dynamic> json) {
    return Veterinario(
      id: json['id'],
      nome: json['nome'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      crmv: json['crmv'] ?? '',
      especialidade: json['especialidade'] ?? '',
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'cpf': cpf,
      'crmv': crmv,
      'especialidade': especialidade,
      'ativo': ativo,
    };
  }
}