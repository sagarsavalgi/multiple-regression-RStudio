# Multiple Linear Regression Projects

This repository contains data analysis projects using **Multiple Linear Regression (MLR)** in RStudio. Each project uses a real dataset and applies regression techniques to make predictions and understand variable relationships.

---

## 🔥 1. Fire Area Prediction

**Objective**: Predict the burned area of forest fires in Portugal using weather-related variables.

**Dataset**: Meteorological data including temperature, humidity, wind, and dryness indexes from the Montesinho natural park.

**Highlights**:
- Log transformation of target variable (`area`)
- Exploratory data analysis using pair plots and histograms
- Polynomial regression for improved model fit
- Model diagnostics and prediction


**File**: [FiresD.R](https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/forest-fire-prediction/Scripts/FiresD.R)
**Analysis**:  [ooooooo](oooooooo)

---

## 💰 2. Earnings Analysis

**Objective**: Predict earnings based on demographic factors such as education, age, and gender.

**Highlights**:
- Handling categorical predictors
- Building and interpreting a linear model
- Checking assumptions and diagnosing the model

**File**:  [yearly-earnings.R](https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/yearly-earnings/Scripts/yearly-earnings_analysis.R)

**Analysis**:  [Report](https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/yearly-earnings/Analysis%20Description/Report.md)

---


## Requirements

These R packages are used:

```r
install.packages(c("tidyverse", "car", "GGally"))
