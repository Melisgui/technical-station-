package com.sto.controller;

import com.sto.model.Car;
import com.sto.model.Client;
import com.sto.model.User;
import com.sto.repository.CarRepository;
import com.sto.repository.ClientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/cars")
public class CarController {

    private final CarRepository carRepository;
    private final ClientRepository clientRepository;

    @Autowired
    public CarController(CarRepository carRepository, ClientRepository clientRepository) {
        this.carRepository = carRepository;

        this.clientRepository = clientRepository;
    }

    @GetMapping("/add")
    public String showAddCarForm(Authentication authentication, Model model,@ModelAttribute("vinError") String vinError) {
        User user = (User) authentication.getPrincipal();
        model.addAttribute("car", new Car());
        model.addAttribute("clientId", user.getClient().getId());

        if (vinError != null && !vinError.isEmpty()) {
            model.addAttribute("vinError", vinError);
        }

        return "clientPages/add-car";
    }

    @PostMapping("/save")
    public String saveCar(@ModelAttribute Car car, Authentication authentication,RedirectAttributes redirectAttributes) {
        User user = (User) authentication.getPrincipal();
        Client client = user.getClient();

        if (carRepository.existsByVin(car.getVin())) {
            redirectAttributes.addFlashAttribute("vinError", "Данный VIN номер уже занят");
            redirectAttributes.addFlashAttribute("car", car);
            redirectAttributes.addFlashAttribute("clientId", user.getClient().getId());
            return "redirect:/cars/add";
        }


        if (car.getBrand() != null) {
            client.setCarBrand(car.getBrand());
        }
        if (car.getModel() != null) {
            client.setCarModel(car.getModel());
        }
        if (car.getYear() != null) {
            client.setCarYear(car.getYear());
        }

        car.setClient(client);

        clientRepository.save(client);
        carRepository.save(car);

        return "redirect:/user-profile";
    }
}