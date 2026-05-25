package com.duyouthon.user;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRequest {

    private String loginId;
    private String password;
    private  String name;
    private String area;
    private String city;

}