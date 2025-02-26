import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "xxxxxxx",
      appId: "xxxxxxx",
      messagingSenderId: "xxxxxxx",
      projectId: "xxxxxxx",
      databaseURL: "xxxxxxx",
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
  String? _versao;
  TextEditingController _versaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getVersao();
  }

  // Função para pegar a versão do Firebase
  Future<void> _getVersao() async {
    final event = await _database.child('versao').once();
    setState(() {
      _versao = event.snapshot.value?.toString();
    });
  }

  // Função para atualizar a versão no Firebase
  Future<void> _atualizarVersao() async {
    if (_versaoController.text.isNotEmpty) {
      await _database.child('versao').set(_versaoController.text);
      _getVersao(); 
      _versaoController.clear(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Versão do Firebase")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _versao == null
                  ? CircularProgressIndicator()
                  : Text("Versão no Firebase: $_versao"),
              SizedBox(height: 20),
              TextField(
                controller: _versaoController,
                decoration: InputDecoration(
                  labelText: "Nova versão",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarVersao,
                child: Text("Atualizar Versão"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
