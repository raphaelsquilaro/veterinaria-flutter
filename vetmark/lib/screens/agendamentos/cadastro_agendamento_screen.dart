import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/pet.dart';
import '../../models/servico.dart';
import '../../models/veterinario.dart';
import '../../services/agendamento_service.dart';
import '../../services/pet_service.dart';
import '../../services/servico_service.dart';
import '../../services/veterinario_service.dart';

class CadastroAgendamentoScreen
    extends StatefulWidget {
  const CadastroAgendamentoScreen({
    super.key,
  });

  @override
  State<CadastroAgendamentoScreen>
      createState() =>
          _CadastroAgendamentoScreenState();
}

class _CadastroAgendamentoScreenState
    extends State<CadastroAgendamentoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _observacoesController =
      TextEditingController();

  final AgendamentoService _agendamentoService =
      AgendamentoService();

  final PetService _petService =
      PetService();

  final ServicoService _servicoService =
      ServicoService();

  final VeterinarioService _veterinarioService =
      VeterinarioService();

  List<Pet> _pets = [];
  List<Servico> _servicos = [];
  List<Veterinario> _veterinarios = [];

  int? _petId;
  int? _servicoId;
  int? _veterinarioId;

  DateTime? _data;
  TimeOfDay? _hora;

  bool _carregando = true;
  bool _salvando = false;

  // Temporário até implementarmos autenticação.
  final int _clienteId = 1;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    try {
      final resultados = await Future.wait([
        _petService.listar(),
        _servicoService.listar(),
        _veterinarioService.listar(),
      ]);

      if (!mounted) return;

      setState(() {
        _pets = resultados[0] as List<Pet>;
        _servicos =
            resultados[1] as List<Servico>;
        _veterinarios =
            resultados[2] as List<Veterinario>;

        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao carregar os dados: $e',
          ),
        ),
      );
    }
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: _data ?? hoje,
      firstDate: hoje,
      lastDate: DateTime(
        hoje.year + 2,
        hoje.month,
        hoje.day,
      ),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        _data = data;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: _hora ??
          const TimeOfDay(
            hour: 9,
            minute: 0,
          ),
    );

    if (hora != null) {
      setState(() {
        _hora = hora;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_data == null) {
      _mostrarMensagem(
        'Selecione a data da consulta.',
      );
      return;
    }

    if (_hora == null) {
      _mostrarMensagem(
        'Selecione o horário da consulta.',
      );
      return;
    }

    setState(() {
      _salvando = true;
    });

    final dataHora = DateTime(
      _data!.year,
      _data!.month,
      _data!.day,
      _hora!.hour,
      _hora!.minute,
    );

    try {
      await _agendamentoService.criar({
        'dataHora': dataHora.toIso8601String(),
        'status': 'PENDENTE',
        'observacoes':
            _observacoesController.text
                    .trim()
                    .isEmpty
                ? null
                : _observacoesController.text
                    .trim(),
        'clienteId': _clienteId,
        'petId': _petId,
        'veterinarioId':
            _veterinarioId,
        'servicoId': _servicoId,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Agendamento criado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _mostrarMensagem(
        'Não foi possível criar o agendamento: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Novo agendamento',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            )
          : SafeArea(
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
                        'Informações da consulta',
                        style: TextStyle(
                          color: AppTheme.text,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      _buildPetField(),

                      const SizedBox(height: 18),

                      _buildServicoField(),

                      const SizedBox(height: 18),

                      _buildVeterinarioField(),

                      const SizedBox(height: 18),

                      _buildDataField(),

                      const SizedBox(height: 18),

                      _buildHoraField(),

                      const SizedBox(height: 18),

                      _buildObservacoesField(),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _salvando
                                  ? null
                                  : _salvar,
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
                                  'Confirmar agendamento',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
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
                                  Navigator.pop(
                                      context);
                                },
                          child:
                              const Text('Cancelar'),
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
              borderRadius:
                  BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 48,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Agende uma consulta',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Escolha o pet, serviço, veterinário, '
            'data e horário da consulta.',
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

  Widget _buildPetField() {
    return DropdownButtonFormField<int>(
      value: _petId,
      decoration: const InputDecoration(
        labelText: 'Pet',
        prefixIcon: Icon(
          Icons.pets_outlined,
        ),
      ),
      items: _pets.map((pet) {
        return DropdownMenuItem<int>(
          value: pet.id,
          child: Text(pet.nome),
        );
      }).toList(),
      onChanged: _salvando
          ? null
          : (value) {
              setState(() {
                _petId = value;
              });
            },
      validator: (value) {
        if (value == null) {
          return 'Selecione o pet';
        }

        return null;
      },
    );
  }

  Widget _buildServicoField() {
    return DropdownButtonFormField<int>(
      value: _servicoId,
      decoration: const InputDecoration(
        labelText: 'Serviço',
        prefixIcon: Icon(
          Icons.medical_services_outlined,
        ),
      ),
      items: _servicos
          .where((servico) => servico.ativo)
          .map((servico) {
        return DropdownMenuItem<int>(
          value: servico.id,
          child: Text(
            '${servico.nome} - '
            'R\$ ${servico.valor.toStringAsFixed(2)}',
          ),
        );
      }).toList(),
      onChanged: _salvando
          ? null
          : (value) {
              setState(() {
                _servicoId = value;
              });
            },
      validator: (value) {
        if (value == null) {
          return 'Selecione o serviço';
        }

        return null;
      },
    );
  }

  Widget _buildVeterinarioField() {
    return DropdownButtonFormField<int>(
      value: _veterinarioId,
      decoration: const InputDecoration(
        labelText: 'Veterinário',
        prefixIcon: Icon(
          Icons.person_search_outlined,
        ),
      ),
      items: _veterinarios
          .where((veterinario) =>
              veterinario.ativo)
          .map((veterinario) {
        return DropdownMenuItem<int>(
          value: veterinario.id,
          child: Text(
            'Dr(a). ${veterinario.nome}',
          ),
        );
      }).toList(),
      onChanged: _salvando
          ? null
          : (value) {
              setState(() {
                _veterinarioId = value;
              });
            },
      validator: (value) {
        if (value == null) {
          return 'Selecione o veterinário';
        }

        return null;
      },
    );
  }

  Widget _buildDataField() {
    return InkWell(
      onTap: _salvando
          ? null
          : _selecionarData,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data',
          prefixIcon: Icon(
            Icons.event_outlined,
          ),
        ),
        child: Text(
          _data == null
              ? 'Selecione a data'
              : _formatarData(_data!),
          style: TextStyle(
            color: _data == null
                ? AppTheme.secondaryText
                : AppTheme.text,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildHoraField() {
    return InkWell(
      onTap: _salvando
          ? null
          : _selecionarHora,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Horário',
          prefixIcon: Icon(
            Icons.schedule_outlined,
          ),
        ),
        child: Text(
          _hora == null
              ? 'Selecione o horário'
              : _formatarHora(_hora!),
          style: TextStyle(
            color: _hora == null
                ? AppTheme.secondaryText
                : AppTheme.text,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildObservacoesField() {
    return TextFormField(
      controller: _observacoesController,
      enabled: !_salvando,
      maxLines: 4,
      textCapitalization:
          TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Observações',
        hintText:
            'Alguma informação importante?',
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Icon(
            Icons.notes_outlined,
          ),
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final dia =
        data.day.toString().padLeft(2, '0');
    final mes =
        data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  String _formatarHora(TimeOfDay hora) {
    final h =
        hora.hour.toString().padLeft(2, '0');
    final m =
        hora.minute.toString().padLeft(2, '0');

    return '$h:$m';
  }
}