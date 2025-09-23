package com.sto.repository;


import com.sto.model.Services;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ServicesRepository extends JpaRepository<Services, Integer> {
    List<Services> findByStoId(Integer stoId);
    public void findByName(String name);
}
