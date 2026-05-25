package com.duyouthon.point;

import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.core.io.ByteArrayResource;
import java.util.Map;
import java.util.List;

@RestController
@RequestMapping("/point")
@CrossOrigin(origins = "*")
public class PointController {

    private final PointService pointService;
    private final RestTemplate restTemplate = new RestTemplate();

    public PointController(PointService pointService) {
        this.pointService = pointService;
    }

    @GetMapping("/total")
    public ResponseEntity<Integer> getTotalPoint(@RequestParam("loginId") String loginId) {
        try {
            int total = pointService.getTotalPoint(loginId);
            return ResponseEntity.ok(total);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(0);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(0);
        }
    }

    @PostMapping("/earn")
    public ResponseEntity<String> earnPoint(@RequestBody PointRequest request) {
        try {
            pointService.earnPoint(request.getLoginId(), request.getItem(),request.getCount());
            return ResponseEntity.ok("포인트 적립이 성공적으로 완료되었습니다!");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("서버 오류가 발생했습니다.");
        }
    }

    @PostMapping("/upload")
    public ResponseEntity<?> uploadReceipt(@RequestParam("file") MultipartFile file, @RequestParam("loginId") String loginId) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            ByteArrayResource fileAsResource = new ByteArrayResource(file.getBytes()) {
                @Override
                public String getFilename() {
                    return file.getOriginalFilename() != null ? file.getOriginalFilename() : "receipt.jpg";
                }
            };
            body.add("image", fileAsResource);

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity("http://localhost:8000/ocr", requestEntity, Map.class);
            Map<String, Object> result = response.getBody();

            if (result != null && Boolean.TRUE.equals(result.get("success"))) {
                List<Map<String, Object>> items = (List<Map<String, Object>>) result.get("items");
                if (items != null) {
                    for (Map<String, Object> item : items) {
                        String itemName = (String) item.get("name");
                        pointService.earnPoint(loginId, itemName, 1);
                    }
                }
                return ResponseEntity.ok(result);
            } else {
                return ResponseEntity.badRequest().body(result);
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Failed to process receipt: " + e.getMessage());
        }
    }
}
