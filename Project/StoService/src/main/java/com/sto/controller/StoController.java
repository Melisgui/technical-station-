package com.sto.controller;

import com.sto.dto.ReviewDto;
import com.sto.model.Sto;
import com.sto.repository.ClientRepository;
import com.sto.repository.ClientReviewRepository;
import com.sto.repository.StoRepository;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;


@Controller
public class StoController {
    private final StoRepository stoRepository;


    public StoController(StoRepository stoRepository) {
        this.stoRepository = stoRepository;

    }

    @GetMapping("/sto/{name}")
    public String serviceStationDetails(@PathVariable String name, Model model) {
//        System.out.println(name);
//        System.out.println(stoRepository.findByName(name));
        ReviewDto reviewDto = new ReviewDto();
        String decodedName = URLDecoder.decode(name, StandardCharsets.UTF_8);
        Sto station = stoRepository.findByName(decodedName);

        model.addAttribute("reviewDto", reviewDto);
        model.addAttribute("station", station);

        return "clientPages/sto";
    }
}
