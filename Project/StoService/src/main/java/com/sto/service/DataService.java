package com.sto.service;

import com.sto.model.Appointment;
import com.sto.model.User;
import com.sto.repository.AppointmentRepository;
import com.sto.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class DataService {
    private final UserRepository userRepository;
    private final AppointmentRepository appointmentRepository;

    public DataService(UserRepository userRepository, AppointmentRepository appointmentRepository) {
        this.userRepository = userRepository;
        this.appointmentRepository = appointmentRepository;
    }

    public Boolean WorkerAppointmentSave(User user, Appointment appointment, List<Appointment> appointmentList) {


        LocalDateTime newStartTime = appointment.getDateTime();
        double repairHours = appointment.getService().getRepairHours();
        long durationMinutes = (long) (repairHours * 60);
        LocalDateTime newEndTime = newStartTime.plusMinutes(durationMinutes);

        for (Appointment existingAppointment : appointmentList) {
            if (existingAppointment.getDateTime() == null ||
                    existingAppointment.getService() == null ||
                    existingAppointment.getService().getRepairHours() == null) {
                continue;
            }

            LocalDateTime existingStartTime = existingAppointment.getDateTime();
            double existingRepairHours = existingAppointment.getService().getRepairHours();
            long existingDurationMinutes = (long) (existingRepairHours * 60);
            LocalDateTime existingEndTime = existingStartTime.plusMinutes(existingDurationMinutes);

            if (newStartTime.isBefore(existingEndTime) && newEndTime.isAfter(existingStartTime)) {
                return false;
            }
        }

        return true;
    }

}
