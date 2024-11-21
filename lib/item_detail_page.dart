import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetailPage extends StatefulWidget {
  final String itemId;
  final String userId; 

  ItemDetailPage({required this.itemId, required this.userId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  Map<String, dynamic>? itemDetails;
  int _quantity = 1; 
  double _subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _getItemDetails(); 
  }

  // Função para buscar os detalhes do item no Firestore
  Future<void> _getItemDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('itens_cardapio')
          .doc(widget.itemId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          itemDetails = docSnapshot.data() as Map<String, dynamic>;
          _subtotal = (itemDetails?['preco'] ?? 0.0) * _quantity;
        });
      }
    } catch (e) {
      print('Erro ao carregar detalhes do item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar detalhes do item.')),
      );
    }
  }

  void _alterarQuantidade(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 999); 
      _subtotal = (itemDetails?['preco'] ?? 0.0) * _quantity;
    });
  }

  Future<void> _adicionarAoPedido() async {
    if (itemDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Detalhes do item não encontrados.')),
      );
      return;
    }

    try {
      final pedidoRef = FirebaseFirestore.instance.collection('pedidos').doc();
      final now = DateTime.now();
      final dataHora = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";

      await pedidoRef.set({
        'uid': widget.userId, 
        'status': 'Iniciado',
        'data_hora': dataHora,
        'itens': [
          {
            'item_id': widget.itemId,
            'nome': itemDetails?['nome'],
            'preco': itemDetails?['preco'],
            'quantidade': _quantity,
          }
        ],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item adicionado ao pedido!')),
      );

      Navigator.pop(context);
    } catch (error) {
      print('Erro ao adicionar item ao pedido: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar item ao pedido.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemDetails?['nome'] ?? 'Detalhes do Item'),
        backgroundColor: Colors.red,
      ),
      body: itemDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Center(
                    child: Image.network(
                      itemDetails?['imagem'] ?? '',
                      width: MediaQuery.of(context).size.width * 0.7, 
                      height: MediaQuery.of(context).size.width * 0.7, 
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    itemDetails?['nome'] ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Preço do item
                  Text(
                    'R\$ ${(itemDetails?['preco'] ?? 0.0).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Descrição do item
                  Text(
                    itemDetails?['descricao'] ?? 'Descrição não disponível.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _quantity > 1 ? () => _alterarQuantidade(-1) : null,
                        color: Colors.red,
                      ),
                      Text(
                        '$_quantity',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _alterarQuantidade(1),
                        color: Colors.green,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Subtotal: R\$ ${_subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _adicionarAoPedido,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                        'Adicionar ao Pedido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
