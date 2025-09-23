package com.sto.controller;

import com.sto.model.Client;
import com.sto.model.ClientReview;
import com.sto.model.Sto;
import com.sto.model.User;
import com.sto.repository.ClientRepository;
import com.sto.repository.ClientReviewRepository;
import com.sto.repository.StoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

@Controller
@RequiredArgsConstructor
public class ReviewController {
    private final ClientReviewRepository reviewRepository;
    private final ClientRepository clientRepository;
    private final StoRepository stoRepository;


    @PostMapping("/reviews/add")
    public String addReview(
            @RequestParam("stoName") String stoName,
            @RequestParam("rating") Integer rating,
            @RequestParam(value = "comment", required = false) String comment,
            Authentication authentication,
            RedirectAttributes redirectAttributes
    ) {
        try {
            Sto sto = stoRepository.findByName(stoName);

            User user = (User) authentication.getPrincipal();
            Client client = clientRepository.findByUserId(user.getId());

            ClientReview review = new ClientReview();
            review.setSto(sto);
            review.setClient(client);
            review.setRating(rating);
            review.setComment(comment);
            review.setCreatedAt(LocalDateTime.now());

            reviewRepository.save(review);

            updateStoRating(sto);
            stoRepository.save(sto);

            redirectAttributes.addFlashAttribute("success", "Отзыв успешно добавлен!");
        } catch (ResourceNotFoundException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Ошибка при сохранении отзыва");
        }

        return "redirect:/sto/" + URLEncoder.encode(stoName, StandardCharsets.UTF_8);
    }

    private void updateStoRating(Sto sto) {
        if (sto.getClientReviews() == null || sto.getClientReviews().isEmpty()) {
            sto.setRating(0.0);
            return;
        }

        double sum = sto.getClientReviews().stream()
                .mapToDouble(ClientReview::getRating)
                .sum();
        double average = sum / sto.getClientReviews().size();

        sto.setRating(Math.round(average * 10) / 10.0);
    }
    private String encodeStationName(Integer stoId) {
        return stoRepository.findById(stoId)
                .map(sto -> URLEncoder.encode(sto.getName(), StandardCharsets.UTF_8))
                .orElse("unknown");
    }
}