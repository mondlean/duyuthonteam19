package com.duyouthon.user;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "users")
@Getter
@Setter
public class User {

    @Id
    @Column(name = "loginId")
    private String loginId;

    @Column(name = "password")
    private String password;

    @Column(name = "name")
    private String name;

    @Column(name = "userTag")
    private String userTag;

    @Column(name = "area")
    private String area;

    @Column(name = "city")
    private String city;

    public User() {}

    public User(String loginId, String password, String name, String userTag, String area, String city) {
        this.loginId = loginId;
        this.password = password;
        this.name = name;
        this.userTag = userTag;
        this.area = area;
        this.city = city;
    }
}
