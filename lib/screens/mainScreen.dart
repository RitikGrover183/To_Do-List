// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isAddingTask = false;

  void _addTask(String title) {
    if (title.isEmpty) return;
    setState(() {
      _tasks.add(Task(title: title, isComplete: false));
      _isAddingTask = false;
    });
    _taskController.clear();
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isComplete = !_tasks[index].isComplete;
    });
  }

  void _showTaskInput() {
    setState(() {
      _isAddingTask = true;
    });
    _focusNode.requestFocus(); 
  }

  @override
  void dispose() {
    _taskController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus(); 
          return false;
        }
        return true; 
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Center(
            child: Text(
              'To-Do List',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: _tasks.isEmpty && !_isAddingTask
                  ? Center(
                      child: Text(
                        'Add a new task now!',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: task.isComplete,
                                onChanged: (_) => _toggleTaskCompletion(index),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      task.isComplete ? "Completed" : "Pending",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: task.isComplete
                                            ? Colors.green
                                            : Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (_isAddingTask)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Enter a task',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => _addTask(_taskController.text),
                        icon: const Icon(
                          Icons.send,
                          color:  Color.fromARGB(255, 39, 122, 42),
                        ))
                  ],
                ),
              ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: _isAddingTask ? null : _showTaskInput,
                child: const Text(
                  'Add a task',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String title;
  bool isComplete;

  Task({required this.title, this.isComplete = false});
}
