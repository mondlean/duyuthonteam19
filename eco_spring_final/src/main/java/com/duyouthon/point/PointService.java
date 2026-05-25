package com.duyouthon.point;

import com.duyouthon.user.User;
import com.duyouthon.user.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class PointService {

    private final PointRepository pointRepository;
    private final UserRepository userRepository;

    public PointService(PointRepository pointRepository, UserRepository userRepository) {
        this.pointRepository = pointRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public void earnPoint(String loginId, String item, int count) {
        User user = userRepository.findById(loginId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저입니다."));

        //알파벳에는 친환경 제품 데이터 이름을 텍스트 형식으로 넣으면 되고
        //point도 조정할 수 있습니다
        int basePoint = 10;
        if (item.contains("a")) {
            basePoint = 50;
        } else if (item.contains("b")) {
            basePoint = 80;
        } else if (item.contains("c") || item.contains("d")) {
            basePoint = 100;
        }

        int finalPoint = basePoint * count;

        Point pointData = new Point();
        pointData.setUser(user);
        pointData.setItem(item);
        pointData.setPoint(finalPoint);
        pointRepository.save(pointData);

        user.addPoint(finalPoint);
    }
}