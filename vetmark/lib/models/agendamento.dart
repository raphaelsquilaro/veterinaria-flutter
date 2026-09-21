class Agendamento {
  final int? id;
  final DateTime dataHora;
  final String status;
  final String? observacoes;

  final int? clienteId;
  final String? clienteNome;

  final int? petId;
  final String? petNome;

  final int? veterinarioId;
  final String? veterinarioNome;

  final int? servicoId;
  final String? servicoNome;

  Agendamento({
    this.id,
    required this.dataHora,
    required this.status,
    this.observacoes,
    this.clienteId,
    this.clienteNome,
    this.petId,
    this.petNome,
    this.veterinarioId,
    this.veterinarioNome,
    this.servicoId,
    this.servicoNome,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      dataHora: DateTime.parse(json['dataHora']),
      status: json['status'] ?? '',
      observacoes: json['observacoes'],

      clienteId: json['clienteId'],
      clienteNome: json['clienteNome'],

      petId: json['petId'],
      petNome: json['petNome'],

      veterinarioId: json['veterinarioId'],
      veterinarioNome: json['veterinarioNome'],

      servicoId: json['servicoId'],
      servicoNome: json['servicoNome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataHora': dataHora.toIso8601String(),
      'status': status,
      'observacoes': observacoes,

      'clienteId': clienteId,
      'clienteNome': clienteNome,

      'petId': petId,
      'petNome': petNome,

      'veterinarioId': veterinarioId,
      'veterinarioNome': veterinarioNome,

      'servicoId': servicoId,
      'servicoNome': servicoNome,
    };
  }
}