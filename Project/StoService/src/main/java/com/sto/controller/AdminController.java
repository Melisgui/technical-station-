package com.sto.controller;

import com.sto.model.Sto;
import com.sto.repository.StoRepository;
import com.sto.repository.UserRepository;
import com.sto.util.AESUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AdminController {
    private final StoRepository stoRepository;
    private final UserRepository userRepository;


    public AdminController(StoRepository stoRepository, UserRepository userRepository) {
        this.stoRepository = stoRepository;
        this.userRepository = userRepository;
    }
    @GetMapping("/admin")
    public String admin(Model model) {
        return "admin";
    }
    @PostMapping("/admin/sto/add")
    public String addSto(
            @RequestParam String name,
            @RequestParam String address,
            @RequestParam String workingHours,
            @RequestParam String verificationCode,
            RedirectAttributes redirectAttributes
    ) {
        try {

            String encryptedCode = AESUtils.encrypt(verificationCode);

            // Создаем и сохраняем СТО
            Sto sto = new Sto();
            sto.setName(name);
            sto.setAddress(address);
            sto.setWorkingHours(workingHours);
            sto.setVerificationCode(encryptedCode);
            sto.setRating(0.0);
            stoRepository.save(sto);

            redirectAttributes.addFlashAttribute("success", "СТО успешно добавлено!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Ошибка при шифровании кода");
        }
        return "redirect:/admin";
    }


}
