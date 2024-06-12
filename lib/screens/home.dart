import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/todo.dart';

import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  late final Stream<List<Map<String, dynamic>>> _todoStream;

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
    _todoStream = Supabase.instance.client
        .from('todos')
        .stream(primaryKey: ['id']); //.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                searchBox(),
                Container(
                  margin: EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                  ),
                  child: Text(
                    'Todo List',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // for (ToDo todoo in _foundToDo.reversed)
                //   ToDoItem(
                //     todo: todoo,
                //     onToDoChanged: _handleToDoChange,
                //     onDeleteItem: _deleteToDoItem,
                //   ),
                random(context)
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Create a todo', border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    //primary: tdBlue,
                    backgroundColor: Colors.black,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Future<void> _handleToDoChange(ToDo todo) async {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    final updatedStatus = !todo.isDone;
    await Supabase.instance.client
        .from('todos')
        .update({'status': !todo.isDone})
        .eq('id', todo.id!)
        .select();
  }

  Future<void> _deleteToDoItem(int id) async {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
    await Supabase.instance.client.from("todos").delete().eq('id', id).select();
  }

  Future<void> _addToDoItem(String toDo) async {
    await Supabase.instance.client
        .from("todos")
        .insert({'task': toDo, 'status': false});
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch,
        todoText: toDo,
      ));
    });

    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        title: Center(
            child: Text(
          'Todo App',
          style: TextStyle(fontWeight: FontWeight.bold),
        )));
  }
}

// Widget random(BuildContext context) {
//   final _future =
//       Supabase.instance.client.from('todos').stream(primaryKey: ['id']);

//   return StreamBuilder(
//       stream: _future,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final todos = snapshot.data!;
//         return Expanded(
//           child: ListView.builder(
//             itemCount: todos.length,
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemBuilder: ((context, index) {
//               final todosList = todos[index];
//               final id = todosList['id'] as int;
//               print(id);
//               return ListTile(
//                 title: Row(
//                   children: [
//                     Text(todosList['task']),
//                     ElevatedButton(
//                         onPressed: () async {
//                           print("updated $id");
//                           final a = await Supabase.instance.client
//                               .from("todos")
//                               .update({"task": ToDo, "status": true})
//                               .eq("id", id)
//                               .select();
//                           //log(a.toString());
//                         },
//                         child: const Text("change")),
//                     ElevatedButton(
//                         onPressed: () async {
//                           print("deleted $id");
//                           final a = await Supabase.instance.client
//                               .from("todos")
//                               .delete()
//                               .eq("id", id);
//                           //log(a.toString());
//                         },
//                         child: const Text("delete"))
//                   ],
//                 ),
//               );
//             }),
//           ),
//         );
//       });
// }

Widget random(BuildContext context) {
  final _future =
      Supabase.instance.client.from('todos').stream(primaryKey: ['id']);

  return StreamBuilder(
      stream: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final todos = snapshot.data!;
        return Expanded(
          child: ListView.builder(
            itemCount: todos.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: ((context, index) {
              final todosList = todos[index];
              final id = todosList['id'] as int;
              final bool status = todosList['status'] as bool; // Extract status
              print(id);
              return ListTile(
                title: Row(
                  children: [
                    Text(todosList['task']),
                    // Change button text based on status
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     print("updated $id");
                    //     final a = await Supabase.instance.client
                    //         .from("todos")
                    //         .update({
                    //           "task": ToDo,
                    //           "status": !status
                    //         }) // Toggle status
                    //         .eq("id", id)
                    //         .select();
                    //   },
                    //   child: Text(
                    //       status ? "Completed" : "Change"), // Display status
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        print("Updating todo with ID: $id");
                        try {
                          final updated = await Supabase.instance.client
                              .from("todos")
                              .update({"status": !status}) // Toggle status
                              .eq("id", id);
                          //.execute(); // Use execute() instead of select() to execute the update
                          print("Update result: $updated");
                        } catch (e) {
                          print("Error updating todo: $e");
                        }
                      },
                      child: Text(status ? "Completed" : "Change"),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        print("deleted $id");
                        final a = await Supabase.instance.client
                            .from("todos")
                            .delete()
                            .eq("id", id);
                      },
                      child: const Text("delete"),
                    )
                  ],
                ),
              );
            }),
          ),
        );
      });
}
