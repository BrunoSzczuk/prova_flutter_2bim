import 'package:flutter/material.dart';
import 'package:prova_flutter_2bim/database_helper.dart';
import 'package:prova_flutter_2bim/equipamento.dart';
import 'package:prova_flutter_2bim/main.dart';

class ListaEquipamentos extends StatefulWidget {
  @override
  ListaEquipamentosState createState() => new ListaEquipamentosState();
}

class ListaEquipamentosState extends State<ListaEquipamentos> {
  final dbHelper = DatabaseHelper.instance;
  var data;

  var linhas;
  List<Equipamento> lista = new List();
  @override
  void initState() {
    preencheDados().then((value) {
      //pra funcionar o async, precisa chamar o setState
      setState(() {
       value = value; 
      });
    });
    super.initState();

  }

  Future preencheDados() async {
    linhas = await dbHelper.getAll();
    return await linhas.forEach((linha) => lista.add(new Equipamento(
        linha["ID"],
        linha["NOME"],
        linha["NUM_ETIQUETA"],
        linha["ATIVO"],
        linha["OBSERVACAO"],
        linha["COR"])));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Lista de Equipamentos'),
      ),
      body: new ListView.builder(
        itemCount: lista == null ? 0 : lista.length,
        itemBuilder: (BuildContext context, i) {
          return new ListTile(
              title: new Text(lista[i].nome),
              subtitle: new Text(lista[i].cor),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyApp(equipamento: lista[i])));
              },
              leading: new Text(lista[i].id.toString()));
        },
      ),
    );
  }
}
