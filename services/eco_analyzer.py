from data.eco_tags import ECO_TAGS

def analyze_items(items):

    analyzed_items = []

    total_point = 0

    for item in items:

        analyzed = {
            "name": item["name"],
            "price": item["price"],
            "category": "기타",
            "eco": False,
            "tags": [],
            "point": 0
        }

        for keyword, value in ECO_TAGS.items():

            if keyword in item["name"]:

                analyzed["category"] = value["category"]
                analyzed["eco"] = value["eco"]
                analyzed["tags"] = value["tags"]
                analyzed["point"] = value["point"]

                break

        total_point += analyzed["point"]

        analyzed_items.append(analyzed)

    return analyzed_items, total_point