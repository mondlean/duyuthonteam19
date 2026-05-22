package com.duyouthon.login;


import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping ("/users")
    public String createUser(@RequestBody UserRequest request) {
        int id = request.getId();
        String name = request.getName();
        String area = request.getArea();

        userService.join(id, name, area);

        return "정상적으로 회원가입이 완료되었습니다 !";
    }
}
