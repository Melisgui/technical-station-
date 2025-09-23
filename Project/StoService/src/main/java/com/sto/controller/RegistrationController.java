package com.sto.controller;

import com.sto.model.Client;
import com.sto.model.Sto;
import com.sto.model.Worker;
import com.sto.repository.ClientRepository;
import com.sto.repository.StoRepository;
import com.sto.repository.WorkerRepository;
import com.sto.util.AESUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.sto.model.User;
import com.sto.repository.UserRepository;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/register")
public class RegistrationController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final WorkerRepository workerRepository;
    private final StoRepository stoRepository;
    private final ClientRepository clientRepository;

    @Autowired
    public RegistrationController(UserRepository userRepository,
                                  PasswordEncoder passwordEncoder,
                                  WorkerRepository workerRepository,
                                  StoRepository stoRepository,
                                  ClientRepository clientRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.workerRepository = workerRepository;
        this.stoRepository = stoRepository;
        this.clientRepository = clientRepository;
    }

    @GetMapping
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping
    public String registerUser(
            @ModelAttribute("user") User user,
            @RequestParam(value = "specialization", required = false) String specialization,
            @RequestParam(value = "experienceYears", required = false) Integer experienceYears,
            @RequestParam(value = "verificationCode", required = false) String verificationCode,
            RedirectAttributes redirectAttributes) {

        System.out.println(user.getEmail());
        System.out.println(user.getPassword());
        System.out.println(user.getRawPassword());
        try {
            user.setPasswordHash(passwordEncoder.encode(user.getRawPassword()));
            User savedUser = userRepository.save(user);


            if (user.getRole() == User.Role.WORKER) {
                if (verificationCode == null || verificationCode.isEmpty()) {
                    throw new IllegalArgumentException("Код подтверждения обязателен для работников");
                }
                //migrateEncryption();
                Optional<Sto> sto = stoRepository.findAll().stream()
                        .filter(s -> {
                            try {
                                String decrypted = AESUtils.decrypt(s.getVerificationCode());
                                System.out.println(decrypted);
                                return decrypted.equals(verificationCode);
                            } catch (Exception e) {
                                return false;
                            }
                        })
                        .findFirst();

                if (sto.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Неверный код подтверждения");
                    return "redirect:/register";
                }

                Worker worker = new Worker();
                worker.setUsers(savedUser);
                worker.setSpecialization(specialization);
                worker.setExperienceYears(experienceYears);
                worker.setSto(sto.get());

                workerRepository.save(worker);
            } else {
                Client client = new Client();
                client.setUser(savedUser);
                clientRepository.save(client);
            }

            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }

    }
//    public void migrateEncryption() {
//        List<Sto> allStos = stoRepository.findAll();
//
//        for (Sto sto : allStos) {
//            try {
//                String newCode = AESUtils.encrypt(sto.getVerificationCode());
//
//                sto.setVerificationCode(newCode);
//                stoRepository.save(sto);
//            } catch (Exception e) {
//                throw new RuntimeException("Ошибка" + sto.getId(), e);
//            }
//        }
//    }
}
