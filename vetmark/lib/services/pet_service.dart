import 'package:vetmark/models/pet.dart';
import 'package:vetmark/services/api_service.dart';

class PetService {
  final ApiService apiService;

  PetService({ApiService? apiService})
    : apiService = apiService ?? ApiService();

  Future<List<Pet>> listar() async {
    final data = await apiService.getList('/api/pets');

    return data
        .map((json) => Pet.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Pet> buscar(int id) async {
    final data = await apiService.get('/api/pets/$id');

    return Pet.fromJson(data);
  }

  Future<Pet> criar(Map<String, dynamic> dados) async {
    final data = await apiService.post('/api/pets', dados);

    return Pet.fromJson(data);
  }

  Future<Pet> atualizar(int id, Map<String, dynamic> dados) async {
    final data = await apiService.put('/api/pets/$id', dados);

    return Pet.fromJson(data);
  }

  Future<void> excluir(int id) async {
    await apiService.delete('/api/pets/$id');
  }
}
