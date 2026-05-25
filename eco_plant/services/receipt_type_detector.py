def detect_receipt_type(text: str):

    text = text.upper()

    # =========================
    # 카페 (Cafe)
    # =========================
    if any(kw in text for kw in ["STARBUCKS", "PAUL BASSETT", "BARISTA", "커피", "COFFEE"]):
        return "CAFE"

    # =========================
    # 편의점 (Convenience)
    # =========================
    if any(kw in text for kw in ["CU ", "GS25", "세븐일레븐", "7-ELEVEN", "EMART24"]):
        return "CONVENIENCE"
    
    if "총구매액" in text:
        return "CONVENIENCE"

    # =========================
    # 마트 (Market)
    # =========================
    # 마트 영수증의 특징: 면세, 과세, 농산물 등
    if any(kw in text for kw in ["상품명", "단가", "수량", "금액"]):
        if any(kw in text for kw in ["면세", "과세", "농축산물", "마트", "MART"]):
            return "MARKET"

    if "결제대상금액" in text or "판매원" in text:
        return "MARKET"

    # =========================
    # 음식점 (Restaurant)
    # =========================
    if any(kw in text for kw in ["합계금액", "주문번호", "테이블", "TABLE"]):
        return "RESTAURANT"

    # 백업: 키워드 빈도로 결정
    if "단가" in text and "수량" in text:
        return "MARKET"

    return "UNKNOWN"
