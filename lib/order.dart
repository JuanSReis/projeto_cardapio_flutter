import 'package:flutter/material.dart';

class ResumoPedidoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> pedido;

  ResumoPedidoScreen({required this.pedido});

  @override
  _ResumoPedidoScreenState createState() => _ResumoPedidoScreenState();
}

class _ResumoPedidoScreenState extends State<ResumoPedidoScreen> {
  late List<Map<String, dynamic>> pedido;
  bool _pedidoConcluido = false; 

  @override
  void initState() {
    super.initState();
    pedido = widget.pedido; 
  }

  void _alterarQuantidade(int index, int delta) {
    setState(() {
      pedido[index]['quantity'] = (pedido[index]['quantity'] + delta).clamp(0, double.infinity).toInt();
      if (pedido[index]['quantity'] == 0) {
        pedido.removeAt(index);
      } else if (pedido[index]['quantity'] == 1 && delta == -1) {
        _confirmarRemocao(index);
      }
    });
  }

  void _confirmarRemocao(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Você realmente deseja remover "${pedido[index]['name']}" do pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removerItem(index);
                Navigator.of(context).pop();
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _removerItem(int index) {
    setState(() {
      pedido.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = 0.0;

    for (var item in pedido) {
      double itemPrice = double.parse(item['price'].replaceAll('R\$ ', '').replaceAll(',', '.'));
      total += item['quantity'] * itemPrice;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo do Pedido'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          if (_pedidoConcluido)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Pedido concluído!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: pedido.length,
              itemBuilder: (context, index) {
                final item = pedido[index];

                double itemPrice = double.parse(item['price'].replaceAll('R\$ ', '').replaceAll(',', '.'));
                double itemTotal = item['quantity'] * itemPrice;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(item['image']!, width: 50, height: 50, fit: BoxFit.cover),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'R\$ ${itemTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, color: Colors.blue),
                                    onPressed: () {
                                      if (item['quantity'] == 1) {
                                        _confirmarRemocao(index);
                                      } else {
                                        _alterarQuantidade(index, -1);
                                      }
                                    },
                                  ),
                                  Text(
                                    '${item['quantity']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.blue),
                                    onPressed: () => _alterarQuantidade(index, 1),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmarRemocao(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: R\$ ${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _pedidoConcluido = true; 
                  });
                },
                child: Text('Confirmar Pedido'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
