

# 🔥 Modeling Forest Fire Burned Area with Linear Regression in R

In this project, we analyze a forest fire dataset from northeast Portugal using **multiple linear regression** to understand which environmental variables influence fire severity and to what extent. The modeling process includes data cleaning, transformation, exploratory analysis, model construction, and diagnostic validation. Each step supported by statistical reasoning and visual interpretation.

---

## 📦 Loading Required Libraries

Before diving into the dataset, the analysis begins with the preparation of the R environment by loading essential libraries. These packages support visualization, regression diagnostics, and multivariate analysis:

```r
> packages <- c("ggplot2", "dplyr", "car", "GGally")
> lapply(packages, require, character.only = TRUE)
```

Here, `ggplot2` powers all the plotting functionality, `dplyr` helps with data manipulation, `car` provides advanced regression diagnostics (like tests for constant variance), and `GGally` is used for enhanced pairwise plotting — particularly helpful when investigating multivariate relationships.

---

## 📂 Accessing and Understanding the Dataset

With the environment set, the next step is to make the dataset accessible using:

```r
> attach(firesD)
```
```r
> str(firesD)

'data.frame':	517 obs. of  15 variables:
 $ X.1   : int  1 2 3 4 5 6 7 8 9 10 ...
 $ X     : int  7 7 7 8 8 8 8 8 8 7 ...
 $ Y     : int  5 4 4 6 6 6 6 6 6 5 ...
 $ month : chr  "mar" "oct" "oct" "mar" ...
 $ day   : chr  "fri" "tue" "sat" "fri" ...
 $ FFMC  : num  86.2 90.6 90.6 91.7 89.3 92.3 92.3 91.5 91 92.5 ...
 $ DMC   : num  26.2 35.4 43.7 33.3 51.3 ...
 $ DC    : num  94.3 669.1 686.9 77.5 102.2 ...
 $ ISI   : num  5.1 6.7 6.7 9 9.6 14.7 8.5 10.7 7 7.1 ...
 $ temp  : num  8.2 18 14.6 8.3 11.4 22.2 24.1 8 13.1 22.8 ...
 $ RH    : int  51 33 33 97 99 29 27 86 63 40 ...
 $ wind  : num  6.7 0.9 1.3 4 1.8 5.4 3.1 2.2 5.4 4 ...
 $ rain  : int  1 1 1 0 1 1 1 1 1 1 ...
 $ area  : num  0 0 0 0 0 0 0 0 0 0 ...
 $ d.rain: int  1 1 1 0 1 1 1 1 1 1 ...
```

The `attach()` function allows us to reference columns in the dataset directly without the `firesD$` prefix. A quick structure check using `str()` reveals that the dataset contains **517 observations** across **16 variables**, including `FFMC`, `DMC`, `DC`, `ISI`, `temp`, `RH`, `wind`, and the target variable `area`, which represents the forest area burned in hectares.

---

## 🔧 Data Cleaning and Preprocessing

Regression models are sensitive to how variables are structured. To prepare the data, we convert some relevant variables into categorical (`factor`) form, particularly those that represent categories such as month, day, and whether it rained:

```r
> firesD$month <- as.factor(firesD$month)
> firesD$day <- as.factor(firesD$day)
> firesD$rain <- as.factor(firesD$rain)
```

Additionally, to address the heavy skew in the `area` variable; common in real-world fire data due to many small fires and a few large ones — we apply a log transformation. Adding 1 avoids issues with zero values:

```r
> firesD$log_area <- log(firesD$area + 1)
```


This transformation makes the variable better suited to modeling with linear regression, where assumptions about the distribution and scale of the dependent variable matter.

---

## 📊 Exploratory Data Analysis

Using `summary(firesD)`, we examine variable distributions, spotting high skew in `area` and wide ranges in indices like `DMC`, `DC`, and `ISI`.


```r
>  summary(firesD)

      X.1            X               Y           month      day          FFMC      
 Min.   :  1   Min.   :1.000   Min.   :2.0   aug    :184   fri:85   Min.   :18.70  
 1st Qu.:130   1st Qu.:3.000   1st Qu.:4.0   sep    :172   mon:74   1st Qu.:90.20  
 Median :259   Median :4.000   Median :4.0   mar    : 54   sat:84   Median :91.60  
 Mean   :259   Mean   :4.669   Mean   :4.3   jul    : 32   sun:95   Mean   :90.64  
 3rd Qu.:388   3rd Qu.:7.000   3rd Qu.:5.0   feb    : 20   thu:61   3rd Qu.:92.90  
 Max.   :517   Max.   :9.000   Max.   :9.0   jun    : 17   tue:64   Max.   :96.20  
                                             (Other): 38   wed:54                  
      DMC              DC             ISI              temp             RH        
 Min.   :  1.1   Min.   :  7.9   Min.   : 0.000   Min.   : 2.20   Min.   : 15.00  
 1st Qu.: 68.6   1st Qu.:437.7   1st Qu.: 6.500   1st Qu.:15.50   1st Qu.: 33.00  
 Median :108.3   Median :664.2   Median : 8.400   Median :19.30   Median : 42.00  
 Mean   :110.9   Mean   :547.9   Mean   : 9.022   Mean   :18.89   Mean   : 44.29  
 3rd Qu.:142.4   3rd Qu.:713.9   3rd Qu.:10.800   3rd Qu.:22.80   3rd Qu.: 53.00  
 Max.   :291.3   Max.   :860.6   Max.   :56.100   Max.   :33.30   Max.   :100.00  
                                                                                  
      wind       rain         area             d.rain          log_area     
 Min.   :0.400   0:  8   Min.   :   0.00   Min.   :0.0000   Min.   :0.0000  
 1st Qu.:2.700   1:509   1st Qu.:   0.00   1st Qu.:1.0000   1st Qu.:0.0000  
 Median :4.000           Median :   0.52   Median :1.0000   Median :0.4187  
 Mean   :4.018           Mean   :  12.85   Mean   :0.9845   Mean   :1.1110  
 3rd Qu.:4.900           3rd Qu.:   6.57   3rd Qu.:1.0000   3rd Qu.:2.0242  
 Max.   :9.400           Max.   :1090.84   Max.   :1.0000   Max.   :6.9956  
```


Next, a `ggpairs()` plot helps visualize correlations and trends between numeric predictors:

```r
> ggpairs(firesD[, c("FFMC", "DMC", "DC", "ISI", "temp", "RH", "wind", "area")])
```

<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/forest-fire-prediction/Images/ggpairs.png">


To confirm the impact of transformation, two histograms are plotted:

```r
> hist(firesD$area, breaks = 50, main = "Distribution of Burned Area", xlab = "Area (ha)")
```
<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/forest-fire-prediction/Images/Hist%20burned%20area.png" height = "400" width = "800">



```r
> hist(firesD$log_area, breaks = 50, main = "Distribution of Log(Area + 1)", xlab = "Log Area")
```

<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/forest-fire-prediction/Images/Hist%20Log(area%2B1).png" height = "400" width = "800">





The first histogram shows the classic long tail associated with untransformed area data. The second, using the log transformation, compresses extreme values and helps normalize the distribution; aligning better with linear regression assumptions.

---

## 📈 Model Building: From Baseline to Polynomial

To begin modeling, a basic multiple linear regression is constructed using all major environmental predictors:

```r
> model1 <- lm(log_area ~ FFMC + DMC + DC + ISI + temp + RH + wind + rain, data = firesD)
```
```r
> summary(model1)

Call:
lm(formula = log_area ~ FFMC + DMC + DC + ISI + temp + RH + wind + 
    rain, data = firesD)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.6093 -1.0991 -0.5776  0.8778  5.7127 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)  
(Intercept) -0.9661511  1.5566414  -0.621   0.5351  
FFMC         0.0101566  0.0145158   0.700   0.4844  
DMC          0.0011569  0.0014614   0.792   0.4289  
DC           0.0002337  0.0003569   0.655   0.5129  
ISI         -0.0241888  0.0168925  -1.432   0.1528  
temp         0.0075570  0.0172775   0.437   0.6620  
RH          -0.0025582  0.0053281  -0.480   0.6313  
wind         0.0844173  0.0367662   2.296   0.0221 *
rain1        0.7616340  0.5269219   1.445   0.1490  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.393 on 508 degrees of freedom
Multiple R-squared:  0.0235,	Adjusted R-squared:  0.00812 
F-statistic: 1.528 on 8 and 508 DF,  p-value: 0.1446

```

This base model performs modestly, with an **Adjusted R² of 0.008** and only one statistically significant predictor: `wind`. While the residual standard error (1.393) indicates a noisy response, these results are not uncommon in environmental datasets, where many interacting factors influence outcomes.

To capture potential **non-linear relationships**, particularly with `temp` and `FFMC`, we enhance the model using polynomial transformations:

```r
> model2 <- lm(log_area ~ poly(temp, 2) + poly(FFMC, 2) + DMC + DC + ISI + RH + wind + rain, data = firesD)
```

```r
> summary(model2)

Call:
lm(formula = log_area ~ poly(temp, 2) + poly(FFMC, 2) + DMC + 
    DC + ISI + RH + wind + rain, data = firesD)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.0182 -1.0473 -0.5413  0.8036  5.6458 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)   
(Intercept)     0.0002747  0.6579006   0.000  0.99967   
poly(temp, 2)1  0.4116565  2.2790429   0.181  0.85673   
poly(temp, 2)2  4.7466718  1.4483551   3.277  0.00112 **
poly(FFMC, 2)1  1.9852598  1.9934603   0.996  0.31978   
poly(FFMC, 2)2 -0.5713967  1.7200305  -0.332  0.73987   
DMC             0.0008361  0.0014666   0.570  0.56889   
DC              0.0004909  0.0003629   1.353  0.17671   
ISI            -0.0237681  0.0189289  -1.256  0.20982   
RH             -0.0018560  0.0052999  -0.350  0.72633   
wind            0.0750954  0.0368936   2.035  0.04233 * 
rain1           0.7556694  0.5244966   1.441  0.15027   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.381 on 506 degrees of freedom
Multiple R-squared:  0.04397,	Adjusted R-squared:  0.02508 
F-statistic: 2.327 on 10 and 506 DF,  p-value: 0.011
```

This updated model improves slightly, with an **Adjusted R² of 0.025**, and the second-degree polynomial of `temp` (`poly(temp, 2)2`) emerges as a statistically significant predictor (p ≈ 0.001). `wind` also retains significance (p ≈ 0.042). These results suggest that fire area increases with temperature in a non-linear manner, possibly exponentially once a critical temperature threshold is crossed, and that higher wind speeds facilitate fire spread.

---

## ✅ Model Diagnostics and Assumption Checks

After fitting the improved model, it's essential to evaluate whether the assumptions of linear regression hold.

We start with visual diagnostics:

```r
> par(mfrow = c(2, 2))
> plot(model2)
```

<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/forest-fire-prediction/Images/residuals%2C%20fitted%2C%20leverage.png" height = "400" width = "800">


This command generates four plots:

* **Residuals vs Fitted**: checks for non-linear patterns.
* **Normal Q-Q Plot**: checks residual normality.
* **Scale-Location**: checks homoscedasticity.
* **Residuals vs Leverage**: identifies influential points.

To confirm the **homoscedasticity assumption**, we use:

```r
> ncvTest(model2)

Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 6.635244, Df = 1, p = 0.0099981
```

The output reveals a **p-value of 0.00999**, which is statistically significant. This indicates that the residuals likely suffer from **non-constant variance**, i.e., heteroscedasticity — a known limitation when modeling highly variable natural phenomena like fire damage.

Normality is assessed through a QQ plot:

```r
> qqPlot(model2, main = "QQ Plot of Residuals")
```
<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/forest-fire-prediction/Images/QQplot.png" height = "400" width = "800">

This reveals deviations from the line, suggesting that the residuals are not perfectly normally distributed. Again, this isn’t surprising in environmental data, but it's a caution to interpret p-values conservatively.

Finally, to detect overly influential observations:

```r
> influencePlot(model2)

      StudRes         Hat       CookD
23  0.1873883 0.362224518 0.001816483
239 4.1670298 0.006056908 0.009318096
380 0.7013720 0.892033904 0.369857500
416 3.7144547 0.015893407 0.019757192
500 1.3725849 0.131711345 0.025935028
```

<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/forest-fire-prediction/Images/Outlier%20and%20Influence.jpeg" height = "350" width = "700">

A few observations, notably case **380**, show high leverage and Cook’s distance, indicating potential outliers. While these don't invalidate the model, they highlight the dataset's diversity and possible edge cases, perhaps from extremely large fires or sensor anomalies.

---

## 🧠 Conclusion

This regression analysis offers valuable insights into the conditions that impact forest fire severity. While the model's predictive power is limited (Adjusted R² \~ 0.025), it successfully identifies **temperature** (non-linearly) and **wind speed** as consistent influencers of fire area burned. Diagnostic checks reveal slight violations in assumptions, especially variance homogeneity, but the overall modeling process captures meaningful trends.

The findings align with intuition: **hotter, windier conditions** promote larger fires. Future models could benefit from more detailed spatial data, time series information, or non-linear methods like random forests.


