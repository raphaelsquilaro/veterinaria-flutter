import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/produto.dart';
import '../../services/pedido_service.dart';
import '../../services/produto_service.dart';

class CadastroPedidoScreen extends StatefulWidget {
  const CadastroPedidoScreen({super.key});

  @override
  State<CadastroPedidoScreen> createState() =>
      _CadastroPedidoScreenState();
}

class _CadastroPedidoScreenState
    extends State<CadastroPedidoScreen> {
  final PedidoService _pedidoService =
      PedidoService();

  final ProdutoService _produtoService =
      ProdutoService();

  List<Produto> _produtos = [];

  final Map<int, int> _quantidades = {};

  bool _carregando = true;
  bool _salvando = false;

  // Temporário até implementarmos autenticação.
  final int _clienteId = 1;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    try {
      final produtos =
          await _produtoService.listar();

      if (!mounted) return;

      setState(() {
        _produtos = produtos;
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
            'Erro ao carregar produtos: $e',
          ),
        ),
      );
    }
  }

  void _adicionarProduto(Produto produto) {
    if (produto.id == null) return;

    final quantidadeAtual =
        _quantidades[produto.id!] ?? 0;

    if (quantidadeAtual >= produto.estoque) {
      _mostrarMensagem(
        'Quantidade máxima disponível: '
        '${produto.estoque}.',
      );
      return;
    }

    setState(() {
      _quantidades[produto.id!] =
          quantidadeAtual + 1;
    });
  }

  void _removerProduto(Produto produto) {
    if (produto.id == null) return;

    final quantidadeAtual =
        _quantidades[produto.id!] ?? 0;

    if (quantidadeAtual <= 0) {
      return;
    }

    setState(() {
      if (quantidadeAtual == 1) {
        _quantidades.remove(produto.id!);
      } else {
        _quantidades[produto.id!] =
            quantidadeAtual - 1;
      }
    });
  }

  double get _total {
    double total = 0;

    for (final produto in _produtos) {
      if (produto.id == null) continue;

      final quantidade =
          _quantidades[produto.id!] ?? 0;

      total += produto.preco * quantidade;
    }

    return total;
  }

  int get _quantidadeItens {
    return _quantidades.values.fold(
      0,
      (total, quantidade) =>
          total + quantidade,
    );
  }

  Future<void> _salvarPedido() async {
    if (_quantidadeItens == 0) {
      _mostrarMensagem(
        'Adicione pelo menos um produto ao pedido.',
      );
      return;
    }

    setState(() {
      _salvando = true;
    });

    final itens = _quantidades.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => {
            'produtoId': entry.key,
            'quantidade': entry.value,
          },
        )
        .toList();

    try {
      await _pedidoService.criar({
        'status': 'PENDENTE',
        'clienteId': _clienteId,
        'itens': itens,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pedido criado com sucesso!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _mostrarMensagem(
        'Não foi possível criar o pedido: $e',
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
          'Novo pedido',
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
          : _buildBody(),

      bottomNavigationBar: _quantidadeItens > 0
          ? _buildBottomSummary()
          : null,
    );
  }

  Widget _buildBody() {
    if (_produtos.isEmpty) {
      return _buildEmptyProducts();
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(),

          const SizedBox(height: 24),

          const Text(
            'Produtos disponíveis',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          ..._produtos.map(
            (produto) =>
                _buildProdutoCard(produto),
          ),

          const SizedBox(height: 110),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.secondaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppTheme.secondary,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Monte seu pedido',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Escolha os produtos e informe '
                  'a quantidade desejada.',
                  style: TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProdutoCard(Produto produto) {
    final quantidade =
        produto.id != null
            ? (_quantidades[produto.id!] ?? 0)
            : 0;

    final disponivel = produto.estoque > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: quantidade > 0
              ? AppTheme.primary
              : AppTheme.border,
          width: quantidade > 0 ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppTheme.secondary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (produto.descricao != null &&
                    produto.descricao!
                        .trim()
                        .isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    produto.descricao!,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color:
                          AppTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],

                const SizedBox(height: 7),

                Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  disponivel
                      ? '${produto.estoque} em estoque'
                      : 'Indisponível',
                  style: TextStyle(
                    color: disponivel
                        ? AppTheme.success
                        : AppTheme.danger,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          _buildQuantitySelector(
            produto,
            quantidade,
            disponivel,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(
    Produto produto,
    int quantidade,
    bool disponivel,
  ) {
    if (!disponivel) {
      return const SizedBox(
        width: 36,
        child: Icon(
          Icons.remove_circle_outline,
          color: AppTheme.secondaryText,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _salvando || quantidade == 0
              ? null
              : () {
                  _removerProduto(produto);
                },
          icon: const Icon(
            Icons.remove_circle_outline,
          ),
          color: AppTheme.primary,
        ),

        Text(
          '$quantidade',
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        IconButton(
          onPressed: _salvando
              ? null
              : () {
                  _adicionarProduto(produto);
                },
          icon: const Icon(
            Icons.add_circle_outline,
          ),
          color: AppTheme.primary,
        ),
      ],
    );
  }

  Widget _buildBottomSummary() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          14,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: const Border(
            top: BorderSide(
              color: AppTheme.border,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_quantidadeItens '
                    'item(ns)',
                    style: const TextStyle(
                      color:
                          AppTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'R\$ ${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed:
                    _salvando
                        ? null
                        : _salvarPedido,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(150, 48),
                ),
                child: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
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
                        'Finalizar pedido',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProducts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 70,
              color: AppTheme.secondaryText,
            ),

            const SizedBox(height: 20),

            const Text(
              'Nenhum produto disponível',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Não existem produtos disponíveis '
              'para pedido no momento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}