// lib/models/task.dart

import 'dart:convert';

class Task {
  final int id;
  late final String title;
  late final String description;
  final DateTime creationDate;
  DateTime dueDate;
  bool isFavorite;
  DateTime? completionDate;
  final String userId; // Adicionando o ID do usuário (se necessário)

  // Construtor da classe Task
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.dueDate,
    this.isFavorite = false,  // Inicializando com 'false'
    this.completionDate,
    required this.userId, // Passando o ID do usuário
  });

  // Convertendo a tarefa para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(), // Convertendo para string se o backend precisar
      'title': title,
      'description': description,
      'createdAt': creationDate.toIso8601String(), // Usando o nome esperado 'createdAt'
      'deliveryDate': dueDate.toIso8601String(),   // Usando o nome esperado 'deliveryDate'
      'markedAsFavorite': isFavorite,              // Usando o nome esperado 'markedAsFavorite'
      'completed': completionDate != null,         // O backend parece esperar um campo 'completed'
      'user': {                                    // Se for necessário, adicione o usuário
        'id': userId,
      }
    };
  }

  // Criando uma instância de Task a partir de um JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json['id'].toString()),  // Garantir que o ID seja sempre um número inteiro
      title: json['title'],
      description: json['description'],
      creationDate: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),  // Verificar se 'createdAt' não é null
      dueDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : DateTime.now(),  // Verificar se 'deliveryDate' não é null
      isFavorite: json['markedAsFavorite'] ?? false,
      completionDate: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      userId: json['user']['id'],  // Supondo que o ID do usuário esteja em 'user'
    );
  }
}
