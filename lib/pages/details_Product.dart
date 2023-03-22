import 'package:another_crud/models/product.dart';
import 'package:flutter/material.dart';

class details_product extends StatefulWidget {
  final Product product;
  const details_product({super.key, required this.product});

  @override
  State<details_product> createState() => _details_productState();
}

class _details_productState extends State<details_product> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Details screen'),
      ),
      body: Column(children: [
        Container(
          margin: EdgeInsets.all(20),
          width: double.infinity,
          child: Text('image'),
          // child: FadeInImage(
          //   image: NetworkImage(
          //       'https://staticuestudio.blob.core.windows.net/buhomag/2016/03/01195417/pexels-com.jpg'),
          //   placeholder: AssetImage('assets/loading.gif'),
          //   fit: BoxFit.cover,
          //   height: 260,
          // ),
        ),
        Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('widget.product.productName'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Text('widget.product.description'),
            ],
          ),
        )
      ]),
    );
  }
}
