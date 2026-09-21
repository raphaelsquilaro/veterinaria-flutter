import '../models/produto.dart';
import 'api_service.dart';

class ProdutoService {
  final ApiService apiService;

  ProdutoService({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  Future<List<Produto>> listar() async {
    final data =
        await apiService.getList('/api/produtos');

    return data
        .map(
          (json) => Produto.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .where((produto) => produto.ativo)
        .toList();
  }

  Future<Produto> buscar(int id) async {
    final data =
        await apiService.get('/api/produtos/$id');

    return Produto.fromJson(data);
  }
}