import os

from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware

from google.cloud import vision

from services.item_parser import parse_items
from services.eco_analyzer import analyze_items
from services.plant_service import get_plant_status
from services.ocr_service import extract_text_with_layout


# =========================
# Google Vision API Key
# =========================

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "vision-key.json"


# =========================
# FastAPI App
# =========================

app = FastAPI()


# =========================
# CORS 설정
# Flutter / Spring 연결용
# =========================

app.add_middleware(
    CORSMiddleware,

    allow_origins=["*"],

    allow_credentials=True,

    allow_methods=["*"],

    allow_headers=["*"],
)


# =========================
# Root API
# =========================

@app.get("/")
def root():

    return {
        "message": "Eco AI Server Running"
    }


# =========================
# OCR API
# =========================

@app.post("/ocr")
async def ocr_image(
    image: UploadFile = File(...)
):

    try:

        # =========================
        # 이미지 읽기
        # =========================

        content = await image.read()

        # =========================
        # Google Vision OCR
        # =========================

        extracted_text = extract_text_with_layout(content)

        # =========================
        # OCR 실패
        # =========================

        if not extracted_text:

            return {
                "success": False,
                "message": "텍스트를 찾을 수 없습니다.",

                "items": [],

                "total_price": 0,
                "total_point": 0,

                "plant_status": "새싹"
            }

        # =========================
        # OCR 원문
        # =========================

        print()
        print("========== OCR TEXT ==========")
        print(extracted_text)
        print("==============================")
        print()

        # =========================
        # 상품 추출
        # =========================

        items, total_price = parse_items(
            extracted_text
        )

        print()
        print("========== PARSED ITEMS ==========")
        print(items)
        print("==================================")
        print()

        # =========================
        # 친환경 분석
        # =========================

        analyzed_items, total_point = analyze_items(
            items
        )

        print()
        print("========== ANALYZED ITEMS ==========")
        print(analyzed_items)
        print("====================================")
        print()

        # =========================
        # 식물 상태 계산
        # =========================

        plant_status = get_plant_status(
            total_point
        )

        # =========================
        # 최종 응답
        # =========================

        return {

            "success": True,

            "items": analyzed_items,

            "total_price": total_price,

            "total_point": total_point,

            "plant_status": plant_status
        }

    except Exception as e:

        print()
        print("========== ERROR ==========")
        print(str(e))
        print("===========================")
        print()

        return {

            "success": False,

            "message": str(e),

            "items": [],

            "total_price": 0,

            "total_point": 0,

            "plant_status": "새싹"
        }