import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class add_page extends StatefulWidget {
  final Product? product;

  const add_page({super.key, this.product});

  @override
  State<add_page> createState() => _add_pageState();
}

class _add_pageState extends State<add_page> {
  TextEditingController Nombre = TextEditingController();
  TextEditingController Description = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      isEdit = true;
      Nombre.text = widget.product!.productName;
      Description.text = widget.product!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEdit ? const Text('Edit') : const Text('Add'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: Nombre,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: Description,
            decoration: const InputDecoration(
              hintText: 'description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? update : submit,
              child: isEdit ? const Text('Update') : const Text('Submit'))
        ],
      ),
    );
  }

  Future<void> update() async {
    try {
      if (Nombre.text.isEmpty || Description.text.isEmpty) {
        showErrorMessage("Uno o mas campos estan vacios");
        return;
      }

      const url = 'https://192.168.100.221:7248/api/Product';
      final body = jsonEncode({
        'productId': widget.product!.productId,
        'productName': Nombre.text,
        'description': Description.text
      });
      final uri = Uri.parse(url);
      final response = await http
          .post(uri, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print(response.body);
        showSucessMessage("Se ha actualizado correctamente");
      }

      print(response.body);

      Nombre.clear();
      Description.clear();
    } catch (e) {
      showErrorMessage("Error del servidor");
      print(e);
    }
  }

  Future<void> submit() async {
    // var headers = {'Content-Type': 'application/json'};
    // var request = http.Request(
    //     'POST', Uri.parse('https://192.168.100.221:7248/api/Product'));
    // request.body = json.encode({
    //   "productId": 0,
    //   "productName": Nombre.text,
    //   "description": Description.text
    // });
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // } else {
    //   print(response.reasonPhrase);
    // }
    try {
      if (Nombre.text.isEmpty || Description.text.isEmpty) {
        showErrorMessage("Uno o mas campos estan vacios");
        return;
      }

      const url = 'https://192.168.100.221:7248/api/Product';
      final body = jsonEncode({
        'productId': 0,
        'productName': Nombre.text,
        'description': Description.text
      });
      final uri = Uri.parse(url);
      final response = await http
          .post(uri, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print(response.body);
        showSucessMessage("Se ha creado correctamente");
      }

      print(response.body);

      Nombre.clear();
      Description.clear();
    } catch (e) {
      showErrorMessage("Error del servidor");
      print(e);
    }
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
}
