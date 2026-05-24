import re

def parse_items(extracted_text):

    lines = extracted_text.split("\\n")

    items = []
    total_price = None

    for i in range(len(lines)):

        line = lines[i].strip()

        # 총구매액 찾기
        if "총구매액" in line:

            for j in range(i + 1, min(i + 4, len(lines))):

                price_match = re.search(r'\\d{1,3}(,\\d{3})*', lines[j])

                if price_match:
                    total_price = price_match.group()
                    break

        # 상품 + 가격 찾기
        if re.search(r'[가-힣a-zA-Z]', line):

            if i + 2 < len(lines):

                quantity = lines[i + 1].strip()
                price = lines[i + 2].strip()

                if quantity.isdigit() and re.match(r'\\d{1,3}(,\\d{3})*', price):

                    items.append({
                        "name": line,
                        "price": int(price.replace(",", ""))
                    })

    return items, total_price