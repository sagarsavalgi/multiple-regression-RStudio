# 🔥 Forest Fire Area Prediction in Portugal using Multiple Linear Regression

This project analyzes meteorological and environmental data from northeast Portugal to predict the **burned area** of forest fires. The goal is to support non-technical fire department staff with an interpretable statistical model for fire management and resource planning.

---

## 📊 Dataset Overview

The dataset was collected from the Montesinho Natural Park in northeast Portugal and contains 517 fire occurrences. Each observation includes spatial, temporal, and meteorological information.

### 🔧 Key Variables

| Feature       | Description                                             |
|---------------|---------------------------------------------------------|
| `X`, `Y`      | Spatial coordinates (1–9, 2–9)                           |
| `month`, `day`| Temporal info (e.g., "aug", "fri")                      |
| `FFMC`, `DMC`, `DC`, `ISI` | Fire Weather Index components             |
| `temp`        | Temperature in °C (2.2 to 33.3)                          |
| `RH`          | Relative humidity (%)                                   |
| `wind`        | Wind speed (km/h)                                       |
| `rain`        | Dummy variable: 1 if it rained, 0 otherwise             |
| `area`        | Burned area in hectares (target variable)              |

---

## 🎯 Objective

To develop a **multiple linear regression model** that can predict the `area` of a forest fire based on weather and environmental conditions. The model should be interpretable by non-technical users and support practical fire response planning.

---

## 🧪 Methodology

1. **Data Cleaning**  
   - Removed zero-area entries for better modeling.
   - Converted categorical variables (`month`, `day`) to dummy variables.
   - Considered log-transformation on `area` due to right-skewed distribution.

2. **Modeling**
   - Built a multiple linear regression model on `log(area + 1)` to handle skewness.
   - Selected predictors: `temp`, `wind`, `rain`, `RH`, `ISI`, `DMC`, `DC`
   - Checked model assumptions: linearity, normality, and constant variance.

3. **Prediction Interval**  
   A 95% prediction interval was computed for the following condition:
   - Temperature = 28°C  
   - Wind speed = 8 km/h  
   - No rain (rain = 0)  
   - Other values assigned reasonably within observed range


---

## 💡 Key Insights

- **Hot, dry, and windy** conditions significantly increase the expected burned area.
- **Rain presence** suppresses fire spread.
- **FWI components** like `ISI` and `DMC` are important indicators of fire behavior.


---

