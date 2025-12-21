from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import JSONResponse
import os
import shutil
import torch
import torch.nn as nn
from PIL import Image
from torchvision import transforms, models
from typing import Dict

app = FastAPI()

# Predefined information for banana ripeness stages
banana_info = {
    "unripe": {
        "Characteristics": "Firm stem, green color, low glycemic index (GI) (~30).",
        "Nutrition": {
            "Calories (kcal)": (80, 90),
            "Carbohydrate (g)": (18, 22),
            "Sugar (g)": (10, 13),
            "Fiber (g)": (4, 6),
            "Potassium (mg)": (360, 400),
            "Vitamin B6 (% DV)": ("20%", "25%"),
            "Vitamin C (% DV)": (8, 12),
            "Resistant starch (g)": (2, 5),
            "Antioxidants": "Low"
        },
        "Benefits": "High resistant starch, low sugar, good for blood sugar control and digestion.",
        "Limitations": "Low sweetness, may cause indigestion if eaten in large amounts."
    },
    "fresh unripe": {
        "Characteristics": "Soft stem, green color, low glycemic index (GI) (~30).",
        "Nutrition": {
            "Calories (kcal)": (80, 90),
            "Carbohydrate (g)": (15, 20),
            "Sugar (g)": (2, 4),
            "Fiber (g)": (15, 20),
            "Potassium (mg)": (350, 420),
            "Vitamin B6 (% DV)": (20, 25),
            "Vitamin C (% DV)": (8, 12),
            "Resistant starch (g)": (15, 18),
            "Antioxidants": "Low"
        },
        "Benefits": "High resistant starch, low sugar, low GI, good for blood sugar, supports digestion.",
        "Limitations": "May cause bloating if eaten in large amounts."
    },
    "fresh ripe": {
        "Characteristics": "Soft stem, yellow color, moderate GI (~48-54).",
        "Nutrition": {
            "Calories (kcal)": (90, 100),
            "Carbohydrate (g)": (20, 22),
            "Sugar (g)": (13, 15),
            "Fiber (g)": (3, 5),
            "Potassium (mg)": (350, 380),
            "Vitamin B6 (% DV)": (25, 30),
            "Vitamin C (% DV)": (10, 12),
            "Resistant starch (g)": (1, 3),
            "Antioxidants": "Moderate"
        },
        "Benefits": "Provides quick energy, moderate GI, good for heart health due to potassium and fiber.",
        "Limitations": "Higher sugar, caution needed for diabetics."
    },
    "ripe": {
        "Characteristics": "Soft stem, dark yellow color, GI ~60.",
        "Nutrition": {
            "Calories (kcal)": (90, 100),
            "Carbohydrate (g)": (20, 22),
            "Sugar (g)": (14, 16),
            "Fiber (g)": (3, 5),
            "Potassium (mg)": (350, 380),
            "Vitamin B6 (% DV)": (25, 30),
            "Vitamin C (% DV)": (10, 12),
            "Resistant starch (g)": (1, 3),
            "Antioxidants": "Moderate"
        },
        "Benefits": "High natural sugar, provides energy, antioxidants good for immunity.",
        "Limitations": "Not suitable for diabetics, high GI."
    },
    "overripe": {
        "Characteristics": "Soft stem, dark yellow with brown spots, high GI (~16g sugar).",
        "Nutrition": {
            "Calories (kcal)": (85, 95),
            "Carbohydrate (g)": (18, 22),
            "Sugar (g)": (15, 17),
            "Fiber (g)": (2, 4),
            "Potassium (mg)": (330, 370),
            "Vitamin B6 (% DV)": (20, 28),
            "Vitamin C (% DV)": (8, 12),
            "Resistant starch (g)": (0, 2),
            "Antioxidants": "High"
        },
        "Benefits": "High antioxidants, good for immunity.",
        "Limitations": "High sugar, not suitable for diabetics, may cause blood sugar spikes."
    },
    "rotten": {
        "Characteristics": "Soft stem, dark color, reduced nutrients, high GI.",
        "Nutrition": {
            "Calories (kcal)": (0, 0),
            "Carbohydrate (g)": (0, 0),
            "Sugar (g)": (0, 0),
            "Fiber (g)": (0, 0),
            "Potassium (mg)": (0, 0),
            "Vitamin B6 (% DV)": (0, 0),
            "Vitamin C (% DV)": (0, 0),
            "Resistant starch (g)": (0, 0),
            "Antioxidants": "None"
        },
        "Benefits": "High antioxidants but not significant.",
        "Limitations": "Toxic, risk of bacteria, should not be eaten."
    }
}

# Predefined information for mango ripeness stages
mango_info = {
    "unripe": {
        "Characteristics": "Green skin, firm, astringent taste, low glycemic index (GI) (~30).",
        "Nutrition": {
            "Calories (kcal)": (50, 65),
            "Carbohydrate (g)": (18, 20),
            "Sugar (g)": (1, 3),
            "Fiber (g)": (3.5, 4.7),
            "Potassium (mg)": (120, 160),
            "Vitamin A (% DV)": (0, 2),
            "Vitamin C (mg)": (50, 90),
            "Resistant starch (%)": (15, 20),
            "Antioxidants": "Low"
        },
        "Benefits": "Supports digestion due to resistant starch, low calories, good for weight loss and blood sugar control.",
        "Limitations": "Low sweetness, may cause indigestion if eaten in large amounts."
    },
    "early ripe": {
        "Characteristics": "Green-yellow skin, slightly soft, mild sour taste, GI ~35-40.",
        "Nutrition": {
            "Calories (kcal)": (55, 65),
            "Carbohydrate (g)": (17, 19),
            "Sugar (g)": (5, 8),
            "Fiber (g)": (3.0, 4.0),
            "Potassium (mg)": (130, 180),
            "Vitamin A (% DV)": (2, 4),
            "Vitamin C (mg)": (40, 60),
            "Resistant starch (%)": (5, 15),
            "Antioxidants": "Moderate"
        },
        "Benefits": "Balances starch and sugar, supports digestion, boosts vitamin C.",
        "Limitations": "Not fully sweet yet, suitable for those who like sour taste."
    },
    "partial ripe": {
        "Characteristics": "More yellow/red skin, softer, sweet-sour taste, GI ~45.",
        "Nutrition": {
            "Calories (kcal)": (60, 70),
            "Carbohydrate (g)": (16, 18),
            "Sugar (g)": (8, 12),
            "Fiber (g)": (2.5, 3.5),
            "Potassium (mg)": (150, 200),
            "Vitamin A (% DV)": (4, 6),
            "Vitamin C (mg)": (30, 40),
            "Resistant starch (%)": (1, 5),
            "Antioxidants": "High"
        },
        "Benefits": "Provides moderate energy, increases vitamins A and C, good for eyes and immunity.",
        "Limitations": "Higher sugar, caution needed for diabetics."
    },
    "fully ripe": {
        "Characteristics": "Yellow/orange-red skin, soft, strong sweet taste, aromatic, GI ~55.",
        "Nutrition": {
            "Calories (kcal)": (60, 70),
            "Carbohydrate (g)": (15, 17),
            "Sugar (g)": (13, 15),
            "Fiber (g)": (1.6, 2.6),
            "Potassium (mg)": (170, 210),
            "Vitamin A (% DV)": (6, 8),
            "Vitamin C (mg)": (15, 30),
            "Resistant starch (%)": (0, 1),
            "Antioxidants": "High"
        },
        "Benefits": "High energy, rich in vitamins A and C, supports eyes, skin, and immunity.",
        "Limitations": "High sugar, not suitable for diabetics if eaten in large amounts."
    },
    "rotten": {
        "Characteristics": "Dark skin, mushy, foul smell, high GI (>60).",
        "Nutrition": {
            "Calories (kcal)": (0, 0),
            "Carbohydrate (g)": (0, 0),
            "Sugar (g)": (0, 0),
            "Fiber (g)": (0, 0),
            "Potassium (mg)": (0, 0),
            "Vitamin A (% DV)": (0, 0),
            "Vitamin C (mg)": (0, 0),
            "Resistant starch (%)": (0, 0),
            "Antioxidants": "None"
        },
        "Benefits": "Negligible, high antioxidants but no significant value.",
        "Limitations": "Risk of bacteria, should not be eaten."
    }
}

def load_model(fruit: str):
    """Load the appropriate PyTorch model based on fruit type."""
    if fruit == "banana":
        model_path = "backend/models/best_banana_model.pth"
        num_classes = 6
    elif fruit == "mango":
        model_path = "backend/models/best_mango_model.pth"
        num_classes = 5
    else:
        raise ValueError("Invalid fruit type")
    model = models.resnet18(pretrained=False)
    model.fc = nn.Linear(model.fc.in_features, num_classes)
    
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model.load_state_dict(torch.load(model_path, map_location=device))
    model = model.to(device)
    model.eval()
    return model

def preprocess_image(image_path: str):
    """Preprocess the image for model input."""
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    image = Image.open(image_path).convert('RGB')
    image = transform(image).unsqueeze(0)  # Add batch dimension
    return image

def predict(model, image_tensor, device):
    """Run the model prediction."""
    image_tensor = image_tensor.to(device)
    with torch.no_grad():
        outputs = model(image_tensor)
        _, predicted = torch.max(outputs, 1)
    return predicted.item()

@app.post("/classify/")
async def classify_fruit(fruit: str = Form(...), image: UploadFile = File(...)):
    """Classify the fruit ripeness stage and return results."""
    # Save the image temporarily
    image_path = f"temp_{image.filename}"
    with open(image_path, "wb") as buffer:
        shutil.copyfileobj(image.file, buffer)
    
    try:
        # Load the model
        model = load_model(fruit)
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        model.to(device)
        
        # Preprocess the image
        image_tensor = preprocess_image(image_path)
        
        # Predict
        predicted_class_idx = predict(model, image_tensor, device)
        
        # Get the class name and info based on fruit type
        if fruit == "banana":
            class_names = ["fresh ripe", "fresh unripe", "overripe", "ripe", "rotten", "unripe"]
            info_dict = banana_info
        elif fruit == "mango":
            class_names = ["early ripe", "fully ripe", "partial ripe", "rotten", "unripe"]
            info_dict = mango_info
        else:
            return JSONResponse(content={"error": "Invalid fruit type"}, status_code=400)
        
        predicted_class = class_names[predicted_class_idx]
        info = info_dict[predicted_class]
        
        # Return the result
        return JSONResponse(content={
            "fruit": fruit,
            "ripeness_stage": predicted_class,
            "characteristics": info["Characteristics"],
            "benefits": info["Benefits"],
            "limitations": info["Limitations"],
            "nutritional_estimation": info["Nutrition"]
        })
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)
    finally:
        # Clean up temporary file
        if os.path.exists(image_path):
            os.remove(image_path)