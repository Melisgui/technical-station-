package com.sto.controller;


import com.sto.dto.AppointmentDto;
import com.sto.model.*;
import com.sto.repository.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class AppointmentController {
    private final StoRepository stoRepository;
    private final ClientRepository clientRepository;
    private final ServicesRepository serviceRepository;
    private final AppointmentRepository appointmentRepository;
    private final CarRepository carRepository;

    @GetMapping("/add-appointment/{stoId}")
    public String showAppointmentForm(
            @PathVariable Integer stoId,
            Model model,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();
        Client client = clientRepository.findByUserId(user.getId());
        Sto sto = stoRepository.findById(stoId)
                .orElseThrow(() -> new IllegalArgumentException("СТО не найдена"));

        List<Car> cars = carRepository.findByClientId(client.getId());

        AppointmentDto dto = new AppointmentDto();
        dto.setStoId(stoId);
        model.addAttribute("appointmentDto", dto);
        model.addAttribute("selectedSto", sto);
        model.addAttribute("services", serviceRepository.findByStoId(stoId));
        model.addAttribute("clientId", client.getId());
        model.addAttribute("cars", cars);

        return "clientPages/add-appointment";
    }

    @PostMapping("/save-appointment")
    public String saveAppointment(
            @Valid @ModelAttribute("appointmentDto") AppointmentDto appointmentDto,
            @RequestParam Integer stoId,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Authentication authentication) {

        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute(
                    "org.springframework.validation.BindingResult.appointmentDto",
                    bindingResult);
            redirectAttributes.addFlashAttribute("appointmentDto", appointmentDto);
            return "redirect:/add-appointment/" + stoId;
        }

        try {
            User user = (User) authentication.getPrincipal();
            Client client = clientRepository.findByUserId(user.getId());

            if (client == null) {
                throw new IllegalArgumentException("Клиент не найден");
            }

            Sto sto = stoRepository.findById(stoId)
                    .orElseThrow(() -> new IllegalArgumentException("СТО не найдена"));
            Services service = serviceRepository.findById(appointmentDto.getServiceId())
                    .orElseThrow(() -> new IllegalArgumentException("Услуга не найдена"));
            Car car = appointmentDto.getCar();

            LocalDateTime dateTime = appointmentDto.getDateTime()
                    .atZone(ZoneId.systemDefault()).toLocalDateTime();

            if (dateTime.isBefore(LocalDateTime.now())) {
                redirectAttributes.addFlashAttribute("error", "Нельзя выбрать прошедшую дату");
                return "redirect:/add-appointment/" + stoId;
            }

            if (appointmentRepository.existsByDateTimeAndSto(dateTime, sto)) {
                redirectAttributes.addFlashAttribute("error", "Выбранное время уже занято");
                return "redirect:/add-appointment/" + stoId;
            }


            Appointment appointment = new Appointment();
            appointment.setCar(car);
            appointment.setSto(sto);
            appointment.setService(service);
            appointment.setClient(client);
            appointment.setStatus("pending");
            appointment.setDateTime(dateTime);

            appointmentRepository.save(appointment);

            redirectAttributes.addFlashAttribute("success", "Запись успешно создана!");
            return "redirect:/home";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Ошибка: " + e.getMessage());
            return "redirect:/add-appointment/" + stoId;
        }
    }
}