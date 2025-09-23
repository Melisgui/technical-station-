package com.sto.service;

import com.sto.model.Appointment;
import com.sto.repository.AppointmentRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
@Service
public class AppointmentService {
    private final AppointmentRepository appointmentRepository;

    public AppointmentService(AppointmentRepository appointmentRepository) {
        this.appointmentRepository = appointmentRepository;
    }


    public void AppointmentDel() {
        List<Appointment> appointments = appointmentRepository.findAll();
        LocalDateTime now = LocalDateTime.now();
        for (Appointment appointment : appointments) {
            LocalDateTime appointmentDateTime = appointment.getDateTime();
            if ((appointmentDateTime.isBefore(now) || appointmentDateTime.isEqual(now)) && (Objects.equals(appointment.getStatus(), "pending"))) {
                appointmentRepository.delete(appointment);
            }
        }
    }
}
