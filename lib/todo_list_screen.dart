import 'package:flutter/material.dart';

class MyListItem {
  String title = "";
  String subTitle = "";

  MyListItem(String title, String subTitle) {
    this.title = title;
    this.subTitle = subTitle;
  }
}

List<ListTile> getWidgetsList(List<MyListItem> listItems) {
  List<ListTile> widgets = [];
  for (int i = 0; i < listItems.length; i++) {
    widgets.add(ListTile(
      title: Text(listItems[i].title),
      subtitle: Text(listItems[i].subTitle),
    ));
  }
  return widgets;
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<MyListItem> listItems = [
    MyListItem("Item 1", "Subtitle 1"),
    MyListItem("Item 2", "Subtitle 2")
  ];
  List<MyListItem> newlistItems = [
    MyListItem("Item 1", "Subtitle 1"),
    MyListItem("Item 2", "Subtitle 2")
  ];

  TextEditingController textController = TextEditingController();
  TextEditingController textController1 = TextEditingController();

  void addNewItemToList(String title, String subtitle) {
    setState(() {
      listItems.add(MyListItem(title, subtitle));
    });
  }

  void filterList(String key) {
    setState(() {
      if (key != null) {
        newlistItems = listItems.where((i) => i.title.contains(key)).toList();
      } else {
        newlistItems = listItems.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DevClub TODO List App"),
      ),
      body: ListView(
        children: <Widget>[
              TextField(
                decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "What are you looking for?"),
                controller: textController,
                onChanged: (String newText) {
                  filterList(newText);
                },
              )
            ] +
            getWidgetsList(listItems),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        child: Icon(Icons.add),
        onPressed: () {
          addNewItemToList(
              textController.text, "Enter description here(optional)");
          textController.text = "";
        },
      ),
    );
  }
}
