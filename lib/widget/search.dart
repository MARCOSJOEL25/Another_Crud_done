import 'package:flutter/material.dart';

class searchbox extends StatelessWidget {
  final SearchAction;
  final fetchData;

  const searchbox({
    super.key,
    this.SearchAction,
    this.fetchData,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (value.isEmpty) {
          fetchData();
        }
        SearchAction(value);
      },
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black,
          size: 20,
        ),
        prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
        border: InputBorder.none,
        hintText: "Search",
      ),
    );
  }
}