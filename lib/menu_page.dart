import 'package:flutter/material.dart';
import 'item_detail_page.dart';
import 'order.dart';
import 'login.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> pedido = [];

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mexicanos'),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: Icon(Icons.logout), 
              tooltip: 'Logout', 
              onPressed: () => _logout(context),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: 'Entradas'),
              Tab(text: 'Principais'),
              Tab(text: 'Bebidas'),
              Tab(text: 'Sobremesas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoryList(context, 'Entradas', entradas),
            _buildCategoryList(context, 'Principais', pratosPrincipais),
            _buildCategoryList(context, 'Bebidas', bebidas),
            _buildCategoryList(context, 'Sobremesas', sobremesas),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResumoPedidoScreen(pedido: pedido),
              ),
            );
          },
          child: Icon(Icons.shopping_cart),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, String category, List<Map<String, String>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Image.asset(item['image']!, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(
            item['name']!,
            style: TextStyle(color: Color(0xFF007A33)),
          ),
          subtitle: Text(
            item['description']!,
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailPage(item: item, pedido: pedido),
              ),
            );
          },
        );
      },
    );
  }
}


//Dados que usei pro cardapio
final List<Map<String, String>> entradas = [
  {
    'name': 'Guacamole',
    'description': 'Pasta de abacate temperada com cebola, tomate, coentro e suco de limão. Tradicionalmente servido com nachos crocantes, pode acompanhar tacos e burritos. Um prato fresco e saudável, ideal para iniciar uma refeição mexicana.',
    'preparation': 'O abacate é amassado e temperado com os ingredientes frescos. O segredo está no equilíbrio de sabores entre o limão e o coentro.',
    'accompaniments': 'Combina bem com Margaritas ou uma cerveja leve como Corona.',
    'price': 'R\$ 25,00',
    'image': 'assets/images/guacamole.png',
  },
  {
    'name': 'Nachos',
    'description': 'Nachos crocantes servidos com queijo derretido, jalapeños, e uma mistura de feijões refritos. Um prato divertido e fácil de compartilhar.',
    'preparation': 'Os nachos são assados até ficarem crocantes, depois cobertos com uma generosa porção de queijo derretido e guarnecidos com pimenta jalapeño e guacamole.',
    'accompaniments': 'Ótima pedida com uma cerveja artesanal ou uma Michelada picante.',
    'price': 'R\$ 30,00',
    'image': 'assets/images/nachos.png',
  },
  {
    'name': 'Quesadilla',
    'description': 'Tortilha recheada com queijo e outros ingredientes, grelhada até o queijo derreter. É uma escolha leve e saborosa.',
    'preparation': 'A tortilha é recheada com queijo e outros ingredientes opcionais, como frango ou cogumelos, depois grelhada até o queijo derreter completamente.',
    'accompaniments': 'Harmoniza bem com um suco de laranja fresco ou uma Horchata.',
    'price': 'R\$ 28,00',
    'image': 'assets/images/quesadilla.png',
  },
  {
    'name': 'Tacos de Pollo',
    'description': 'Tacos recheados com frango desfiado e guarnições variadas, como cebola e coentro. Um prato tradicional e delicioso.',
    'preparation': 'O frango é cozido até ficar macio e depois desfiado. As tortilhas são aquecidas e recheadas com o frango e guarnições frescas.',
    'accompaniments': 'Acompanha bem uma água de Jamaica ou uma cerveja leve.',
    'price': 'R\$ 32,00',
    'image': 'assets/images/tacos_pollo.png',
  },
  {
    'name': 'Sopes',
    'description': 'Discos de massa de milho espessos, cobertos com feijão, carne, alface e queijo fresco. Uma entrada rica e completa.',
    'preparation': 'A massa de milho é moldada em pequenos discos grossos, frita levemente e coberta com feijões refritos, carne de frango ou porco e guarnições.',
    'accompaniments': 'Saboroso com uma cerveja escura ou um copo de tequila.',
    'price': 'R\$ 35,00',
    'image': 'assets/images/sopes.png',
  },
  {
    'name': 'Ceviche',
    'description': 'Peixe fresco marinado em suco de limão, misturado com cebola, tomate e coentro. Um prato refrescante e leve.',
    'preparation': 'O peixe cru é cortado em cubos e marinado no suco de limão até "cozinhar". Depois, é misturado com vegetais frescos e temperos.',
    'accompaniments': 'Combina com uma cerveja clara ou uma água de coco.',
    'price': 'R\$ 40,00',
    'image': 'assets/images/ceviche.png',
  },
  {
    'name': 'Elote',
    'description': 'Milho grelhado, coberto com maionese, queijo e pimenta em pó. Um clássico das ruas mexicanas.',
    'preparation': 'O milho é grelhado até ficar dourado e então coberto com uma mistura de maionese, queijo cotija ralado e pimenta em pó.',
    'accompaniments': 'Acompanha bem com uma água fresca ou uma cerveja gelada.',
    'price': 'R\$ 18,00',
    'image': 'assets/images/elote.png',
  },
  {
    'name': 'Chiles en Nogada',
    'description': 'Pimentões recheados com carne moída, frutas secas e especiarias, cobertos com um molho de nozes. Um prato sofisticado e cheio de história.',
    'preparation': 'Os pimentões são assados, recheados com carne moída e uma mistura de frutas secas, temperados com especiarias e cobertos com um molho cremoso de nozes.',
    'accompaniments': 'Excelente com vinho branco ou uma Margarita suave.',
    'price': 'R\$ 45,00',
    'image': 'assets/images/chiles_nogada.png',
  },
  {
    'name': 'Tamales',
    'description': 'Massa de milho envolta em folha de bananeira, recheada com carne ou doces. Um prato tradicional em festividades.',
    'preparation': 'A massa de milho é recheada com carne ou doces e depois cozida no vapor dentro de folhas de bananeira.',
    'accompaniments': 'Combina com um café mexicano ou uma Horchata gelada.',
    'price': 'R\$ 22,00',
    'image': 'assets/images/tamales.png',
  },
  {
    'name': 'Tostadas',
    'description': 'Tortilhas crocantes cobertas com feijão, carne desfiada, alface e queijo. Um prato crocante e saboroso.',
    'preparation': 'As tortilhas são fritas até ficarem crocantes e depois cobertas com uma camada de feijão refrito, carne e guarnições.',
    'accompaniments': 'Perfeito com uma Michelada ou uma água de frutas.',
    'price': 'R\$ 27,00',
    'image': 'assets/images/tostadas.png',
  },
  {
    'name': 'Flautas',
    'description': 'Tortilhas enroladas e recheadas com carne, depois fritas até ficarem crocantes. Servidas com guacamole e creme de leite.',
    'preparation': 'As tortilhas são recheadas com carne desfiada, enroladas e fritas até ficarem douradas e crocantes.',
    'accompaniments': 'Ótimo com uma cerveja artesanal ou um suco de limão fresco.',
    'price': 'R\$ 33,00',
    'image': 'assets/images/flautas.png',
  },
  {
    'name': 'Chimichangas',
    'description': 'Tortilhas recheadas e fritas, servidas com guacamole e pico de gallo. Uma delícia frita e crocante.',
    'preparation': 'As tortilhas são recheadas com carne e depois fritas até ficarem crocantes. Servidas com acompanhamentos frescos.',
    'accompaniments': 'Combina com uma Margarita clássica ou uma cerveja gelada.',
    'price': 'R\$ 38,00',
    'image': 'assets/images/chimichangas.png',
  },
];

final List<Map<String, String>> pratosPrincipais = [
  {
    'name': 'Tacos de Carnitas',
    'description': 'Tortilhas recheadas com carne de porco desfiada, servidas com cebola e coentro. Um prato saboroso e tradicional.',
    'preparation': 'A carne de porco é cozida lentamente até ficar macia e depois desfiada, servida em tortilhas quentes.',
    'accompaniments': 'Harmoniza bem com uma cerveja leve ou uma Margarita.',
    'price': 'R\$ 34,00',
    'image': 'assets/images/carnitas.png',
  },
  {
    'name': 'Burrito',
    'description': 'Uma grande tortilha recheada com carne, arroz, feijão e guarnições, enrolada e aquecida.',
    'preparation': 'Os ingredientes são colocados no centro da tortilha, que é então enrolada e aquecida até o queijo derreter.',
    'accompaniments': 'Perfeito com um refrigerante ou uma cerveja.',
    'price': 'R\$ 32,00',
    'image': 'assets/images/burrito.png',
  },
  {
    'name': 'Enchiladas',
    'description': 'Tortilhas enroladas recheadas com carne e cobertas com molho picante e queijo derretido.',
    'preparation': 'As tortilhas são recheadas, enroladas e cobertas com molho quente antes de serem assadas.',
    'accompaniments': 'Ideal com uma água de Jamaica ou uma cerveja artesanal.',
    'price': 'R\$ 35,00',
    'image': 'assets/images/enchiladas.png',
  },
  {
    'name': 'Chiles Rellenos',
    'description': 'Pimentões recheados com queijo e carne, empanados e fritos. Um prato delicioso e diferente.',
    'preparation': 'Os pimentões são recheados, empanados e fritos até ficarem crocantes e dourados.',
    'accompaniments': 'Combina bem com um vinho branco ou uma Margarita.',
    'price': 'R\$ 42,00',
    'image': 'assets/images/chiles_rellenos.png',
  },
  {
    'name': 'Fajitas',
    'description': 'Tiras de carne grelhadas com pimentões e cebolas, servidas com tortilhas quentes. Uma refeição interativa.',
    'preparation': 'A carne e os vegetais são grelhados juntos e servidos com tortilhas quentes para montar os tacos.',
    'accompaniments': 'Perfeito com uma cerveja escura ou um margarita.',
    'price': 'R\$ 39,00',
    'image': 'assets/images/fajitas.png',
  },
  {
    'name': 'Camarones al Mojo de Ajo',
    'description': 'Camarões salteados com alho e limão, servidos com arroz e feijão. Um prato leve e cheio de sabor.',
    'preparation': 'Os camarões são salteados em uma mistura de alho e limão até ficarem macios, servidos com arroz.',
    'accompaniments': 'Combina com um vinho branco ou uma cerveja clara.',
    'price': 'R\$ 47,00',
    'image': 'assets/images/camarones_diabla.png',
  },
  {
    'name': 'Mole Poblano',
    'description': 'Peito de frango coberto com molho de chocolate e especiarias, servido com arroz. Um prato único e saboroso.',
    'preparation': 'O frango é cozido e coberto com um molho rico de chocolate e especiarias.',
    'accompaniments': 'Harmoniza bem com um vinho tinto ou uma água fresca.',
    'price': 'R\$ 50,00',
    'image': 'assets/images/mole_poblano.png',
  },
  {
    'name': 'Pescado Veracruzano',
    'description': 'Filé de peixe grelhado com molho de tomate, azeitonas e especiarias. Uma opção deliciosa e leve.',
    'preparation': 'O peixe é grelhado e coberto com um molho à base de tomate e azeitonas.',
    'accompaniments': 'Ótimo com uma cerveja clara ou um vinho branco.',
    'price': 'R\$ 45,00',
    'image': 'assets/images/pescado_veracruzana.png',
  },
  {
    'name': 'Tamales de Pollo',
    'description': 'Massa de milho recheada com frango, cozida no vapor e servida com molho de pimenta.',
    'preparation': 'Os tamales são preparados com massa de milho recheada com frango, cozidos no vapor até ficarem macios.',
    'accompaniments': 'Combina com um refrigerante ou uma água fresca.',
    'price': 'R\$ 32,00',
    'image': 'assets/images/tamales.png',
  },
];
final List<Map<String, String>> bebidas = [
  {
    'name': 'Agua Fresca',
    'description': 'Bebida refrescante feita com frutas frescas e água, ideal para acompanhar qualquer refeição.',
    'preparation': 'As frutas são misturadas com água e açúcar, coadas e servidas geladas.',
    'accompaniments': 'Combina bem com qualquer prato.',
    'price': 'R\$ 8,00',
    'image': 'assets/images/aguas_frescas.png',
  },
  {
    'name': 'Limonada',
    'description': 'Clássica bebida de limão refrescante, adoçada a gosto. Uma escolha popular para qualquer refeição.',
    'preparation': 'Os limões são espremidos e misturados com água e açúcar para criar uma bebida refrescante.',
    'accompaniments': 'Perfeita para acompanhar entradas ou pratos principais.',
    'price': 'R\$ 10,00',
    'image': 'assets/images/limonada.png',
  },
  {
    'name': 'Horchata',
    'description': 'Bebida doce à base de arroz, canela e baunilha. Tradicional e deliciosa.',
    'preparation': 'O arroz é cozido e misturado com água, canela e açúcar, coado e servido gelado.',
    'accompaniments': 'Ideal com pratos apimentados.',
    'price': 'R\$ 12,00',
    'image': 'assets/images/horchata.png',
  },
  {
    'name': 'Michelada',
    'description': 'Cerveja temperada com limão e molho de pimenta, uma escolha refrescante e picante.',
    'preparation': 'A cerveja é misturada com limão e temperos, servida em um copo com sal na borda.',
    'accompaniments': 'Combina bem com pratos fritos.',
    'price': 'R\$ 15,00',
    'image': 'assets/images/michelada.png',
  },
  {
    'name': 'Margarita',
    'description': 'Bebida clássica de tequila, limão e licor de laranja, servida com ou sem sal na borda.',
    'preparation': 'Tequila, suco de limão e licor de laranja são misturados e servidos gelados.',
    'accompaniments': 'Perfeita com pratos de carne ou frango.',
    'price': 'R\$ 18,00',
    'image': 'assets/images/margarita.png',
  },
  {
    'name': 'Tequila',
    'description': 'Bebida destilada mexicana feita a partir do agave, uma escolha clássica para os amantes de bebidas fortes.',
    'preparation': 'Servida em um copo, pura ou com sal e limão.',
    'accompaniments': 'Ideal para acompanhar pratos saborosos.',
    'price': 'R\$ 20,00',
    'image': 'assets/images/tequila.png',
  },
  {
    'name': 'Cerveja',
    'description': 'Cerveja mexicana leve e refrescante, perfeita para acompanhar as refeições.',
    'preparation': 'Servida gelada, pode ser acompanhada de limão.',
    'accompaniments': 'Combina bem com pratos apimentados ou fritos.',
    'price': 'R\$ 10,00',
    'image': 'assets/images/cerveza_trigo.png',
  },
  {
    'name': 'Café com Leite',
    'description': 'Uma mistura deliciosa de café forte com leite cremoso, ideal para começar o dia.',
    'preparation': 'Mistura-se café expresso com leite vaporizado e açúcar a gosto.',
    'accompaniments': 'Perfeito para acompanhar bolos ou churros.',
    'price': 'R\$ 8,00',
    'image': 'assets/images/cafe_leche.png',
  },
  {
    'name': 'Café de Olla',
    'description': 'Café tradicional mexicano cozido com canela e piloncillo, trazendo um sabor único.',
    'preparation': 'O café é cozido com canela e açúcar mascavo em um recipiente de barro.',
    'accompaniments': 'Ótimo com sobremesas ou pão doce.',
    'price': 'R\$ 10,00',
    'image': 'assets/images/cafe_olla.png',
  },
  {
    'name': 'Daiquiri',
    'description': 'Uma bebida refrescante à base de rum, limão e açúcar, perfeita para dias quentes.',
    'preparation': 'Mistura-se rum com suco de limão e açúcar, servido gelado em uma taça.',
    'accompaniments': 'Ideal com pratos leves e frutos do mar.',
    'price': 'R\$ 15,00',
    'image': 'assets/images/daiquiri.png',
  },
];


final List<Map<String, String>> sobremesas = [
  {
    'name': 'Churros',
    'description': 'Deliciosos churros crocantes, polvilhados com açúcar e canela.',
    'preparation': 'Fritos até ficarem dourados e servidos quentes.',
    'accompaniments': 'Ótimos com chocolate quente ou doce de leite.',
    'price': 'R\$ 15,00',
    'image': 'assets/images/churros.png',
  },
  {
    'name': 'Flan',
    'description': 'Um pudim suave e cremoso, com um sabor doce e caramelizado.',
    'preparation': 'Preparado com ovos, leite e açúcar, servido gelado.',
    'accompaniments': 'Perfeito com café ou uma colher de chantilly.',
    'price': 'R\$ 12,00',
    'image': 'assets/images/flan.png',
  },
  {
    'name': 'Tres Leches',
    'description': 'Bolo úmido feito com três tipos de leite, leve e delicioso.',
    'preparation': 'Servido frio, coberto com chantilly.',
    'accompaniments': 'Combina bem com frutas frescas.',
    'price': 'R\$ 18,00',
    'image': 'assets/images/tres_leches.png',
  },
  {
    'name': 'Capirotada',
    'description': 'Uma deliciosa sobremesa mexicana à base de pão, frutas e especiarias.',
    'preparation': 'Assada com uma mistura de leite e açúcar.',
    'accompaniments': 'Ótima com uma bola de sorvete.',
    'price': 'R\$ 20,00',
    'image': 'assets/images/capirotada.png',
  },
  {
    'name': 'Dulce de Leche',
    'description': 'Doce de leite cremoso e irresistível, perfeito para qualquer sobremesa.',
    'preparation': 'Preparado lentamente até atingir uma consistência caramelizada.',
    'accompaniments': 'Delicioso com frutas ou em torradas.',
    'price': 'R\$ 10,00',
    'image': 'assets/images/dulce_de_leche.png',
  },
  {
    'name': 'Galletas de Chocolate',
    'description': 'Biscoitos crocantes com pedaços de chocolate, irresistíveis!',
    'preparation': 'Assados até ficarem dourados.',
    'accompaniments': 'Ótimos com um copo de leite.',
    'price': 'R\$ 8,00',
    'image': 'assets/images/galletas_chocolate.png',
  },
  {
    'name': 'Natilla',
    'description': 'Um pudim cremoso de leite com um toque de canela.',
    'preparation': 'Servido gelado, com canela polvilhada por cima.',
    'accompaniments': 'Perfeito com biscoitos.',
    'price': 'R\$ 10,00',
    'image': 'assets/images/natilla.png',
  },
  {
    'name': 'Cocadas',
    'description': 'Doces à base de coco, crocantes por fora e macios por dentro.',
    'preparation': 'Assadas até ficarem douradas.',
    'accompaniments': 'Deliciosas com um café.',
    'price': 'R\$ 12,00',
    'image': 'assets/images/cocadas.png',
  },
  {
    'name': 'Paletas',
    'description': 'Picolés de frutas frescas, refrescantes e saborosos.',
    'preparation': 'Feitas com frutas naturais, servidas congeladas.',
    'accompaniments': 'Ótimas para dias quentes.',
    'price': 'R\$ 5,00',
    'image': 'assets/images/paletas.png',
  },
  {
    'name': 'Mole Dulce',
    'description': 'Uma deliciosa pasta de chocolate com especiarias.',
    'preparation': 'Servido como sobremesa ou para acompanhar frutas.',
    'accompaniments': 'Combina bem com bananas.',
    'price': 'R\$ 15,00',
    'image': 'assets/images/mole_dulce.png',
  },
  {
    'name': 'Papel Dulce',
    'description': 'Doces tradicionais feitos com açúcar e amido.',
    'preparation': 'Servidos em tiras, perfeitos para festas.',
    'accompaniments': 'Ideais para acompanhar uma bebida.',
    'price': 'R\$ 7,00',
    'image': 'assets/images/papel_dulce.png',
  },
  {
    'name': 'Tarta Limón',
    'description': 'Uma torta de limão refrescante, com sabor doce e azedo.',
    'preparation': 'Preparada com uma base crocante e recheio cremoso.',
    'accompaniments': 'Deliciosa com um pouco de chantilly.',
    'price': 'R\$ 16,00',
    'image': 'assets/images/tarta_limon.png',
  },
  {
    'name': 'Biscoitos de Amêndoas',
    'description': 'Biscoitos macios com pedaços de amêndoa, saborosos e crocantes.',
    'preparation': 'Assados até ficarem dourados.',
    'accompaniments': 'Ideais com chá ou café.',
    'price': 'R\$ 10,00',
    'image': 'assets/images/biscoitos_amendoas.png',
  },
  {
    'name': 'Helado de Frutas',
    'description': 'Sorvete cremoso feito com frutas frescas.',
    'preparation': 'Servido em bolas, refrescante e saboroso.',
    'accompaniments': 'Perfeito para finalizar a refeição.',
    'price': 'R\$ 14,00',
    'image': 'assets/images/helado_frutas.png',
  },
  {
    'name': 'Café com Leite',
    'description': 'Um clássico, mistura de café forte com leite cremoso.',
    'preparation': 'Preparado fresco e servido quente.',
    'accompaniments': 'Ótimo após a refeição.',
    'price': 'R\$ 6,00',
    'image': 'assets/images/cafe_leche.png',
  },
  {
    'name': 'Bunuelos',
    'description': 'Massinhas doces e fritas, crocantes por fora e macias por dentro.',
    'preparation': 'Polvilhados com açúcar e canela.',
    'accompaniments': 'Deliciosos com mel ou açúcar.',
    'price': 'R\$ 10,00',
    'image': 'assets/images/bunuelos.png',
  },
];
