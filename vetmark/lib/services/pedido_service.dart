import '../models/pedido.dart';
import 'api_service.dart';

class PedidoService {
  final ApiService apiService;

  PedidoService({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  Future<List<Pedido>> listar() async {
    final data =
        await apiService.getList('/api/pedidos');

    return data
        .map(
          (json) => Pedido.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Pedido> buscar(int id) async {
    final data =
        await apiService.get('/api/pedidos/$id');

    return Pedido.fromJson(data);
  }

  Future<Pedido> criar(
    Map<String, dynamic> dados,
  ) async {
    final data = await apiService.post(
      '/api/pedidos',
      dados,
    );

    return Pedido.fromJson(data);
  }

  Future<Pedido> atualizar(
    int id,
    Map<String, dynamic> dados,
  ) async {
    final data = await apiService.put(
      '/api/pedidos/$id',
      dados,
    );

    return Pedido.fromJson(data);
  }

  Future<void> excluir(int id) async {
    await apiService.delete(
      '/api/pedidos/$id',
    );
  }
}