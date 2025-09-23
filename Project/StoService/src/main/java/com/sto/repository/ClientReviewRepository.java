package com.sto.repository;

import com.sto.model.ClientReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientReviewRepository extends JpaRepository<ClientReview, Integer> {

}
