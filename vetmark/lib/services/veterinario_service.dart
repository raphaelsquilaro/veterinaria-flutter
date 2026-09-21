import '../models/veterinario.dart';
import 'api_service.dart';

class VeterinarioService {
  final ApiService apiService;

  VeterinarioService({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  Future<List<Veterinario>> listar() async {
    final data =
        await apiService.getList('/api/veterinarios');

    return data
        .map(
          (json) => Veterinario.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Veterinario> buscar(int id) async {
    final data =
        await apiService.get('/api/veterinarios/$id');

    return Veterinario.fromJson(data);
  }
}