package com.duyouthon.point;

import com.duyouthon.user.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "point")
@Getter
@Setter
public class Point {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_loginId(fk)")
    private User user;

    @Column(name = "item")
    private String item;

    @Column(name = "point")
    private int point;

    @Column(name = "time")
    private LocalDateTime time = LocalDateTime.now();
}
