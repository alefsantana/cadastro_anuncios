import 'package:cadastro_usurarios/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';


class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  final _nameAnuncioController = TextEditingController();
  final _clienteController = TextEditingController();
  final _diasController = TextEditingController();
  int _valueFinalController;
  var _valueViewController;
  var _valueClicController;
  var _valueSharingController;
  final _valueDayController = TextEditingController();

  final nameFocus = FocusNode();
  final clienteFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;
  DateTime _dateTimeInicio;
  DateTime _dateTimeTermino;

  @override
  void initState() {
    super.initState();
    _getAllContacts();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameAnuncioController.text = _editedContact.nameAnuncio;
      _clienteController.text = _editedContact.cliente;
      _diasController.text = _editedContact.dias;
      _valueFinalController = _editedContact.valorFinal;
      _valueViewController = _editedContact.maxView;
      _valueClicController = _editedContact.maxClic;
      _valueSharingController = _editedContact.maxShares;
      _valueDayController.text = _editedContact.valorDia;
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestpop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(_editedContact.cliente ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.nameAnuncio != null &&
                _editedContact.nameAnuncio.isNotEmpty &&
                _editedContact.cliente.isNotEmpty &&
                _editedContact.cliente != null) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(nameFocus);
              FocusScope.of(context).requestFocus(clienteFocus);
            }
          },
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("images/person.png"),
                      )),
                ),
              ),
              Divider(),
              TextField(
                controller: _nameAnuncioController,
                focusNode: nameFocus,
                decoration: InputDecoration(labelText: "Nome Do Anúncio"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.nameAnuncio = text;
                },
              ),
              TextField(
                controller: _clienteController,
                focusNode: clienteFocus,
                decoration: InputDecoration(labelText: "Nome Do Cliente"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.cliente = text;
                  });
                },
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Início:"),
                  IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2022),
                          locale: Localizations.localeOf(context),
                        ).then((date) {
                          setState(() {
                            _dateTimeInicio = date;
                            print(_dateTimeInicio);
                          });
                        });
                      }),
                  Text("Término"),
                  IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2022),
                          locale: Localizations.localeOf(context),
                        ).then((date) {
                          setState(() {
                            _dateTimeTermino = date;

                            print(_dateTimeTermino);
                            DateTime dob =
                                DateTime.parse(_dateTimeInicio.toString());
                            Duration dur =
                                DateTime.parse(_dateTimeTermino.toString())
                                    .difference(dob);
                            String differenceInYears =
                                (dur.inDays).floor().toString();
                            setState(() {
                              DateFormat("dd-MM-yyyy").format(DateTime.now());

                              print(differenceInYears);

                              _editedContact.dataInicio =
                                  _dateTimeInicio.toString();
                              _editedContact.dias = differenceInYears;
                            });
                            return new Text(differenceInYears + ' years');
                          });
                        });
                      }),
                ],
              ),
              Divider(),
              TextField(
                readOnly: true,
                controller: _diasController,
                decoration: InputDecoration(labelText: "Dias de Anúncio "),
                onChanged: (differenceInYears) {
                  setState(() {
                    _userEdited = true;
                    _editedContact.dias = differenceInYears;
                  });
                },
              ),
              TextField(
                controller: _valueDayController,
                decoration: InputDecoration(
                    labelText: "Valor Diário do Investimento  "),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.valorDia = text;
                    print(_editedContact.valorDia);
                    var result = int.parse(_editedContact.valorDia);
                    //print("O inteiro é $result");
                    var resultdias = int.parse(_editedContact.dias);
                    resultdias = resultdias * result;
                    //("O inteiro é $resultdias");
                    _valueFinalController = resultdias;
                    //print(_valorFinalController);
                    _editedContact.valorFinal = _valueFinalController;
                    // Funcação Para Armazenar o Calculo
                    calculo();
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestpop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações ?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void calculo() {
    double reais = _valueFinalController.toDouble();
    print(reais);
    double view = 30;
    double totalview;
    double clic = 0.12;
    double finalResult = 0;
    double sharing = 0.15;
    double newview = 40;
    double sequencia = 4;

    totalview = reais * view;
    finalResult = totalview * clic;
    clic = finalResult;
    print(clic);
    finalResult = finalResult * sharing;
    sharing = finalResult;
    print(sharing);
    finalResult = finalResult * newview;
    finalResult = finalResult * sequencia;
    finalResult = finalResult + totalview;


    _valueClicController = clic;
    _valueViewController = finalResult;
    _valueSharingController = sharing;
    print(_valueSharingController);
    _editedContact.maxView = _valueViewController;
    _editedContact.maxClic = _valueClicController;
    _editedContact.maxShares = _valueSharingController;
    print(_editedContact.maxView);
  }
}
