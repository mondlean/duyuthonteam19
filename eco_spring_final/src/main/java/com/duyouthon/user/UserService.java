package com.duyouthon.user;

import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    public User join(String loginId, String password, String name,String area,String city,String plant) {

        Random random = new Random();
        int randomNumber = random.nextInt(10000);
        String made_userTag = String.format("%04d", randomNumber);

        User user = new User();
        user.setLoginId(loginId);
        user.setPassword(password);
        user.setName(name);
        user.setUserTag(made_userTag);
        user.setArea(area);
        user.setCity(city);
        user.setPoint(0);
        user.setPlant(plant);

        return userRepository.save(user);
    }

    public String login(String loginId, String password) {
        User user = userRepository.findById(loginId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 아이디입니다."));

        if (!user.getPassword().equals(password)) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        return "로그인에 성공하였습니다!";
    }
}
