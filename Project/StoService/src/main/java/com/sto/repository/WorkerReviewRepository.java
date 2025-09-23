package com.sto.repository;

import com.sto.model.Worker;
import com.sto.model.WorkerReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WorkerReviewRepository extends JpaRepository<WorkerReview, Integer> {
    List<WorkerReview> findByWorker(Worker worker);


}
