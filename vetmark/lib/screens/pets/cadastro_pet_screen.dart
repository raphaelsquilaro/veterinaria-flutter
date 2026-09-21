import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../services/pet_service.dart';

class CadastroPetScreen extends StatefulWidget {
  const CadastroPetScreen({super.key});

  @override
  State<CadastroPetScreen> createState() =>
      _CadastroPetScreenState();
}

class _CadastroPetScreenState
    extends State<CadastroPetScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();

  final PetService _petService = PetService();

  String? _especie;
  DateTime? _dataNascimento;

  bool _salvando = false;

  // Temporário até implementarmos a autenticação.
  final int _clienteId = 1;

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: DateTime(1950),
      lastDate: hoje,
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        _dataNascimento = data;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _salvando = true;
    });

    try {
      await _petService.criar({
        'nome': _nomeController.text.trim(),
        'especie': _especie,
        'raca': _racaController.text.trim().isEmpty
            ? null
            : _racaController.text.trim(),
        'dataNascimento':
            _dataNascimento != null
                ? _formatarDataApi(_dataNascimento!)
                : null,
        'clienteId': _clienteId,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pet cadastrado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível cadastrar o pet: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Novo pet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 28),

                const Text(
                  'Informações do pet',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                _buildNomeField(),

                const SizedBox(height: 18),

                _buildEspecieField(),

                const SizedBox(height: 18),

                _buildRacaField(),

                const SizedBox(height: 18),

                _buildDataField(),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _salvando ? null : _salvar,
                    child: _salvando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<
                                      Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Cadastrar pet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _salvando
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.pets,
              size: 48,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Cadastre seu companheiro',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Informe os dados do seu pet para '
            'mantê-los registrados no VetMark.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNomeField() {
    return TextFormField(
      controller: _nomeController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Nome',
        hintText: 'Ex.: Mel',
        prefixIcon: Icon(
          Icons.pets,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Informe o nome do pet';
        }

        return null;
      },
    );
  }

  Widget _buildEspecieField() {
    return DropdownButtonFormField<String>(
      value: _especie,
      decoration: const InputDecoration(
        labelText: 'Espécie',
        prefixIcon: Icon(
          Icons.category_outlined,
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 'CACHORRO',
          child: Text('Cachorro'),
        ),
        DropdownMenuItem(
          value: 'GATO',
          child: Text('Gato'),
        ),
        DropdownMenuItem(
          value: 'AVE',
          child: Text('Ave'),
        ),
        DropdownMenuItem(
          value: 'COELHO',
          child: Text('Coelho'),
        ),
        DropdownMenuItem(
          value: 'OUTRO',
          child: Text('Outro'),
        ),
      ],
      onChanged: _salvando
          ? null
          : (value) {
              setState(() {
                _especie = value;
              });
            },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione a espécie';
        }

        return null;
      },
    );
  }

  Widget _buildRacaField() {
    return TextFormField(
      controller: _racaController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Raça',
        hintText: 'Ex.: Golden Retriever',
        prefixIcon: Icon(
          Icons.info_outline,
        ),
      ),
    );
  }

  Widget _buildDataField() {
    return InkWell(
      onTap: _salvando ? null : _selecionarData,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data de nascimento',
          prefixIcon: Icon(
            Icons.calendar_today_outlined,
          ),
        ),
        child: Text(
          _dataNascimento == null
              ? 'Selecione a data'
              : _formatarData(_dataNascimento!),
          style: TextStyle(
            color: _dataNascimento == null
                ? AppTheme.secondaryText
                : AppTheme.text,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  String _formatarDataApi(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '${data.year}-$mes-$dia';
  }
}