import 'package:flutter_application_1/controllers/toDo_controller.dart';
import 'package:flutter_application_1/models/todo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TodoController c = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddTodoDialog(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 70),
                child: Row(
                  children: [
                    Image.asset('assets/logo.png', width: 90, height: 90),
                    Text(
                      'Haloo!! Sudah catat\naktivitasmu hari ini?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Daftar To-Do List kamu',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 6),
          Expanded(
            child: Obx(() {
              final list = c.todos;
              if (list.isEmpty) {
                return Center(child: Image.asset('assets/ksong.png'));
              }
              return ListView.builder(
                padding: EdgeInsets.only(bottom: 90, top: 6),
                itemCount: list.length,
                itemBuilder: (_, i) => TodoCard(todo: list[i], c: c),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final judulC = TextEditingController();
    final deskC = TextEditingController();
    DateTime DateC = DateTime.now();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              title: Text('Menambahkan To-Do-List'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: judulC,
                      decoration: InputDecoration(labelText: 'Kegiatan Kamu'),
                    ),
                    TextField(
                      controller: deskC,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi Kegiatan',
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tanggal: ${DateC.toLocal().toString().split(' ')[0]}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateC,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => DateC = picked);
                            }
                          },
                          child: Text('Pilih'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Batal'),
                  onPressed: () {
                    judulC.dispose();
                    deskC.dispose();
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final judul = judulC.text.trim();
                    final deskripsi = deskC.text.trim();
                    if (judul.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Judul tidak boleh kosong',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    c.addTodo(judul: judul, deskripsi: deskripsi, date: DateC);

                    judulC.dispose();
                    deskC.dispose();
                    Navigator.pop(context);
                  },
                  child: Text('Tambah'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  final TodoController c;

  const TodoCard({super.key, required this.todo, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color.fromARGB(161, 255, 181, 69),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${todo.date.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.judul,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  todo.deskripsi,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Checkbox(
            value: todo.status,
            activeColor: Colors.orange,
            onChanged: (_) => c.status(todo.id),
          ),
        ],
      ),
    );
  }
}
