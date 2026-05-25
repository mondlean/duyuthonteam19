import re
from services.receipt_type_detector import detect_receipt_type

EXCLUDE_WORDS = {
    "합계", "부가세", "카드", "승인번호", "와이파이", "쿠폰", "결제", "할인", "포인트", "잔액", "번호",
    "SSID", "과세", "면세", "상품명", "단가", "수량", "금액", "POS", "TEL", "현금영수증", "카드잔액",
    "승인금액", "교환", "환불", "매장", "대표", "사업자", "주문번호", "서울시", "영등포구", "IFC", 
    "사용안내", "가입", "승인정보", "이벤트", "쿠폰번호", "APP", "로그인", "총구매액", "총금액", 
    "면세물품", "과세물품", "받을금액", "거스름돈", "구매", "판매", "전화", "주소", "총", "물품", "가액",
    "공급가액", "매출", "현금", "거스름", "NAR", "ORUC", "VAT"
}


# =========================
# 메인 진입
# =========================

def parse_items(text):
    receipt_type = detect_receipt_type(text)
    print(f"[RECEIPT TYPE] {receipt_type}")
    items, total_price = parse_general(text)
    return items, total_price


# =========================
# 범용 파서 (모든 타입 대응 시도)
# =========================

def parse_general(text):
    lines = split_lines(text)
    items = []

    for i, line in enumerate(lines):
        if is_date_or_time(line): continue
        tokens = line.split()
        if not tokens: continue

        # 1. 단일 라인 패턴: [상품명] [기타숫자들...] [최종가격]
        if len(tokens) >= 2:
            last_token = tokens[-1]
            if is_price(last_token):
                price_val = normalize_price(last_token)
                
                # 상품명 후보 추출 (앞쪽 토큰들)
                # 중간에 있는 숫자들은 수량이나 단가일 확률이 높으므로 무시
                name_parts = []
                for t in tokens[:-1]:
                    if t.isdigit() or is_price(t): continue
                    name_parts.append(t)
                
                name_cand = " ".join(name_parts).strip()
                if is_valid_name(name_cand):
                    items.append({"name": clean_name(name_cand), "price": price_val})
                    continue

        # 2. 멀티라인 패턴 (현재 줄이 숫자/가격 뭉치이고, 위 줄이 이름인 경우)
        # 예: "상품명\n1,000 1 1,000"
        if all(re.match(r'^[\d,.\-]+$', t) for t in tokens) and i > 0:
            # 마지막 숫자를 가격으로 채택
            if is_price(tokens[-1]):
                price_val = normalize_price(tokens[-1])
                # 위로 2줄까지 이름 탐색
                for offset in [1, 2]:
                    if i - offset < 0: break
                    prev_line = lines[i - offset]
                    if is_valid_name(prev_line) and not any(is_price(t) for t in prev_line.split()):
                        items.append({"name": clean_name(prev_line), "price": price_val})
                        break

    items = deduplicate(items)
    total_price = find_best_total_price(lines, items)
    return items, total_price


# =========================
# 유효성 검사 도구들
# =========================

def is_valid_name(name):
    if not name: return False
    clean_n = name.replace(" ", "").upper()
    if len(clean_n) < 2: return False
    
    # 제외 키워드 체크
    for word in EXCLUDE_WORDS:
        if word.upper() in clean_n: return False
    
    # 숫자로만 되어 있거나 특수문자만 있으면 제외
    if clean_n.isdigit(): return False
    if not re.search(r'[가-힣A-Z]', clean_n): return False
    
    # 너무 긴 이름은 무시
    if len(name) > 40: return False
    
    return True

def is_price(text):
    if text.count('.') >= 2 or text.count('-') >= 2: return False
    cleaned = text.replace(",", "").replace(".", "").replace("-", "").strip()
    if not cleaned.isdigit(): return False
    val = int(cleaned)
    # 최소 100원 이상, 최대 100만원 이하 (현실적인 범위)
    return 100 <= val <= 1000000

def normalize_price(text):
    cleaned = text.replace(",", "").replace(".", "").replace("-", "").strip()
    return int(cleaned)

def is_date_or_time(text):
    patterns = [r'\d{4}-\d{2}-\d{2}', r'\d{2}/\d{2}/\d{2}', r'\d{2}:\d{2}:\d{2}', r'\d{2}-\d{2}-\d{2}']
    return any(re.search(p, text) for p in patterns)

def clean_name(name):
    # 특수문자 및 불필요한 번호 정리
    name = re.sub(r'^\d+[\.\s]*', '', name)
    name = re.sub(r'[\*\•\#\[\]\(\)\:]', '', name)
    return name.strip()


# =========================
# 총 금액 추출 (통합 개선형)
# =========================

def find_best_total_price(lines, items=None):
    # 키워드 우선순위
    PRIORITY_KEYWORDS = [
        ["합계", "총계", "TOTAL", "받을금액", "결제금액", "총액"],
        ["결제", "승인금액", "금액"]
    ]
    
    item_sum = sum(item['price'] for item in items) if items else 0

    # 1. 품목 합계와 일치하는 숫자 찾기 (가장 정확)
    if item_sum > 0:
        for line in reversed(lines):
            if any(kw in line for kw in ["가액", "과세", "면세"]): continue
            for m in re.findall(r'([\d,.]+)', line):
                if is_price(m) and normalize_price(m) == item_sum:
                    return item_sum

    # 2. 우선순위 키워드별 탐색 (영수증 하단부터)
    for kw_list in PRIORITY_KEYWORDS:
        for i in range(len(lines) - 1, -1, -1):
            line = lines[i]
            if any(kw in line.replace(" ", "") for kw in kw_list):
                if "가액" in line: continue
                
                # 같은 줄 혹은 다음 3줄 탐색
                for j in range(i, min(i + 4, len(lines))):
                    matches = re.findall(r'([\d,.]+)', lines[j])
                    for m in reversed(matches):
                        if is_price(m):
                            val = normalize_price(m)
                            if 2024 <= val <= 2030: continue
                            # 품목 합계가 있다면 너무 차이나는 값(50% 미만 등)은 지양
                            if item_sum > 0 and val < item_sum * 0.7: continue
                            return val

    # 3. 마지막 수단: 가장 큰 현실적 숫자 또는 품목 합계
    all_prices = []
    for line in lines:
        if is_date_or_time(line): continue
        if any(kw in line for kw in ["가액", "과세", "면세"]): continue
        for m in re.findall(r'([\d,.]+)', line):
            if is_price(m):
                val = normalize_price(m)
                if not (2024 <= val <= 2030): all_prices.append(val)
    
    if all_prices:
        valid = [p for p in all_prices if 100 <= p <= 1000000]
        if valid:
            max_p = max(valid)
            # 만약 품목 합계가 0보다 크면, 둘 중 큰 값을 선호
            return max(max_p, item_sum)
            
    return item_sum


# =========================
# 유틸리티
# =========================

def split_lines(text):
    return [l.strip() for l in text.split("\n") if l.strip()]

def deduplicate(items):
    seen = set()
    result = []
    for item in items:
        key = (item["name"], item["price"])
        if key not in seen:
            seen.add(key)
            result.append(item)
    return result
