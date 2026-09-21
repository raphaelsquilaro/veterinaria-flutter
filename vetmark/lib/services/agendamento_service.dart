import '../models/agendamento.dart';
import 'api_service.dart';

class AgendamentoService {
  final ApiService apiService;

  AgendamentoService({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  Future<List<Agendamento>> listar() async {
    final data =
        await apiService.getList('/api/agendamentos');

    return data
        .map(
          (json) => Agendamento.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Agendamento> buscar(int id) async {
    final data =
        await apiService.get('/api/agendamentos/$id');

    return Agendamento.fromJson(data);
  }

  Future<Agendamento> criar(
    Map<String, dynamic> dados,
  ) async {
    final data = await apiService.post(
      '/api/agendamentos',
      dados,
    );

    return Agendamento.fromJson(data);
  }

  Future<Agendamento> atualizar(
    int id,
    Map<String, dynamic> dados,
  ) async {
    final data = await apiService.put(
      '/api/agendamentos/$id',
      dados,
    );

    return Agendamento.fromJson(data);
  }

  Future<void> excluir(int id) async {
    await apiService.delete(
      '/api/agendamentos/$id',
    );
  }
}