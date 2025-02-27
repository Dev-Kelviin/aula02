import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "255627872752",
      appId: "1:255627872752:android:42ee13bbbff1e1588d3535",
      messagingSenderId: "255627872752",
      projectId: "projectflutteraula1",
      databaseURL: "https://projectflutteraula1-default-rtdb.firebaseio.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _codigo;
  String? _descricao;
  String? _valor;

  TextEditingController _codigoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDados();
  }

  // Função para pegar os dados do Firebase
  Future<void> _getDados() async {
    final codigoEvent = await _database.child('codigo').once();
    final descricaoEvent = await _database.child('descricao').once();
    final valorEvent = await _database.child('valor').once();

    setState(() {
      _codigo = codigoEvent.snapshot.value?.toString();
      _descricao = descricaoEvent.snapshot.value?.toString();
      _valor = valorEvent.snapshot.value?.toString();
    });
  }

  // Função para atualizar os dados no Firebase
  Future<void> _atualizarDados() async {
    if (_codigoController.text.isNotEmpty &&
        _descricaoController.text.isNotEmpty &&
        _valorController.text.isNotEmpty) {
      await _database.child('codigo').set(_codigoController.text);
      await _database.child('descricao').set(_descricaoController.text);
      await _database.child('valor').set(_valorController.text);
      _getDados();
      _codigoController.clear();
      _descricaoController.clear();
      _valorController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Gerenciar Dados no Firebase")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _codigo == null || _descricao == null || _valor == null
                  ? CircularProgressIndicator()
                  : Column(
                    children: [
                      Text("Código: $_codigo"),
                      Text("Descrição: $_descricao"),
                      Text("Valor: $_valor"),
                    ],
                  ),
              SizedBox(height: 20),
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: "Código",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: "Valor",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarDados,
                child: Text("Enviar Dados"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
