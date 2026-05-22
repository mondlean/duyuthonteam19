package com.duyouthon.login;

import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User join(int id, String name,String area) {
        User user = new User();
        user.setId(id);
        user.setName(name);
        user.setArea(area);

        return userRepository.save(user);
    }
}
