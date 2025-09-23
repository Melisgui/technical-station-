package com.sto.controller;

import com.sto.model.User;
import com.sto.model.Worker;
import com.sto.repository.UserRepository;
import com.sto.repository.WorkerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.server.ResponseStatusException;

@Controller
@RequestMapping("/change-profile")
public class ProfileChangeController {

    private final UserRepository userRepository;
    private final WorkerRepository workerRepository;

    @Autowired
    public ProfileChangeController(UserRepository userRepository, WorkerRepository workerRepository) {
        this.userRepository = userRepository;
        this.workerRepository = workerRepository;
    }

    @GetMapping
    public String showEditForm(Authentication authentication, Model model) {
        User user = (User) authentication.getPrincipal();
        model.addAttribute("user", user);
        if (user.getRole() == User.Role.WORKER){
            Worker worker = workerRepository.findByUserId(user.getId()).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
            model.addAttribute("worker", worker);
        }

        return user.getRole() == User.Role.CLIENT
                ? "clientPages/edit-profile-client"
                : "workerPages/edit-profile-worker";
    }

    @PostMapping
    public String updateProfile(@ModelAttribute("user") User updatedUser,
                                @ModelAttribute("worker") Worker updatedWorker,
                                Authentication authentication) {
        User currentUser = (User) authentication.getPrincipal();


        currentUser.setName(updatedUser.getName());
        currentUser.setPhone(updatedUser.getPhone());
        currentUser.setEmail(updatedUser.getEmail());
        if (currentUser.getRole() == User.Role.WORKER){
            Worker worker = workerRepository.findByUserId(currentUser.getId()).
                    orElseThrow(() -> new ResponseStatusException(HttpStatus.FORBIDDEN, "Работник не найден"));
            worker.setSpecialization(updatedWorker.getSpecialization());
            workerRepository.save(worker);

        }

        userRepository.save(currentUser);

        return "redirect:/user-profile";
    }
}
