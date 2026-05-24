import os

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "vision-key.json"

from fastapi import FastAPI, UploadFile, File
from google.cloud import vision
from services.item_parser import parse_items
from services.eco_analyzer import analyze_items
from services.plant_service import get_plant_status
from models.receipts import OCRResponse

app = FastAPI()

@app.post("/ocr", response_model=OCRResponse)
async def ocr_image(file: UploadFile = File(...)):
    content = await file.read()
    client = vision.ImageAnnotatorClient()
    image = vision.Image(content=content)
    response = client.text_detection(image=image)
    texts = response.text_annotations
    if not texts:
        return {
            "success": False,
            "items": [],
            "total_price": 0,
            "total_point": 0,
            "plant_status": "새싹"
        }
    extracted_text = texts[0].description
    items, total_price = parse_items(extracted_text)
    analyzed_items, total_point = analyze_items(items)
    plant_status = get_plant_status(total_point)
    
    if isinstance(total_price, str):
        total_price = int(total_price.replace(",", ""))
    elif total_price is None:
        total_price = 0
    return {
        "success": True,
        "items": analyzed_items,
        "total_price": total_price,
        "total_point": total_point,
        "plant_status": plant_status
    }

from database.database import engine
from database.models import Base

Base.metadata.create_all(bind=engine)