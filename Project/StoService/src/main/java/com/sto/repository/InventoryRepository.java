package com.sto.repository;

import com.sto.model.Inventory;
import com.sto.model.InventoryId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, InventoryId> {
    List<Inventory> findByPartId(Integer partId);


    @Query("SELECT i FROM Inventory i JOIN FETCH i.sto WHERE i.part.id = :partId")
    List<Inventory> findWithStoByPartId(@Param("partId") Integer partId);


}
