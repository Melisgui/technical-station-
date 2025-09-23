package com.sto.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "client")
public class Client {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "user_id", nullable = false)
    private Integer id;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Size(max = 20)
    @Column(name = "car_brand", length = 20)
    private String carBrand;

    @Size(max = 40)
    @Column(name = "car_model", length = 40)
    private String carModel;

    @Column(name = "car_year")
    private Integer carYear;

    @OneToMany(mappedBy = "client")
    private Set<Appointment> appointments = new LinkedHashSet<>();

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    private Set<Car> cars = new LinkedHashSet<>();

    @OneToMany(mappedBy = "client")
    private Set<ClientReview> clientReviews = new LinkedHashSet<>();

}