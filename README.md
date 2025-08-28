# 💧 Water Quality & BPA Prediction

The **Water Quality & BPA Prediction App** is designed to monitor water quality in real-time and predict the risk of Bisphenol A (BPA) contamination. It integrates IoT sensors, microcontrollers, and AI models to ensure safe water consumption by providing live insights and alerts.

---

## 🌟 Features

- 🧪 **Real-time Sensor Monitoring**  
  Measures **pH**, **TDS (Total Dissolved Solids)**, and **Turbidity** continuously.  

- ⚗️ **BPA Risk Prediction**  
  Uses machine learning to predict potential BPA contamination based on sensor data.  

- ☁️ **Cloud Dashboard**  
  Displays live readings and BPA predictions for remote monitoring.  

- 🚨 **Alerts & Notifications**  
  Issues alerts when unsafe values or high BPA risks are detected.  

---

## 🖼️ Screenshots


### 🧑‍💻 Architecture Diagram
![Architecture](./83f6200e-4cce-42d1-b99c-11fd7ce6c765)


### 😀 Emotion Detection in Real-time
![Emotion Detection](./408d6b76-4b68-481b-82ce-20c05db6dbc8.png)

---
---

## 📁 Project Structure

| File | Description |
|------|-------------|
| `sensor_code.ino` | Microcontroller code for pH, TDS, Turbidity sensors |
| `predict_bpa.py` | Machine learning model for BPA prediction |
| `cloud_integration.py` | Cloud upload and dashboard integration |
| `requirements.txt` | Python dependencies |
| `README.md` | Documentation |

---

## 🔍 Methodology

### 1. Real-time Data Collection
- ESP8266/Arduino reads pH, TDS, and Turbidity values.  
- Preprocesses raw sensor data for consistency.  

### 2. Data Transmission
- Sends water quality readings to cloud dashboard via Wi-Fi.  

### 3. BPA Prediction Model
- ML model analyzes water parameters.  
- Predicts probability of BPA contamination.  

### 4. Alerts
- Dashboard triggers alerts if unsafe thresholds are crossed.  

---

## 📊 Sample Output

| Parameter | Example Value | Safe Range |
|-----------|---------------|------------|
| pH | 6.8 | 6.5 – 8.5 |
| TDS (ppm) | 380 | < 500 |
| Turbidity (NTU) | 2.5 | < 5 |
| BPA Risk | 0.72 (High) | < 0.40 |

---

## 🛠️ Getting Started

- git clone https://github.com/Yukivid/Water-Quality-prediction-BPA-prediction.git
- cd Water-Quality-prediction-BPA-prediction
- pip install -r requirements.txt
- python predict_bpa.py

---

## 🚀 Future Enhancements

- Support for additional sensors (chlorine, heavy metals, bacteria).
- AI-based trend analysis & anomaly detection.
- SMS/Email alerts for real-time notifications.
- Integration with mobile dashboards.

---

## ✨ Developed by Deepesh Raj A.Y

If you found this helpful, leave a ⭐ on GitHub!

