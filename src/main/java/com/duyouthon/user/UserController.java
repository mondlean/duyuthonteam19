package com.duyouthon.user;


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
        String loginId = request.getLoginId();
        String password = request.getPassword();
        String name = request.getName();
        String area = request.getArea();
        String city = request.getCity();

        userService.join(loginId,password,name,area,city);

        return "정상적으로 회원가입이 완료되었습니다 !";
    }

    @PostMapping("/login")
    public String loginUser(@RequestBody LoginRequest request) {
        try {
            return userService.login(request.getLoginId(), request.getPassword());
        } catch (IllegalArgumentException e) {
            return e.getMessage();
        }
    }

}
