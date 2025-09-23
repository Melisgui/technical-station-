package com.sto.repository;

import com.sto.model.Car;
import jakarta.validation.constraints.Size;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CarRepository extends JpaRepository<Car, String> {
    public List<Car> findByClientId(Integer client_id);

    boolean existsByVin(@Size(max = 17) String vin);
}