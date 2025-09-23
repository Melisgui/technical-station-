package com.sto.controller;

import com.sto.model.User;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RedirectController {

    @GetMapping("/redirect")
    public String redirectAfterLogin(Authentication authentication) {
        User user = (User) authentication.getPrincipal();

        return user.getRole() == User.Role.CLIENT
                ? "redirect:/home-client"
                : "redirect:/home-worker";
    }
}
