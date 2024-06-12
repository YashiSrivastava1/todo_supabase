class ToDo {
  int? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
     this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: 1, todoText: 'Todo Item 1', isDone: true ),
      ToDo(id: 2, todoText: 'Todo Item 2', isDone: true ),
      ToDo(id: 3, todoText: 'Todo Item 3', ),
      ToDo(id: 4, todoText: 'Todo Item 4', ),
      ToDo(id: 5, todoText: 'Todo Item 5', ),
      ToDo(id: 6, todoText: 'Todo Item 6', ),
    ];
  }
}