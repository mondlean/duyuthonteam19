package com.duyouthon.login;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "user")
@Getter
@Setter
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;
    @Column(name = "name")
    private String name;
    @Column(name = "area")
    private String area;

    public User() {}

    public User(int id, String name, String area) {
        this.id = id;
        this.name = name;
        this.area = area;
    }
}
