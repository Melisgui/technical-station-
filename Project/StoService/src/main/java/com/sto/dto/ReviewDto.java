package com.sto.dto;

import jakarta.validation.constraints.*;
import lombok.Data;


@Data
public class ReviewDto {
    @NotNull(message = "Укажите оценку")
    @Min(1) @Max(5)
    private Integer rating;

    @Size(max = 1500)
    private String comment;

    @NotNull(message = "Укажите СТО")
    private String stoName;
}
