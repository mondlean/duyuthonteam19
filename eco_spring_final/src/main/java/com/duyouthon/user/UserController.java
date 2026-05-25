package com.duyouthon.user;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping ("/register")
    public String createUser(@RequestBody UserRequest request) {
        String loginId = request.getLoginId();
        String password = request.getPassword();
        String name = request.getName();
        String area = request.getArea();
        String city = request.getCity();
        String plant = request.getPlant();
        userService.join(loginId,password,name,area,city,plant);

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

    @GetMapping("/{loginId}")
    public User getUser(@PathVariable String loginId) {
        return userService.getUser(loginId);
    }

    @PostMapping("/update-plant")
    public String updatePlant(@RequestBody UserRequest request) {
        userService.updatePlant(request.getLoginId(), request.getPlant());
        return "식물 선택이 완료되었습니다.";
    }

}
