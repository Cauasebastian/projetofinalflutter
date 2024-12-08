// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';


class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay _dueTime = TimeOfDay(hour: 12, minute: 0);

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Combinar a data e a hora
      final dueDateTime = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _dueTime.hour,
        _dueTime.minute,
      );

      // Criando a nova tarefa
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch, // ID único baseado no timestamp
        title: _title,
        description: _description,
        creationDate: DateTime.now(),
        dueDate: dueDateTime, userId: '',
      );

      // Convertendo a tarefa para JSON
      final taskJson = newTask.toJson();

      // Enviar para o backend
      try {
        final taskService = TaskService();
        await taskService.addTask(newTask);  // Envia a tarefa para a API

        // Fechar a tela e retornar à tela anterior
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar a tarefa: $e')),
        );
      }
    }
  }


  Future<void> _pickDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  Future<void> _pickDueTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );

    if (pickedTime != null && pickedTime != _dueTime) {
      setState(() {
        _dueTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Nova Tarefa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Nome da Tarefa
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome da Tarefa',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira o nome da tarefa';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!.trim();
                  },
                ),
                SizedBox(height: 20),
                // Descrição da Tarefa
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (value) {
                    _description = value!.trim();
                  },
                ),
                SizedBox(height: 20),
                // Data de Entrega
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Data de Entrega: ${formatDate(_dueDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDueDate,
                      child: Text('Selecionar Data'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Hora de Entrega
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hora de Entrega: ${_dueTime.format(context)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDueTime,
                      child: Text('Selecionar Hora'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Botão de Submissão
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Adicionar Tarefa'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Botão de largura total
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    // Formatar a data
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String formatDateTime(DateTime dateTime) {
    // Formatar a data e a hora
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
