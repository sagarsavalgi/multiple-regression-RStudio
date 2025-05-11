# Load required packages
library(car)
library(psych)
library(ggplot2)

# Attach the dataset and inspect
attach(Earnings)
str(Earnings)
names(Earnings)

# Convert categorical variables to factors
Earnings$sex <- as.factor(Earnings$sex)
Earnings$ethnicity <- as.factor(Earnings$ethnicity)
Earnings$smokenow <- as.factor(Earnings$smokenow)

# Check for NAs and remove rows with missing values
summary(Earnings)
Earnings <- Earnings[complete.cases(Earnings), ]
summary(Earnings)

# Initial pairwise exploration
pairs.panels(Earnings, cex.cor = 0.7)

# Remove multicollinear variables (education ~ parents' education, earn ~ earnk)
# Initial linear model (no transformation yet)
m0 <- lm(earnk ~ height + weight + sex + ethnicity + education + walk + 
           exercise + smokenow + angry + age, data = Earnings)

# Check residual plots for m0
residualPlots(m0)

# Box-Cox transformation to improve response variable skew
m <- lm(earnk + 1 ~ height + weight + sex + ethnicity + education + walk + 
          exercise + smokenow + angry + age, data = Earnings)
powerTransform(m)  # Result ~0.32 suggested

# Build transformed model with Box-Cox power and quadratic age
m1 <- lm((earnk + 1)^0.32 ~ height + weight + sex + ethnicity + education + 
           walk + exercise + smokenow + angry + age + I(age^2), data = Earnings)

# Plot residuals vs fitted values (Linearity)
ggplot(data = m1, aes(x = .fitted, y = .resid, size = .cooksd)) +
  labs(title = "Fitted vs. Residuals", x= "Fitted Values", y ="Residuals") + 
  geom_point(color = "dark red") +
  geom_abline(slope = 0, intercept = 0, linetype = 2, color = "black") +
  geom_smooth(method = "loess", se = FALSE, color = "navy", lwd = 1.5)

# Spread-Location plot (Homoscedasticity)
ggplot(data = m1, aes(x = .fitted, y = sqrt(abs(.stdresid)), size = .cooksd)) +
  geom_point(color = "steel blue") + 
  geom_smooth(se=FALSE, color = "dark red") +
  labs(title = "Spread Location Plot", x = "Fitted Values", y = "√(Absolute Std Residuals)")

# Test for constant variance
ncvTest(m1)

# QQ Plot (Normality)
ggplot(m1, aes(sample = .stdresid)) + 
  stat_qq(color = "blue4") + 
  stat_qq_line(color = "firebrick3", lwd = 1) +
  labs(title = "QQ Plot", x = "Theoretical", y = "Sample")

# Outlier Test
outlierTest(m1)

# Final model summary
summary(m1)
