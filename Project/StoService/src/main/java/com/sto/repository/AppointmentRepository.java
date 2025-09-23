package com.sto.repository;

import com.sto.model.Appointment;
import com.sto.model.Sto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Integer> {
    boolean existsByDateTimeAndSto(LocalDateTime dateTime, Sto sto);
    @Query("SELECT a FROM Appointment a JOIN FETCH a.client WHERE a.sto.id = :stoId AND a.worker_id IS NULL AND a.status = 'pending'")
    List<Appointment> findNewAppointmentsBySto(@Param("stoId") Integer stoId);

    @Query("SELECT a FROM Appointment a JOIN FETCH a.client WHERE a.sto.id = :stoId AND a.worker_id = :workerId")
    List<Appointment> findWorkerAppointments(@Param("stoId") Integer stoId,
                                             @Param("workerId") Integer workerId);
    @Query("SELECT a from Appointment a JOIN FETCH a.client WHERE a.status = :status AND a.worker_id = :workerId")
    List<Appointment> findByStatusAndWorker_id(@Param("status") String status,
                                               @Param("workerId") Integer workerId);


}
