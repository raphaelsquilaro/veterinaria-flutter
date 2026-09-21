class Pet {
  final int? id;
  final String nome;
  final String especie;
  final String? raca;
  final DateTime? dataNascimento;
  final int? clienteId;
  final String? clienteNome;

  Pet({
    this.id,
    required this.nome,
    required this.especie,
    this.raca,
    this.dataNascimento,
    this.clienteId,
    this.clienteNome,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      raca: json['raca'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.parse(json['dataNascimento'])
          : null,
      clienteId: json['clienteId'],
      clienteNome: json['clienteNome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'dataNascimento': dataNascimento?.toIso8601String().split('T').first,
      'clienteId': clienteId,
      'clienteNome': clienteNome,
    };
  }
}
