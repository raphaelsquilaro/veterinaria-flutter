import 'package:vetmark/models/cliente.dart';
import 'package:vetmark/services/api_service.dart';

class ClienteService {
  final ApiService apiService;

  ClienteService({ApiService? apiService})
    : apiService = apiService ?? ApiService();

  Future<List<Cliente>> listar() async {
    final data = await apiService.getList('/api/clientes');

    return data
        .map((json) => Cliente.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Cliente> buscar(int id) async {
    final data = await apiService.get('/api/clientes/$id');

    return Cliente.fromJson(data);
  }

  Future<Cliente> criar(Map<String, dynamic> dados) async {
    final data = await apiService.post(
      '/api/clientes',
      dados
    );

    return Cliente.fromJson(data);
  }

  Future<Cliente> atualizar(
    int id,
    Map<String, dynamic> dados
  ) async {
    final data = await apiService.put(
      '/api/clientes/$id', 
      dados
    );

    return Cliente.fromJson(data);
  }

  Future<void> excluir(int id) async {
    await apiService.delete('/api/clientes/$id');
  }
}
