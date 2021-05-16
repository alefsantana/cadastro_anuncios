import 'package:cadastro_usurarios/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesquisar Anúncio',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(context),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  Widget MyHomePage(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final Contact person = contacts[index];
          return Card(
            // Lista de Anuncios ( Relatorio )
            child: ListTile(
              title: Text("Anúncio: ${person.nameAnuncio}"),
              subtitle: Text('Cliente: ${person.cliente}'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Text('Duração ${person.dias} Dias'),
                  Text('R\$ ${person.valorFinal} Valor Total'),
                  Text('Visualizações: ${person.maxView} / Cliques: ${person.maxClic}'),
                  Text('Compartilhamentos: ${person.maxShares} '),

                ],
              ),
            ),
          );
        },
      ),
      // Botão Pesquisar
      floatingActionButton: FloatingActionButton(
        tooltip: 'Pesquisar Anúncio',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Contact>(
            onQueryUpdate: (s) => print(s),
            items: contacts,
            searchLabel: 'Pesquisar Anúncio',
            suggestion: Center(
              child: Text('Filtrar Anúncios ou Nome do Cliente'),
            ),
            failure: Center(
              child: Text('Nenhum Anúncio Encontrado:('),
            ),
            filter: (person) => [
              person.nameAnuncio,
              person.cliente,
              person.id.toString(),
            ],
            builder: (person) => ListTile(
              title: Text(person.nameAnuncio),
              subtitle: Text(person.cliente),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('R\$ ${person.valorFinal} Valor Total'),
                  Text('Visualizações: ${person.maxView} / Cliques: ${person.maxClic}'),
                  Text('Compartilhamentos: ${person.maxShares} '),
                ],
              ),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
