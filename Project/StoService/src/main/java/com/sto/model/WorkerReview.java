package com.sto.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "worker_reviews", schema = "public")
public class WorkerReview {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id", nullable = false)
    private Integer id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "worker_id", nullable = false)
    private Worker worker;

    @NotNull
    @Column(name="service_name")
    private String serviceName;


    @ManyToOne
    @JoinColumn(name = "appointment_id")
    private Appointment appointment;

    @Size(max = 50)
    @Column(name = "hours_for_complete", length = 50)
    private String hoursForComplete;

    @Column(name = "comment", length = Integer.MAX_VALUE)
    private String comment;

    @Size(max = 50)
    @Column(name = "auto_model", length = 50)
    private String autoModel;

    @Column(name = "created_at",columnDefinition = "timestamp")
    private LocalDateTime createdAt;


/*
 TODO [Reverse Engineering] create field to map the 'service_name' column
 Available actions: Define target Java type | Uncomment as is | Remove column mapping
    @Column(name = "service_name", columnDefinition = "service_name_enum")
    private Object serviceName;
*/
}