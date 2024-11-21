import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  final String uid;

  const MenuPage({Key? key, required this.uid}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> pedido = [];
  late Future<List<DocumentSnapshot>> _categoriesFuture;

  Future<List<DocumentSnapshot>> _getCategories() async {
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('ordem') 
        .get();
    return categoriesSnapshot.docs;
  }

  
  Future<List<DocumentSnapshot>> _getCategoryItems(String categoryName) async {
    final itemsSnapshot = await FirebaseFirestore.instance
        .collection('itens_cardapio')
        .where('categoria', isEqualTo: categoryName)
        .where('ativo', isEqualTo: true)
        .get();
    return itemsSnapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _getCategories(); 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _categoriesFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Mexicanos'),
              backgroundColor: Colors.red,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Mexicanos'),
              backgroundColor: Colors.red,
            ),
            body: Center(child: Text('Erro ao carregar categorias')),
          );
        }

        final categories = snapshot.data ?? [];

        return DefaultTabController(
          length: categories.length, 
          child: Scaffold(
            appBar: AppBar(
              title: Text('Mexicanos'),
              backgroundColor: Colors.red,
              bottom: TabBar(
                indicatorColor: Colors.green,
                tabs: categories.map((category) {
                  final categoryName = category['nome'];
                  return Tab(text: categoryName);
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: categories.map((category) {
                final categoryName = category['nome'];
                return _buildCategoryList(context, categoryName);
              }).toList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/OrderPage',
                    arguments: widget.uid);
              },
              backgroundColor: Colors.green,
              child: Icon(Icons.shopping_cart),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        );
      },
    );
  }

  Widget _buildCategoryList(BuildContext context, String category) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _getCategoryItems(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar itens'));
        }

        final items = snapshot.data ?? [];
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: Image.network(item['imagem'],
                  width: 50, height: 50, fit: BoxFit.cover),
              title: Text(item['nome']),
              subtitle: Text(item['descricao']),
              trailing: Text("R\$ ${item['preco'].toStringAsFixed(2)}"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/ItemDetail',
                  arguments: {
                    'itemId': items[index].id,
                    'userId': widget.uid,
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
