# FruitToGo – Fruit Ripeness Recognition Mobile Application

FruitToGo is a cross-platform mobile application that uses **Deep Learning** to recognize the ripeness level of fruits from images captured by users. Based on the predicted ripeness stage, the app provides **nutritional information** and **personalized fruit recommendations** to support healthier dietary choices.

---

## Features

- Capture fruit images directly from the mobile camera  
- Deep Learning–based fruit ripeness classification  
- Nutritional analysis based on fruit ripeness levels  
- Personalized fruit recommendations for users  
- Cross-platform mobile application (Android, iOS)

---

## AI & Machine Learning

- Image-based fruit ripeness classification  
- Image preprocessing and augmentation for improved model performance  
- Model inference served via a backend API  
- Designed for real-world usage with mobile image inputs  

---

## System Architecture

- **Mobile App (Flutter)**  
  - Captures fruit images  
  - Sends images to backend for inference  
  - Displays prediction results, nutrition data, and recommendations  

- **Backend (FastAPI)**  
  - Hosts the Deep Learning model  
  - Handles image preprocessing and model inference  
  - Returns ripeness classification and related information  

---

## Tech Stack

### AI / Deep Learning
- Python  
- Deep Neural Network resnet18 
- PyTorch 

### Backend
- **FastAPI**  
- Uvicorn  
- Python-based model inference service  

### Mobile Application
- Flutter  
- Dart  
- Camera integration  

### Tools
- Git & GitHub  
- Virtual environments & dependency management  

---

## Project Structure

```
FruitToGo/
│
├── backend/ # FastAPI backend & Deep Learning model
├── lib/ # Flutter application source code
├── assets/ # Images, resources
├── android/ # Android platform files
├── ios/ # iOS platform files
├── web/ # Web support
├── macos/ # macOS support
├── windows/ # Windows support
└── linux/ # Linux support
```


---

## How It Works

1. The user captures a fruit image using the mobile app  
2. The image is sent to the FastAPI backend  
3. The Deep Learning model predicts the fruit's ripeness level  
4. The backend returns:
   - Ripeness classification  
   - Nutritional information  
   - Recommended fruits  
5. Results are displayed in the mobile application  

---

## Future Improvements

- Support for more fruit types  
- Model optimization and accuracy improvement  
- On-device inference for faster performance  
- User dietary preference customization  
- Model monitoring and performance tracking  

---

## Author

**Nguyen Luong**  
Data Science & Artificial Intelligence Student  
Hanoi University of Science and Technology  

---

## License

This project is for educational and research purposes.
