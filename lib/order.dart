import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  final String userId;

  OrderPage({required this.userId});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Stream<QuerySnapshot> _pedidosStream;

  @override
  void initState() {
    super.initState();
    // Escuta os pedidos do usuário com status 'Iniciado'
    _pedidosStream = FirebaseFirestore.instance
        .collection('pedidos')
        .where('uid', isEqualTo: widget.userId)
        .where('status', isEqualTo: 'Iniciado')  // Filtro para status 'Iniciado'
        .snapshots();
  }

  // Função para remover um item do pedido e alterar o status para 'Cancelado'
  Future<void> _removerItem(String pedidoId, String itemId) async {
    try {
      final pedidoRef = FirebaseFirestore.instance.collection('pedidos').doc(pedidoId);
      final pedidoDoc = await pedidoRef.get();

      if (pedidoDoc.exists) {
        final itens = pedidoDoc['itens'] as List;
        itens.removeWhere((item) => item['item_id'] == itemId);

        // Atualizando o pedido após remoção
        await pedidoRef.update({'itens': itens, 'status': 'Cancelado'});
      }
    } catch (e) {
      print('Erro ao remover item: $e');
    }
  }

  // Função para alterar a quantidade do item
  Future<void> _alterarQuantidade(String pedidoId, String itemId, int novaQuantidade) async {
    try {
      final pedidoRef = FirebaseFirestore.instance.collection('pedidos').doc(pedidoId);
      final pedidoDoc = await pedidoRef.get();

      if (pedidoDoc.exists) {
        final itens = pedidoDoc['itens'] as List;
        final itemIndex = itens.indexWhere((item) => item['item_id'] == itemId);

        if (itemIndex != -1) {
          itens[itemIndex]['quantidade'] = novaQuantidade;

          await pedidoRef.update({'itens': itens});
        }
      }
    } catch (e) {
      print('Erro ao alterar quantidade: $e');
    }
  }

  Future<void> _finalizarPedidos(List<DocumentSnapshot> pedidos) async {
    try {
      for (var pedido in pedidos) {
        final pedidoId = pedido.id;
        final pedidoRef = FirebaseFirestore.instance.collection('pedidos').doc(pedidoId);
    
        await pedidoRef.update({
          'status': 'Finalizado',
        });
      }

      // Exibindo pop-up
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pedidos Finalizados'),
          content: Text('Todos os pedidos foram finalizados e logo serão entregues!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Erro ao finalizar pedidos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo do Pedido'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _pedidosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum pedido encontrado.'));
          }

          final pedidos = snapshot.data!.docs;
          List<dynamic> todosItens = []; // Lista para armazenar todos os itens
          double total = 0;

          // Percorrendo os pedidos e somando os itens
          for (var pedido in pedidos) {
            final itens = pedido['itens'] as List;
            if (itens.isNotEmpty) {
              todosItens.addAll(itens);

              // Calculando o total
              for (var item in itens) {
                total += item['preco'] * item['quantidade'];
              }
            }
          }

          if (todosItens.isEmpty) {
            return Center(child: Text('Nenhum item no pedido.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: todosItens.length,
                  itemBuilder: (context, index) {
                    final item = todosItens[index];
                    final pedidoId = pedidos[index].id;  // Usando o pedidoId correto para cada item

                    return Column(
                      children: [
                        ListTile(
                          title: Text(item['nome'] ?? 'Nome do item'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Preço unitário: R\$ ${item['preco'].toStringAsFixed(2)}'),
                              Text('Quantidade: ${item['quantidade']}'),
                              Text('Subtotal: R\$ ${(item['preco'] * item['quantidade']).toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Botões de quantidade
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.red),
                                onPressed: item['quantidade'] > 1
                                    ? () {
                                        _alterarQuantidade(pedidoId, item['item_id'], item['quantidade'] - 1);
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  _alterarQuantidade(pedidoId, item['item_id'], item['quantidade'] + 1);
                                },
                              ),
                              // Botão de excluir item
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  _removerItem(pedidoId, item['item_id']);
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: R\$ ${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        // Finalizar todos os pedidos na tela
                        _finalizarPedidos(pedidos); // Passando todos os pedidos
                      },
                      child: Text('Finalizar Pedidos'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
