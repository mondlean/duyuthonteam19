import re

from services.receipt_type_detector import detect_receipt_type


# =========================
# 제외 키워드
# =========================

EXCLUDE_WORDS = {

    "합계",
    "부가세",
    "카드",
    "승인번호",
    "와이파이",
    "쿠폰",
    "결제",
    "할인",
    "포인트",
    "잔액",
    "번호",
    "SSID",
    "과세",
    "면세",
    "상품명",
    "단가",
    "수량",
    "금액",
    "POS",
    "TEL",
    "현금영수증",
    "카드잔액",
    "승인금액",
    "교환",
    "환불",
    "매장",
    "대표",
    "사업자",
    "주문번호",
    "서울시",
    "영등포구",
    "대표",
    "IFC",
    "와이파이",
    "사용안내",
    "가입",
    "승인정보",
    "이벤트",
    "쿠폰번호",
    "APP",
    "로그인"
}


# =========================
# 메인 진입
# =========================

def parse_items(text):

    receipt_type = detect_receipt_type(text)

    print(f"[RECEIPT TYPE] {receipt_type}")

    parsers = {

        "CONVENIENCE": parse_convenience,

        "CAFE": parse_cafe,

        "MARKET": parse_market,

        "RESTAURANT": parse_restaurant
    }

    parser = parsers.get(receipt_type)

    if not parser:
        return [], 0

    return parser(text)


# =========================
# 편의점
# =========================

def parse_convenience(text):

    lines = split_lines(text)

    items = []

    for i in range(len(lines) - 2):

        name = lines[i]

        quantity = lines[i + 1]

        price = lines[i + 2]

        if not quantity.isdigit():
            continue

        if not is_price(price):
            continue

        if not is_valid_name(name):
            continue

        items.append({
            "name": clean_name(name),
            "price": normalize_price(price)
        })

    total_price = extract_total_price(lines)

    return deduplicate(items), total_price


# =========================
# 카페
# =========================

def parse_cafe(text):

    lines = split_lines(text)

    items = []

    used_names = set()

    for i in range(len(lines)):

        current = lines[i]

        # =========================
        # 가격 패턴 찾기
        # =========================

        if not is_price(current):
            continue

        price = normalize_price(current)

        # 너무 작은 가격 제외
        if price < 100:
            continue

        # =========================
        # 위쪽에서 상품명 탐색
        # =========================

        name = None

        for j in range(i - 1, max(i - 6, -1), -1):

            candidate = lines[j]

            if is_product_candidate(candidate):

                # 수량/할인/금액 제외
                if candidate in ["수량", "할인", "금액"]:
                    continue

                name = candidate
                break

        if not name:
            continue

        cleaned = clean_name(name)

        # 중복 제거
        if cleaned in used_names:
            continue

        used_names.add(cleaned)

        items.append({

            "name": cleaned,

            "price": price
        })

    total_price = extract_total_price(lines)

    return deduplicate(items), total_price


# =========================
# 마트
# =========================

def parse_market(text):

    lines = split_lines(text)

    items = []

    used_names = set()

    for i in range(len(lines)):

        line = lines[i]

        # 단가 수량 금액 패턴
        match = re.search(

            r'(\d{1,3}([,.]\d{3})*)\s+\d+\s+(\d{1,3}([,.]\d{3})*)',

            line
        )

        if not match:
            continue

        final_price = match.group(3)

        name = find_product_name(lines, i)

        if not name:
            continue

        cleaned = clean_name(name)

        if cleaned in used_names:
            continue

        used_names.add(cleaned)

        items.append({
            "name": cleaned,
            "price": normalize_price(final_price)
        })

    total_price = extract_total_price(lines)

    return deduplicate(items), total_price


# =========================
# 음식점
# =========================

def parse_restaurant(text):

    lines = split_lines(text)

    items = []

    for i in range(len(lines) - 3):

        name = lines[i]

        price = lines[i + 3]

        if not is_price(price):
            continue

        if not is_valid_name(name):
            continue

        items.append({
            "name": clean_name(name),
            "price": normalize_price(price)
        })

    total_price = extract_total_price(lines)

    return deduplicate(items), total_price


# =========================
# 상품명 탐색
# =========================

def find_product_name(lines, index):

    for j in range(index - 1, max(index - 6, -1), -1):

        candidate = lines[j]

        if is_valid_name(candidate):
            return candidate

    return None


# =========================
# 총 금액 추출
# =========================

def extract_total_price(lines):

    KEYWORDS = [

        "결제대상금액",
        "합계",
        "총구매액",
        "결제금액"
    ]

    for i in range(len(lines)):

        line = lines[i]

        if any(keyword in line for keyword in KEYWORDS):

            # 현재 줄에서 가격 찾기
            match = re.search(
                r'(\d{1,3}([,.]\d{3})*)',
                line
            )

            if match:
                return normalize_price(match.group(1))

            # 아래 줄 탐색
            for j in range(i + 1, min(i + 4, len(lines))):

                candidate = lines[j]

                if is_price(candidate):
                    return normalize_price(candidate)

    return 0


# =========================
# 유효 상품명 검사
# =========================

def is_valid_name(name):

    if len(name.strip()) < 2:
        return False

    if not re.search(r'[가-힣a-zA-Z]', name):
        return False

    if any(word in name for word in EXCLUDE_WORDS):
        return False

    return True


# =========================
# 가격 판별
# =========================

def is_price(text):

    text = (
        text
        .replace(",", "")
        .replace(".", "")
        .strip()
    )

    if not text.isdigit():
        return False

    value = int(text)

    # 너무 작은 숫자 제외
    if value < 100:
        return False

    # 너무 큰 숫자 제외
    if value > 1000000:
        return False

    return True


# =========================
# 가격 정규화
# =========================

def normalize_price(price_text):

    cleaned = (
        price_text
        .replace(",", "")
        .replace(".", "")
        .strip()
    )

    return int(cleaned)


# =========================
# 이름 정리
# =========================

def clean_name(name):

    name = re.sub(r'^\d+\.*', '', name)

    name = re.sub(r'[\*\•\#\[\]\(\)]', '', name)

    name = re.sub(r'\s+', ' ', name)

    return name.strip()


# =========================
# 줄 정리
# =========================

def split_lines(text):

    return [

        line.strip()

        for line in text.split("\n")

        if line.strip()
    ]


# =========================
# 중복 제거
# =========================

def deduplicate(items):

    seen = set()

    result = []

    for item in items:

        key = (
            item["name"],
            item["price"]
        )

        if key in seen:
            continue

        seen.add(key)

        result.append(item)

    return result

def is_product_candidate(text):

    text = text.strip()

    # 길이 제한
    if len(text) < 2:
        return False

    # 숫자 비율 너무 높으면 제외
    digit_ratio = (
        sum(c.isdigit() for c in text)
        / len(text)
    )

    if digit_ratio > 0.4:
        return False

    # 한글/영문 포함 여부
    if not re.search(r'[가-힣a-zA-Z]', text):
        return False

    # 주소 패턴 제외
    ADDRESS_KEYWORDS = [
        "로",
        "길",
        "동",
        "시",
        "구"
    ]

    # 제외 패턴
    INVALID_PATTERNS = [

        "주문번호",
        "대표",
        "사용안내",
        "와이파이",
        "이벤트",
        "쿠폰",
        "로그인",
        "APP",
        "승인",
        "카드",
        "영수증",
        "부가세",
        "합계",
        "결제금액",
        "서울시",
        "영등포구",
        "IFC",
        "KIOSK",
        "Wi-Fi",
        "www",
        "http"
    ]

    if any(pattern in text for pattern in INVALID_PATTERNS):
        return False

    # 전화번호 제외
    if re.search(r'\d{2,4}-\d{3,4}', text):
        return False

    if any(keyword in text for keyword in ADDRESS_KEYWORDS):

        # 근데 상품명에도 들어갈 수 있으니
        # 너무 짧을 때만 제외
        if len(text) > 10:
            return False

    # 상품명은 보통 문자 포함
    if not re.search(r'[가-힣a-zA-Z]', text):
        return False

    # 전화번호 패턴 제외
    if re.search(r'\d{2,4}-\d{3,4}', text):
        return False

    return True