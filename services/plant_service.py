def get_plant_status(point: int):

    if point >= 1000:
        return "꽃"

    elif point >= 800:
        return "꽃봉오리"

    elif point >= 500:
        return "풀"

    else:
        return "새싹"