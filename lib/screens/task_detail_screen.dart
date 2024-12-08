import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deliveryDateController;
  bool _isFavorite = false;
  bool _isEditing = false;  // Estado para saber se estamos em modo de edição

  late String _originalTitle;
  late String _originalDescription;
  late DateTime _originalDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _deliveryDateController = TextEditingController(text: widget.task.dueDate.toLocal().toString().split(' ')[0]);
    _isFavorite = widget.task.isFavorite;

    // Armazenando os valores originais
    _originalTitle = widget.task.title;
    _originalDescription = widget.task.description;
    _originalDueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  void _toggleEditingMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _discardChanges() {
    setState(() {
      // Restaurar os valores originais
      _titleController.text = _originalTitle;
      _descriptionController.text = _originalDescription;
      _deliveryDateController.text = _originalDueDate.toLocal().toString().split(' ')[0];
      _isEditing = false;
    });
  }

  void _saveChanges(TaskProvider taskProvider) async {
    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      creationDate: widget.task.creationDate,
      dueDate: widget.task.dueDate,
      isFavorite: _isFavorite,
      completionDate: widget.task.completionDate,
      userId: widget.task.userId,
    );

    await taskProvider.updateTask(updatedTask);  // Atualizar no servidor
    setState(() {
      _isEditing = false;
      widget.task = updatedTask;  // Atualizar a tarefa localmente
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Tarefa'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null, // Muda a cor para vermelho se for favorita
            ),
            onPressed: () async {
              setState(() {
                _isFavorite = !_isFavorite; // Atualiza o estado local para feedback instantâneo
              });
              // Criando um novo objeto Task com o status de favorito alterado
              final updatedTask = Task(
                id: widget.task.id,
                title: widget.task.title,
                description: widget.task.description,
                creationDate: widget.task.creationDate,
                dueDate: widget.task.dueDate,
                isFavorite: _isFavorite, // Alterando o status de favorito
                completionDate: widget.task.completionDate,
                userId: widget.task.userId,
              );
              await taskProvider.updateTask(updatedTask); // Atualiza no servidor
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da tarefa
            _isEditing
                ? TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            )
                : Text(
              widget.task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Descrição da tarefa
            _isEditing
                ? TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            )
                : Text(widget.task.description),
            SizedBox(height: 10),

            // Data de Entrega
            _isEditing
                ? TextField(
              controller: _deliveryDateController,
              decoration: InputDecoration(labelText: 'Data de Entrega'),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode()); // Remove o foco para evitar abrir o teclado
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.task.dueDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != widget.task.dueDate) {
                  setState(() {
                    widget.task.dueDate = pickedDate;
                    _deliveryDateController.text = pickedDate.toLocal().toString().split(' ')[0]; // Atualizar o campo de texto
                  });
                }
              },
            )
                : Text(widget.task.dueDate.toLocal().toString().split(' ')[0]),
            SizedBox(height: 20),

            // Botões de Ação: Editar, Concluir ou Descartar alterações
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Botão de editar
                _isEditing
                    ? ElevatedButton(
                  onPressed: () => _saveChanges(taskProvider),
                  child: Text('Concluir Alterações'),
                )
                    : ElevatedButton(
                  onPressed: _toggleEditingMode,
                  child: Text('Editar'),
                ),
                SizedBox(width: 20),

                // Botão de descartar alterações
                _isEditing
                    ? ElevatedButton(
                  onPressed: _discardChanges,
                  child: Text('Descartar Alterações'),
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                )
                    : Container(),
              ],
            ),
            SizedBox(height: 20),

            // Botão de excluir tarefa
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                taskProvider.deleteTask(widget.task.id);
                Navigator.pop(context); // Voltar para a lista
              },
            ),
          ],
        ),
      ),
    );
  }
}
