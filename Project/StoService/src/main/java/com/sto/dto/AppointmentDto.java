package com.sto.dto;

import com.sto.model.Car;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class AppointmentDto {
    @NotNull(message = "СТО не выбрана")
    private Integer stoId;

    @NotNull(message = "Услуга не выбрана")
    private Integer serviceId;

    @NotNull(message = "Дата и время обязательны")
    @Future(message = "Дата должна быть в будущем")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime dateTime;

    @NotNull(message = "Выберите автомобиль")
    private Car car;
}