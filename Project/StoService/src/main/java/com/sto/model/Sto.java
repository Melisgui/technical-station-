package com.sto.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "sto", schema = "public")
public class Sto {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Size(max = 100)
    @NotNull
    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @NotNull
    @Column(name = "address", nullable = false, length = Integer.MAX_VALUE)
    private String address;

    @ColumnDefault("0.0")
    @Column(name = "rating")
    private Double rating;

    @Column(name = "working_hours", length = Integer.MAX_VALUE)
    private String workingHours;

    @NotNull
    @Column(name = "verification_code", nullable = false, length = 2000)
    private String verificationCode;

    @OneToMany(mappedBy = "sto")
    private Set<Appointment> appointments = new LinkedHashSet<>();

    @OneToMany(mappedBy = "sto")
    private Set<ClientReview> clientReviews = new LinkedHashSet<>();

    @OneToMany(mappedBy = "sto")
    private Set<Inventory> inventories = new LinkedHashSet<>();

    @OneToMany(mappedBy = "sto")
    private Set<Services> services = new LinkedHashSet<>();

    @OneToMany(mappedBy = "sto")
    private Set<Worker> workers = new LinkedHashSet<>();

}