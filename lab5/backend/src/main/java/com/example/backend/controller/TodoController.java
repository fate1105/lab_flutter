package com.example.backend.controller;

import com.example.backend.model.Todo;
import com.example.backend.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
public class TodoController {

    @Autowired
    private TodoRepository todoRepository;

    @PostMapping("/storeTodo")
    public ResponseEntity<?> storeTodo(@RequestBody Map<String, String> payload) {
        String userId = payload.get("userId");
        String title = payload.get("title");
        String desc = payload.get("desc");

        Todo todo = new Todo(userId, title, desc);
        todoRepository.save(todo);

        Map<String, Object> response = new HashMap<>();
        response.put("status", true);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/getUserTodoList")
    public ResponseEntity<?> getUserTodoList(@RequestBody Map<String, String> payload) {
        String userId = payload.get("userId");

        List<Todo> todos = todoRepository.findByUserId(userId);

        Map<String, Object> response = new HashMap<>();
        response.put("success", todos);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/deleteTodo")
    public ResponseEntity<?> deleteTodo(@RequestBody Map<String, String> payload) {
        String id = payload.get("id");

        todoRepository.deleteById(id);

        Map<String, Object> response = new HashMap<>();
        response.put("status", true);
        return ResponseEntity.ok(response);
    }
}
