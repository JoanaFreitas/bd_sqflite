import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//aqui cria o banco de dados
  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          "CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
      db.execute(sql);
    });
    return bd;
    //print("aberto: "+bd.isOpen.toString());
  }

//aqui salvo coisas no bancode dados
  _salvar() async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Murilo ",
      "idade": 25,
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("salvo: $id ");
  }

  //aqui ver o que tem no banco
  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
   // String sql = "SELECT * FROM usuarios";
   // String sql = "SELECT * FROM usuarios WHERE idade = 17";
   // String sql = "SELECT * FROM usuarios WHERE idade = 17 OR idade = 30";
    //String sql = "SELECT * FROM usuarios WHERE idade  >=17 And idade <=30";
     //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 16 AND 50";
     //String sql = "SELECT * FROM usuarios WHERE idade IN(18,30)";
    //String sql = "SELECT * FROM usuarios WHERE nome = 'Joana'";//dado exatamente igual
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE 'Jo%'";//usando % traz td q tem aparte descrita(ele autocompleta)
//String filtro = "an"; String sql = "SELECT * FROM usuarios WHERE nome LIKE '%"+ filtro +"%'";
    //String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY nome ASC";//ASC ,DESC
   // String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY UPPER (nome) ASC";//ordena letra maiuscula
  //  String sql = "SELECT *, UPPER (nome) as nome2 FROM usuarios WHERE 1=1 ORDER BY UPPER (nome) ASC";//converte letra maiuscula
    String sql = "SELECT * FROM usuarios ";

    List usuarios = await bd.rawQuery(sql);
    for(var usuario in usuarios){
      print(
        "item id: "+usuario['id'].toString()+
          " nome: "+usuario['nome']+
          //  " nome2: "+usuario['nome2']+
           " idade: "+usuario['idade'].toString()
      );
    }
   // print("Usuarios: " + usuarios.toString());
  }

  //recuperar usuario pelo id
  _listarUsuarioPeloId(int id)async{
    Database bd = await _recuperarBancoDados();
//CRUD-> create,read,update and delete
  List usuarios = await bd.query(
    "usuarios",
    columns: ["id","nome","idade"],
    where: "id = ?",
    whereArgs: [id]
  );
    for(var usuario in usuarios){
      print(
          "item id: "+usuario['id'].toString()+
              " nome: "+usuario['nome']+
              " idade: "+usuario['idade'].toString()
      );
    }
  }

  //exluir usuario
  _excluirUsuario(int id)async{
    Database bd = await _recuperarBancoDados();

    int retorno =await bd.delete(
      "usuarios",
      where: "id=?",
      whereArgs: [id]
    );
    print("item qtde removida: $retorno");
  }

  //atualizar usuario
  _atualizarUsuario(int id)async{
    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Maria",
      "idade": 15,
    };
    int retorno = await bd.update(
        "usuarios",
        dadosUsuario,
      where: "id = ?",
      whereArgs: [id]
    );
    print("item qtde atualizada: $retorno");
  }

  @override
  Widget build(BuildContext context) {
    _salvar();
  // _listarUsuarios();
    //_listarUsuarioPeloId(3);
   // _excluirUsuario(16);
   // _atualizarUsuario(15);
     _listarUsuarios();
    return Container();
  }
}
