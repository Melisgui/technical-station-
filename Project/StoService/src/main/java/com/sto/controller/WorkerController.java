package com.sto.controller;

import com.sto.dto.AppointmentDto;
import com.sto.model.*;
import com.sto.repository.*;
import com.sto.service.DataService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
public class WorkerController {
    private final AppointmentRepository appointmentRepository;
    private final StoRepository stoRepository;
    private final WorkerRepository workerRepository;
    private final WorkerReviewRepository workerReviewRepository;
    private final ServicesRepository servicesRepository;
    private final DataService dataService;

    public WorkerController(AppointmentRepository appointmentRepository, StoRepository stoRepository, WorkerRepository workerRepository, WorkerReviewRepository workerReviewRepository, ServicesRepository servicesRepository, DataService dataService) {
        this.appointmentRepository = appointmentRepository;
        this.stoRepository = stoRepository;
        this.workerRepository = workerRepository;
        this.workerReviewRepository = workerReviewRepository;
        this.servicesRepository = servicesRepository;
        this.dataService = dataService;
    }




    @PostMapping("/worker/appointments/{id}/accept")
    public String acceptAppointment(@PathVariable Integer id, Authentication authentication, RedirectAttributes redirectAttributes) {
        User user = (User) authentication.getPrincipal();
        AppointmentDto appointmentDto = new AppointmentDto();
        Worker worker = workerRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.FORBIDDEN, "Работник не найден"));

        Appointment appointment = appointmentRepository.findById(Integer.valueOf(String.valueOf(id)))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        List<Appointment> workerAppointments = appointmentRepository.findByStatusAndWorker_id("ACCEPTED",worker.getId());

        boolean isTime = dataService.WorkerAppointmentSave(user, appointment, workerAppointments);

        if (!isTime) {
            redirectAttributes.addFlashAttribute("error", "Время заявки пересекается с другими");
            return "redirect:/home-worker";
        }
        Car car = appointmentDto.getCar();
        appointment.setWorker_id(worker.getId());
        appointment.setStatus("ACCEPTED");
        appointment.setCar(car);
        appointmentRepository.save(appointment);

        return "redirect:/home-worker";
    }

    @PostMapping("/worker/appointments/{id}/reject")
    public String rejectAppointment(@PathVariable Integer id) {
        Appointment appointment = appointmentRepository.findById(Integer.valueOf(String.valueOf(id)))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        AppointmentDto appointmentDto = new AppointmentDto();
        Car car = appointmentDto.getCar();
        appointment.setStatus("REJECTED");
        appointment.setCar(car);
        appointmentRepository.save(appointment);

        return "redirect:/home-worker";
    }
    @PostMapping("/complete-appointment")
    public String completeAppointment(
            @RequestParam Integer appointmentId,
            @RequestParam String hours,
            @RequestParam String comment,
            @RequestParam String autoModel,
            @RequestParam String serviceName,
            Authentication authentication
    ) {
        User user = (User) authentication.getPrincipal();
        Worker worker = workerRepository.findByUserId(user.getId())
                .orElseThrow(() -> new RuntimeException("Worker not found"));

        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        appointment.setStatus("COMPLETED");
        appointment.setCar(appointment.getCar());
        appointmentRepository.save(appointment);

        WorkerReview review = new WorkerReview();
        review.setAppointment(appointment);
        review.setServiceName(serviceName);
        review.setWorker(worker);
        review.setHoursForComplete(hours);
        review.setComment(comment);
        review.setAutoModel(autoModel);
        review.setCreatedAt(LocalDateTime.now());

        workerReviewRepository.save(review);

        return "redirect:/home-worker";
    }

    @PostMapping("/cancel-my-appointment")
    public String cancelMyAppointment(Authentication authentication,
                                      @RequestParam Integer appointmentId,
                                      @RequestParam String serviceName) {

        User user = (User) authentication.getPrincipal();
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
        appointment.setStatus("pending");
        appointment.setCar(appointment.getCar());
        appointment.setWorker_id(null);
        appointmentRepository.save(appointment);

        return "redirect:/home-worker";
    }

    @PostMapping("/add-service")
    public String addService(
            @RequestParam String name,
            @RequestParam Double repairHours,
            @RequestParam(required = false) String description,
            @RequestParam Integer stoId,
            Authentication authentication
    ) {
        Sto sto = stoRepository.findById(stoId)
                .orElseThrow(() -> new RuntimeException("СТО не найдена"));

        Services service = new Services();
        service.setName(name);
        service.setRepairHours(repairHours);
        service.setDescription(description);
        service.setSto(sto);

        servicesRepository.save(service);

        return "redirect:/home-worker";
    }
}