def detect_receipt_type(text: str):

    text = text.upper()

    # =========================
    # 카페
    # =========================

    if "STARBUCKS" in text:
        return "CAFE"

    if "PAUL BASSETT" in text:
        return "CAFE"

    # =========================
    # 편의점
    # =========================

    if "총구매액" in text:
        return "CONVENIENCE"

    if "CU" in text:
        return "CONVENIENCE"

    if "GS25" in text:
        return "CONVENIENCE"

    # =========================
    # 마트
    # =========================

    if "상품명" in text and "단가 수량 금액" in text:
        return "MARKET"

    if "결제대상금액" in text:
        return "MARKET"

    # =========================
    # 음식점
    # =========================

    if "합계 금액" in text:
        return "RESTAURANT"

    return "UNKNOWN"