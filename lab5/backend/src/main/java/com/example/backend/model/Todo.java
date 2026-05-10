package com.example.backend.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "todos")
public class Todo {
    @Id
    @JsonProperty("_id")
    private String id;

    private String userId;
    private String title;
    private String desc;

    public Todo(String userId, String title, String desc) {
        this.userId = userId;
        this.title = title;
        this.desc = desc;
    }
}
