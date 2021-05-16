import 'package:cadastro_usurarios/helpers/contact_helper.dart';
import 'package:cadastro_usurarios/home/contact_page.dart';
import 'package:cadastro_usurarios/home/page_reports.dart';

import 'package:cadastro_usurarios/widgets/custtom_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Anúncios"),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showContactPage();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          body: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return _contactCard(context, index);
              }),
          drawer: CustomDrawer(_pageController),
        ),

        Scaffold(
          appBar: AppBar(
            title: Text("Relatórios"),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: MyApp(),
        ),
      ],
    );
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactPage(
                contact: contact,
              )),
    );
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      await _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  Widget _contactCard(BuildContext context, int index) {
    //List<Contact> contacts = List();
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage("images/informatica.png")),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Anúncio: ${contacts[index].nameAnuncio ?? ""}",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Cliente: ${contacts[index].cliente ?? ""}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "Duração: ${contacts[index].dias ?? ""} Dias",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        "Valor Diário: R\$ ${contacts[index].valorDia ?? ""}",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        "Valor Total: R\$ ${contacts[index].valorFinal ?? ""}",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                width: 50,
                height: 90,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text("Exlucir Produto"),
                                content: Text("Tem Certeza"),
                                actions: [
                                  FlatButton(
                                    child: Text('Não'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Sim'),
                                    onPressed: () {
                                      helper.deleteContact(contacts[index].id);
                                      setState(() {
                                        contacts.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ]),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showContactPage(contact: contacts[index]);
      },
    );
  }
}
