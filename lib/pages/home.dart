import 'dart:convert';

import 'package:another_crud/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Category.dart';
import '../models/product.dart';
import '../widget/search.dart';
import 'add_Page.dart';
import 'details_Product.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<Product> items = [];
  List<Category> itemsCategory = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    CheckLoginIn();
    fetchData();
  }

  Future<void> CheckLoginIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print('desde home ${sharedPreferences.getString('token')}');
    if (sharedPreferences.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext contex) => Login()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: MaterialButton(
            onPressed: fetchData,
            child: searchbox(
              SearchAction: SearchData,
              fetchData: fetchData,
            ),
          ),
        ),
        body: Visibility(
          visible: isLoading,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(
            onRefresh: fetchData,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: ((context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item.productName),
                    subtitle: Text(item.description),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'Edit') {
                        route_Edit(item);
                      } else {
                        DeleteById(item.productId);
                      }
                    }, itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'Edit',
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'Delete',
                        ),
                      ];
                    }),
                  );
                })),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: route_add,
          child: Icon(Icons.add),
        ));
  }

  Future<void> route_Edit(Product product) async {
    final route = MaterialPageRoute(
        builder: (context) => add_page(
              product: product,
            ));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> route_add() async {
    final route = MaterialPageRoute(builder: (context) => add_page());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> DeleteById(int id) async {
    final url = 'https://192.168.100.221:7248/api/Product/$id';

    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      print(response.body);
      //items = items.where((element) => element.productId != id).toList();
      fetchData();
      showSucessMessage("Se ha eliminado correctamente");
    } else {
      showErrorMessage("Error del servidor");
    }
  }

  Future<void> fetchData() async {
    //const url = 'https://192.168.100.221:7248/api/Product';
    const url = 'https://192.168.100.14:7248/api/Product';

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      items = productFromJson(response.body);
    }
    await getCategory();

    setState(() {
      isLoading = true;
    });
  }

  Future<void> SearchData(String value) async {
    final url = 'https://192.168.100.221:7248/api/Product/search/$value';

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      items = productFromJson(response.body);
    }

    if (items.isEmpty) {
      fetchData();
    }

    setState(() {
      isLoading = true;
    });
  }

  void showSucessMessage(String message) {
    final SnackBarMessage = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBarMessage);
  }

  void showErrorMessage(String message) {
    final SnackBarMessage = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBarMessage);
  }

  Future<void> getCategory() async {
    const url = 'https://192.168.100.221:7248/api/Category';

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      itemsCategory = categoryFromJson(response.body);
    }
  }

  Future<void> getProductByCategory(int id) async {
    if (id == 11) {
      setState(() {
        isLoading = false;
      });
      fetchData();
      return;
    }
    final url = 'https://192.168.100.221:7248/api/Product/filterByCategory/$id';

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      items = productFromJson(response.body);
    }

    setState(() {
      isLoading = true;
    });
  }
}

class DrawerPerfil extends StatelessWidget {
  const DrawerPerfil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Agrega un ListView al drawer. Esto asegura que el usuario pueda desplazarse
      // a través de las opciones en el Drawer si no hay suficiente espacio vertical
      // para adaptarse a todo.
      child: ListView(
        // Importante: elimina cualquier padding del ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Perfil'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Actualiza el estado de la aplicación
              // ...
              // Luego cierra el drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // // Actualiza el estado de la aplicación
              // ...
              // Luego cierra el drawer
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext contex) => Login()),
                    (Route<dynamic> route) => false);
              },
              child: Text('Log out'))
        ],
      ),
    );
  }
}
