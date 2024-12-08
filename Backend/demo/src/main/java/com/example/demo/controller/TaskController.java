package com.example.demo.controller;

import com.example.demo.model.Task;
import com.example.demo.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    private final TaskService taskService;

    @Autowired
    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @GetMapping
    @PreAuthorize("isAuthenticated()") // Somente usuários autenticados
    public ResponseEntity<List<Task>> getAllTasks() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        List<Task> tasks = taskService.getTasksByUser(username);

        if (tasks == null || tasks.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(tasks);
    }

    @PostMapping
    @PreAuthorize("isAuthenticated()") // Somente usuários autenticados
    public ResponseEntity<Task> createTask(@RequestBody Task task) {
        Task createdTask = taskService.createTask(task);
        return ResponseEntity.ok(createdTask);
    }

    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()") // Somente usuários autenticados
    public ResponseEntity<Task> updateTask(@PathVariable String id, @RequestBody Task task) {
        Task updatedTask = taskService.updateTask(id, task);
        if (updatedTask == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updatedTask);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteTask(@PathVariable String id) {
        try {
            taskService.deleteTask(id); // Tenta excluir a tarefa
            return ResponseEntity.ok().build(); // Se não houver exceção, a tarefa foi excluída com sucesso
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build(); // Se a exceção for lançada, a tarefa não foi encontrada
        }
    }

}
