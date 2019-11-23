import 'package:flutter/material.dart';
import 'package:prova_flutter_2bim/database_helper.dart';
import 'package:prova_flutter_2bim/equipamento.dart';
import 'package:prova_flutter_2bim/lista_equipamentos.dart';
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Equipamento equipamento;
  MyApp({Key key, this.equipamento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        equipamento: equipamento,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.equipamento}) : super(key: key);

  final String title;
  final Equipamento equipamento;
  @override
  _MyHomePageState createState() => _MyHomePageState(this.equipamento);
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  Equipamento equipamento;
  _MyHomePageState(this.equipamento);
  GlobalKey<FormState> _key = new GlobalKey();
  bool validate = false;
  final num_etiqueta = new TextEditingController();
  final nome = new TextEditingController();
  final cor = new TextEditingController();
  int ativo = 1;
  final observacao = new TextEditingController();
  @override
  void initState() {
    super.initState();
    if (equipamento != null) {
      num_etiqueta.text = equipamento.num_etiqueta;
      nome.text = equipamento.nome;
      cor.text = equipamento.cor;
      ativo = equipamento.ativo;
      observacao.text = equipamento.observacao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Equipamentos"),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //aqui vai o avatar com informações
            new UserAccountsDrawerHeader(
              accountEmail: new Text("bruno.szczuk@gmail.com"),
              accountName: new Text("Bruno Henrique Pereira Szczuk"),
            ),
            new ListTile(
              title: new Text("Lista de Equipamentos"),
              trailing: new Icon(Icons.add_box),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListaEquipamentos()));
              },
            )
          ],
        ),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15),
          child: new Form(
            key: _key,
            autovalidate: validate,
            child: buildScreen(context),
          ),
        ),
      ),
    );
  }

  Widget buildScreen(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Nome'),
          keyboardType: TextInputType.text,
          validator: validateField,
          controller: nome,
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Número da Etiqueta'),
          keyboardType: TextInputType.text,
          validator: validateField,
          controller: num_etiqueta,
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Cor do Equipamento'),
          keyboardType: TextInputType.text,
          validator: validateField,
          controller: cor,
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Observacao'),
          keyboardType: TextInputType.text,
          controller: observacao,
        ),
        Text("Ativo"),
        Checkbox(
          value: ativo == 1,
          onChanged: (bool value) {
            setState(() {
              ativo = value ? 1 : 0;
            });
          },
        ),
        new RaisedButton(
          onPressed: () {
            salvar(context);
          },
          child: Text('Salvar'),
        ),
        new RaisedButton(
          onPressed: () {
            limparTela();
          },
          child: Text('Limpar'),
        ),
        new RaisedButton(
          onPressed: () {
            _remover(equipamento);
          },
          child: Text('Excluir'),
        ),
      ],
    );
  }

  String validateField(String value) {
    if (value.length == 0) {
      return "Informe campo!";
    }
    return null;
  }

  void salvar(BuildContext context) {
    if (_key.currentState.validate()) {
      _inserir();
      limparTela();
    }
  }

  void _inserir() async {
    // linha para inserir
    Map<String, dynamic> row = {
      'NOME': nome.text,
      'NUM_ETIQUETA': num_etiqueta.text,
      'ATIVO': ativo,
      'OBSERVACAO': observacao.text,
      'COR': cor.text
    };
    if (equipamento != null && equipamento.id != null && equipamento.id > 0) {
      final id = await dbHelper.update(row, equipamento.id);
      Toast.show("Atualiza com sucesso. Id: $id", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      final id = await dbHelper.insert(row);
       Toast.show("Adicionado com sucesso. Id: $id", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
    limparTela();
  }

  void _remover(Equipamento equipamento) async {
    if (equipamento != null && equipamento.id != null) {
      print(equipamento.id);
      await dbHelper.remover(equipamento.id);
      equipamento = null;
      Toast.show("Excluido com sucesso.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

    limparTela();
  }

  void limparTela() {
    nome.text = '';
    num_etiqueta.text = '';
    observacao.text = '';
    cor.text = '';
    ativo = 1;
    equipamento = null;
  }
}
