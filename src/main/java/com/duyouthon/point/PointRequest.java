package com.duyouthon.point;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PointRequest {
    private String loginId;
    private String item;
    private int count;
}