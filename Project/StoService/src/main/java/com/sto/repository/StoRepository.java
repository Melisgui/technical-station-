package com.sto.repository;

import com.sto.model.Sto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface StoRepository extends JpaRepository<Sto,Integer> {
    Sto findByName(String name);

}
