package com.example.demo.service;

import com.example.demo.model.Task;
import com.example.demo.model.User;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class TaskService {

    private final TaskRepository taskRepository;

    private final UserRepository userRepository;

    @Autowired
    public TaskService(TaskRepository taskRepository, UserRepository userRepository) {
        this.taskRepository = taskRepository;
        this.userRepository = userRepository;
    }

    /**
     * Retrieves all tasks from the repository.
     * @return List of tasks.
     */
    public List<Task> getAllTasks() {
        List<Task> tasks = taskRepository.findAll();
        return tasks.isEmpty() ? new ArrayList<>() : tasks;
    }


    /**
     * Retrieves a task by its ID.
     * @param id Task ID.
     * @return The task if found, or an exception if not found.
     */
    public Task getTaskById(String id) {
        return taskRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Task not found with id: " + id));
    }

    /**
     * Creates a new task.
     * @param task The task to be created.
     * @return The created task.
     */
    public Task createTask(Task task) {
        // Obter o email do usuário autenticado
        String userEmail = getCurrentUserEmail();
        if (userEmail == null) {
            throw new IllegalArgumentException("Usuário não autenticado ou e-mail não encontrado.");
        }

        // Buscar o usuário no repositório
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new IllegalArgumentException("Usuário com e-mail " + userEmail + " não encontrado."));

        // Associar o usuário à tarefa
        task.setUser(user);
        user.getTasks().add(task);

        // Salvar a tarefa no repositório
        return taskRepository.save(task);
    }


    private String getCurrentUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName(); // O e-mail está no "username"
        }
        return null;
    }

    /**
     * Updates an existing task by ID.
     * @param id Task ID.
     * @param task The updated task data.
     * @return The updated task.
     */
    public Task updateTask(String id, Task task) {
        // Ensure the task exists before updating
        Task existingTask = getTaskById(id);
        existingTask.setTitle(task.getTitle());
        existingTask.setDescription(task.getDescription());
        existingTask.setCompleted(task.isCompleted());
        existingTask.setDeliveryDate(task.getDeliveryDate());
        existingTask.setCompletedAt(task.getCompletedAt());
        existingTask.setMarkedAsFavorite(task.isMarkedAsFavorite());
        // Save the updated task
        return taskRepository.save(existingTask);
    }

    /**
     * Deletes a task by its ID.
     * @param id Task ID.
     */
    public void deleteTask(String id) {
        Task task = getTaskById(id); // Check if task exists
        taskRepository.delete(task);
    }
    public List<Task> getTasksByUser(String username) {
        Optional<User> user = userRepository.findByEmail(username); // Ou método de busca por usuário
        if (user.isEmpty()) {
            return new ArrayList<>();
        }
        return taskRepository.findByUser(user.orElse(null)); // Assumindo que você tenha um repositório para isso
    }

}
