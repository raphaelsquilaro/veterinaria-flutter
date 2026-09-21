import '../models/servico.dart';
import 'api_service.dart';

class ServicoService {
  final ApiService apiService;

  ServicoService({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  Future<List<Servico>> listar() async {
    final data = await apiService.getList('/api/servicos');

    return data
        .map(
          (json) => Servico.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Servico> buscar(int id) async {
    final data = await apiService.get('/api/servicos/$id');

    return Servico.fromJson(data);
  }
}