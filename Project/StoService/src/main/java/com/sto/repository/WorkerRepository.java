package com.sto.repository;

import com.sto.model.Worker;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface WorkerRepository extends JpaRepository<Worker, Integer> {
    @Query("SELECT w FROM Worker w JOIN FETCH w.users WHERE w.id = :userId")
    Optional<Worker> findByUserId(@Param("userId") Integer userId);
}
