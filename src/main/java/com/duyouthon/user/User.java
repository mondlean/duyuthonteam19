package com.duyouthon.user;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "user")
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

    @Column(name = "point")
    private int point = 0;

    @Column(name = "plant")
    private String plant;

    public void addPoint(int amount) {
        this.point += amount;
    }

    public String getStatusByPoint() {
        if (this.point < 500) {
            return "새싹";
        } else if (this.point < 800) {
            return "풀";
        } else if (this.point < 1000) {
            return "꽃봉오리";
        } else {
            return "꽃";
        }
    }

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
