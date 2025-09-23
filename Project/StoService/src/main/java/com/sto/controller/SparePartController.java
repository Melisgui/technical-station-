package com.sto.controller;

import com.sto.model.*;
import com.sto.repository.InventoryRepository;
import com.sto.repository.SparePartRepository;
import com.sto.repository.WorkerRepository;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SparePartController {
    private final SparePartRepository sparePartRepository;
    private final WorkerRepository workerRepository;
    private final InventoryRepository inventoryRepository;

    public SparePartController(SparePartRepository sparePartRepository, WorkerRepository workerRepository, InventoryRepository inventoryRepository) {
        this.sparePartRepository = sparePartRepository;
        this.workerRepository = workerRepository;
        this.inventoryRepository = inventoryRepository;
    }
    @PostMapping("/sparePartAdd")
    public String addSparePart(@RequestParam String name,
                               @RequestParam String category,
                               @RequestParam Integer quantity,
                               Authentication authentication) {
        User user = (User) authentication.getPrincipal();

        Worker worker = workerRepository.findByUserId(user.getId()).orElseThrow(() -> new RuntimeException("Worker not found"));



        // ==null
        SparePart sparePart = sparePartRepository.findSparePartByName(name)
                .orElseGet(() -> {
                    SparePart sparePart1 = new SparePart();
                    sparePart1.setName(name);
                    sparePart1.setCategory(category);
                    return sparePartRepository.save(sparePart1);
                });

        InventoryId inventoryId = new InventoryId(worker.getSto().getId(), sparePart.getId());
        Inventory inv = inventoryRepository.findById(inventoryId)
                .orElseGet(() -> {
                    Inventory inventory1 = new Inventory();
                    inventory1.setId(inventoryId);
                    inventory1.setQuantity(0);
                    inventory1.setSto(worker.getSto());
                    inventory1.setPart(sparePart);
                    return inventory1;
                });


        inv.setQuantity(quantity + inv.getQuantity());

        inventoryRepository.save(inv);


        return "redirect:/home-worker";
    }
}
