package com.sto.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;


@Data
public class WorkerReviewDto {
    @NotNull(message = "ID заказа обязателен")
    private Integer appointmentId;

    @NotBlank(message = "Укажите затраченное время")
    private String hours;

    @Size(max = 1000, message = "Комментарий не должен превышать 1000 символов")
    private String comment;

    @Size(max = 50, message = "Модель авто не должна превышать 50 символов")
    private String autoModel;
}
