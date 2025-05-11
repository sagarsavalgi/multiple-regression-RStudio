# fire_prediction_analysis.R
# Forest Fire Area Prediction using Linear Regression in R

# ===============================
# 📦 1. Load Required Libraries
# ===============================
packages <- c("ggplot2", "dplyr", "car", "GGally")
lapply(packages, require, character.only = TRUE)

# ===============================
# 📂 2. Load Dataset
# ===============================
fires <- attach("firesD.csv")
str(fires)

# ===============================
# 🔧 3. Data Cleaning & Preprocessing
# ===============================
# Convert categorical variables to factors
fires$month <- as.factor(fires$month)
fires$day <- as.factor(fires$day)
fires$rain <- as.factor(fires$rain)  # rain is a dummy: 1 = rain, 0 = no rain

# Add a transformed response variable
fires$log_area <- log(fires$area + 1)

# ===============================
# 📊 4. Exploratory Data Analysis
# ===============================
summary(fires)
ggpairs(fires[, c("FFMC", "DMC", "DC", "ISI", "temp", "RH", "wind", "area")])
hist(fires$area, breaks = 50, main = "Distribution of Burned Area", xlab = "Area (ha)")
hist(fires$log_area, breaks = 50, main = "Distribution of Log(Area + 1)", xlab = "Log Area")

# ===============================
# 📈 5. Model Building
# ===============================
# Base model
model1 <- lm(log_area ~ FFMC + DMC + DC + ISI + temp + RH + wind + rain, data = fires)
summary(model1)

# Try polynomial terms to improve linearity
model2 <- lm(log_area ~ poly(temp, 2) + poly(FFMC, 2) + DMC + DC + ISI + RH + wind + rain, data = fires)
summary(model2)

# ===============================
# ✅ 6. Model Diagnostics
# ===============================
par(mfrow = c(2, 2))
plot(model2)  # residuals, fitted, leverage

# Homoscedasticity test
ncvTest(model2)

# QQ Plot for normality
qqPlot(model2, main = "QQ Plot of Residuals")

# Outlier and influence check
influencePlot(model2)

# Reset plot window
par(mfrow = c(1, 1))
