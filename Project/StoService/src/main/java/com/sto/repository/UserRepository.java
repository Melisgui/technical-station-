package com.sto.repository;

import com.sto.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByEmail(String email);
    public User findByName(String username);
    public User findByEmailAndPasswordHash(String email, String password);
    public User findByNameAndPasswordHash(String username, String password);
    public User findById(int id);
}
