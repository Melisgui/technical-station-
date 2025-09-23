package com.sto.controller;


import com.sto.model.Inventory;
import com.sto.model.SparePart;
import com.sto.repository.ClientRepository;
import com.sto.repository.InventoryRepository;
import com.sto.repository.SparePartRepository;
import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Controller
public class ClientSparePartsController {
    private final SparePartRepository sparePartRepository;
    private final InventoryRepository inventoryRepository;

    public ClientSparePartsController(SparePartRepository sparePartRepository, InventoryRepository inventoryRepository) {
        this.sparePartRepository = sparePartRepository;
        this.inventoryRepository = inventoryRepository;
    }
    @GetMapping("/spare-parts/{id}")
    public String sparePartDetails(@PathVariable Integer id, Model model) {

        SparePart part = sparePartRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Запчасть не найдена"));

        List<Inventory> inventories = inventoryRepository.findByPartId(id);

        model.addAttribute("part", part);
        model.addAttribute("inventories", inventories);
        return "clientPages/spare-parts-details";
    }

    @GetMapping("/spare-parts")
    public String sparePart(Model model) {
        List<SparePart> parts = sparePartRepository.findAll();
        model.addAttribute("parts", parts);
        return "clientPages/spare-parts";
    }
}
