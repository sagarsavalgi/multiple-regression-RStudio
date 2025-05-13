# Predicting Yearly Earnings Using Multiple Regression in R

This project applies multiple linear regression techniques to explore the impact of personal and socio-economic variables on yearly earnings, using survey data from the 1990s.

## 📊 Objective

To predict the variable `earnk` (yearly earnings in thousands of dollars) using a set of demographic and behavioral predictors.

## 📁 Dataset

1816 observations with 15 variables, including:

- Height, weight, sex, age
- Ethnicity, education level, parental education
- Lifestyle habits (smoking, walking, exercising)
- Psychological metrics (anxiety and angriness)

## 🧠 Approach

- Checked for multicollinearity and removed highly correlated predictors.
- Applied Box-Cox transformation to address skewness in the response variable.
- Included a quadratic term for `age` to capture non-linearity.
- Validated assumptions using residual plots, QQ plot, and constant variance tests.
- Built and evaluated a model using adjusted R² and significance tests.

## 📌 Key Findings

- `Education`, `age`, `sex`, and `height` were statistically significant predictors.
- Adjusted R² = **0.2764** — the model explains ~28% of the variation in earnings.
- All assumptions for multiple linear regression were satisfied.

## 💡 Conclusion

The model suggests that education, age, and gender have a strong influence on earnings. While the dataset is U.S.-specific and from the 1990s, some insights (e.g., effect of education) may generalize cautiously.

## ▶️ How to Run

1. Open `scripts/earnings_analysis.R` in RStudio.
2. Run all code cells in order.
3. Output plots and summaries are saved in the `results/` folder.

## 📚 Skills Highlighted

- Linear modeling and diagnostics
- Data transformation and assumption validation
- R programming (tidyverse, base R, car package)
