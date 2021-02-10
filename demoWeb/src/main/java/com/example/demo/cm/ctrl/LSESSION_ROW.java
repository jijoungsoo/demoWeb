package com.example.demo.cm.ctrl;

import com.fasterxml.jackson.annotation.JsonProperty;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class LSESSION_ROW {
    @JsonProperty("USER_NO")
    @Schema(name = "USER_NO", example = "1", description = "사용자NO")
    String USER_NO;
}
