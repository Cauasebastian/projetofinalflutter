package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.UserService;
import com.example.demo.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/users") // Endpoint base para operações de usuário
public class UserController {

    private final UserService userService;
    private final JwtUtil jwtUtil;

    @Autowired
    public UserController(UserService userService, JwtUtil jwtUtil){
        this.userService = userService;
        this.jwtUtil = jwtUtil;
    }

    /**
     * Obtém as informações do usuário autenticado, incluindo a senha descriptografada.
     *
     * @return Resposta contendo o usuário ou uma mensagem de erro
     */
    @GetMapping
    public ResponseEntity<?> getCurrentUser(){
        String userEmail = getCurrentUserEmail();

        if (userEmail == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Usuário não autenticado.");
        }

        return userService.findByEmail(userEmail)
                .map(user -> ResponseEntity.ok(user))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body(null));
    }

    /**
     * Atualiza os detalhes do usuário autenticado.
     *
     * @param updateRequest Objeto contendo os campos a serem atualizados
     * @return Resposta contendo o usuário atualizado ou uma mensagem de erro
     */
    @PutMapping
    public ResponseEntity<?> updateUser(@Valid @RequestBody UserUpdateRequest updateRequest){
        String userEmail = getCurrentUserEmail();

        if (userEmail == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Usuário não autenticado.");
        }

        return userService.findByEmail(userEmail)
                .map(user -> {
                    if(updateRequest.getName() != null){
                        user.setName(updateRequest.getName());
                    }
                    if(updateRequest.getEmail() != null){
                        if(!user.getEmail().equals(updateRequest.getEmail()) && userService.existsByEmail(updateRequest.getEmail())){
                            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email já está em uso.");
                        }
                        user.setEmail(updateRequest.getEmail());
                    }
                    if(updateRequest.getPassword() != null){
                        user.setPassword(updateRequest.getPassword());
                    }
                    User updatedUser = userService.salvarUsuario(user);
                    return ResponseEntity.ok(updatedUser);
                })
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body(null));
    }

    /**
     * Deleta o usuário autenticado.
     *
     * @return Resposta indicando sucesso ou erro
     */
    @DeleteMapping
    public ResponseEntity<?> deleteUser(){
        String userEmail = getCurrentUserEmail();

        if (userEmail == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Usuário não autenticado.");
        }

        return userService.findByEmail(userEmail)
                .map(user -> {
                    userService.deleteUser(user.getId());
                    return ResponseEntity.ok("Usuário deletado com sucesso.");
                })
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body(null));
    }

    /**
     * Método auxiliar para obter o email do usuário autenticado a partir do contexto de segurança.
     *
     * @return Email do usuário autenticado ou null se não autenticado
     */
    private String getCurrentUserEmail(){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if(authentication == null || !authentication.isAuthenticated()){
            return null;
        }
        return authentication.getName(); // Supondo que o nome de usuário é o email
    }

    // Classe interna para requisições de atualização
    static class UserUpdateRequest {
        @jakarta.validation.constraints.Size(min = 2, max = 50, message = "Name must be between 2 and 50 characters")
        private String name;

        @jakarta.validation.constraints.Email(message = "Invalid email format")
        private String email;

        @jakarta.validation.constraints.Size(min = 8, message = "Password must be at least 8 characters long")
        private String password;

        // Getters e Setters

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }
    }
}