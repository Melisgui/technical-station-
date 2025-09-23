package com.sto.repository;

import com.sto.model.SparePart;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SparePartRepository extends JpaRepository<SparePart,Integer> {

    Optional<SparePart> findSparePartByName(@Size(max = 100) @NotNull String name);
}
