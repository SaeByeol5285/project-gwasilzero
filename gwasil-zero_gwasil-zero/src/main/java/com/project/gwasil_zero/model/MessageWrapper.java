package com.project.gwasil_zero.model;

import lombok.Data;

@Data
public class MessageWrapper {
    private String type; // "text", "file"
    private Object payload; // ChatMessage 또는 ChatFile 등
}