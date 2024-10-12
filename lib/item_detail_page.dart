import 'package:flutter/material.dart';

class ItemDetailPage extends StatefulWidget {
  final Map<String, String> item;
  final List<Map<String, dynamic>> pedido;

  ItemDetailPage({required this.item, required this.pedido});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int quantity = 1;

  void addToOrder() {
    final orderItem = {
      'name': widget.item['name'],
      'price': widget.item['price'],
      'quantity': quantity,
      'accompaniments': widget.item['accompaniments'],
      'preparation': widget.item['preparation'],
      'image': widget.item['image']
    };

    setState(() {
      widget.pedido.add(orderItem);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.item['name']} adicionado ao pedido!')),
    );
  }

  @override
  Widget build(BuildContext context) {

    String priceString = widget.item['price']!.replaceAll(RegExp(r'[R$ ,]'), '').replaceAll(',', '.');
    double price = double.tryParse(priceString) ?? 0.0;
    double subtotal = price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name']!),
        backgroundColor: Color(0xFFD52B1E),
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(widget.item['image']!, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Text(
              widget.item['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.item['description']!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Acompanhamentos: ${widget.item['accompaniments'] ?? "Nenhum"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Modo de Preparo: ${widget.item['preparation'] ?? "Não especificado"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preço: ${widget.item['price']}', // Mostra o preço
                      style: TextStyle(fontSize: 22, color: Colors.green),
                    ),
                    Text(
                      'Subtotal: R\$ ${((subtotal)/100).toStringAsFixed(2)}', // Mostra o subtotal
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(Icons.remove, color: Colors.white), // Ícone de menos
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$quantity',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green, 
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(Icons.add, color: Colors.white), // Ícone de mais
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addToOrder(); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, 
                minimumSize: Size(double.infinity, 60), 
                padding: EdgeInsets.symmetric(vertical: 15), 
              ),
              child: Text(
                'Adicionar ao Pedido',
                style: TextStyle(color: Colors.white), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
