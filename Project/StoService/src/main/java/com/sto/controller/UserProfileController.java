package com.sto.controller;

import com.sto.model.Client;
import com.sto.model.User;
import com.sto.repository.ClientRepository;
import com.sto.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user-profile")
public class UserProfileController {

    private final UserRepository userRepository;
    private final ClientRepository clientRepository;

    @Autowired
    public UserProfileController(UserRepository userRepository, ClientRepository clientRepository) {
        this.userRepository = userRepository;
        this.clientRepository = clientRepository;
    }

    @GetMapping
    public String showProfile(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        if (user.getClient() == null) {
            Client client = new Client();
            client.setUser(user);
            user.setClient(client);
            clientRepository.save(client);
        }

        model.addAttribute("user", user);
        return "profile";
    }
}