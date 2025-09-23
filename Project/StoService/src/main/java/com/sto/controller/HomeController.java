package com.sto.controller;


import com.sto.dto.WorkerReviewDto;
import com.sto.model.Appointment;
import com.sto.model.Sto;
import com.sto.model.User;
import com.sto.model.Worker;
import com.sto.repository.AppointmentRepository;
import com.sto.repository.ClientRepository;
import com.sto.repository.StoRepository;
import com.sto.repository.WorkerRepository;
import com.sto.service.AppointmentService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Controller
public class HomeController {

    private final StoRepository stoRepository;
    private final WorkerRepository workerRepository;
    private final AppointmentRepository appointmentRepository;
    private final AppointmentService appointmentService;


    public HomeController(StoRepository stoRepository, WorkerRepository workerRepository, AppointmentRepository appointmentRepository, AppointmentService appointmentService) {
        this.stoRepository = stoRepository;
        this.workerRepository = workerRepository;
        this.appointmentRepository = appointmentRepository;
        this.appointmentService = appointmentService;
    }

    @GetMapping("/home-client")
    public String homeClient(Authentication authentication, Model model) {
        User user = (User) authentication.getPrincipal();
        model.addAttribute("user", user);
        model.addAttribute("stoList", stoRepository.findAll());
        return "clientPages/home-client";
    }


    @GetMapping("/home-worker")
    public String homeWorker(
            Authentication authentication,
            Model model
    ) {
        appointmentService.AppointmentDel();
        model.addAttribute("reviewDto", new WorkerReviewDto());
        User user = (User) authentication.getPrincipal();
        Worker worker = workerRepository.findByUserId(user.getId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.FORBIDDEN, "Работник не найден"));

        Sto sto = worker.getSto() != null
                ? stoRepository.findById(worker.getSto().getId()).orElse(null)
                : null;

        List<Appointment> newAppointments = appointmentRepository.findNewAppointmentsBySto(sto.getId());
        List<Appointment> myAppointments = appointmentRepository.findByStatusAndWorker_id("ACCEPTED", worker.getId());
        List<Appointment> myCompletedAppointments = appointmentRepository.findByStatusAndWorker_id("COMPLETED", worker.getId());

        model.addAttribute("user", user);
        model.addAttribute("worker", worker);
        model.addAttribute("sto", sto);
        model.addAttribute("newAppointments", newAppointments);
        model.addAttribute("myAppointments", myAppointments);
        model.addAttribute("myCompletedAppointments", myCompletedAppointments);

        return "workerPages/home-worker";
    }


    @GetMapping("/home")
    public String home(Authentication authentication, Model model) {


        User user = (User) authentication.getPrincipal();
        if (user.getRole() == User.Role.WORKER) {
            Worker worker = workerRepository.findByUserId(user.getId()).orElse(null);
            model.addAttribute("worker", worker);
            assert worker != null;
            Sto sto = stoRepository.findById(worker.getSto().getId()).orElse(null);
            model.addAttribute("user", user);
            model.addAttribute("sto", sto);
            return "redirect:/home-worker";
        } else if (user.getRole() == User.Role.CLIENT) {
            model.addAttribute("user", user);
            List<Sto> stoList = stoRepository.findAll();
            model.addAttribute("stoList", stoList);
            return "clientPages/home-client";
        }
        if(user.getRole() == User.Role.admin) {
            return "redirect:/admin";
        }
        return "/register";
    }


}
