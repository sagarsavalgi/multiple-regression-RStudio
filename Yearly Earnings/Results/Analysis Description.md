# 📊 EARNINGS: Multiple Regression Analysis in R

This project investigates the impact of various predictors on individual earnings using multiple linear regression in R.

---

## 🔧 Step 1: Prepare the Dataset

**Identify predictors and response:**

- **Predictors (X)**: `height`, `weight`, `sex`, `earn`, `ethnicity`, `education`, `mother_education`, `father_education`, `walk`, `exercise`, `smokenow`, `tense`, `angry`, `age`  
- **Response (Y)**: `earnk`

--

Let's attach the `.csv` file, the dataset, this is like finalising that the subsequent analysis should be done on the Earnings dataset.
```r
> attach(Earnings)
```


I want to check the structure of the dataset to see what kind of data I am dealing with. So, I used the function `str()` and the result output shown was as follows:

```r
> str(Earnings)

'data.frame':	1816 obs. of  15 variables:
 $ height           : int 74 66 64 65 63 68 63 64 62 73 ...
 $ weight           : int 210 125 126 200 110 165 190 125 200 230 ...
 $ sex              : int 1 0 0 0 0 0 0 0 0 1 ...
 $ earn             : num 50000 60000 30000 25000 50000 62000 51000 9000 29000 32000 ...
 $ earnk            : num 50 60 30 25 50 62 51 9 29 32 ...
 $ ethnicity        : chr "White" "White" "White" "White" ...
 $ education        : int 16 16 16 17 16 18 17 15 12 17 ...
 $ mother_education : int 16 16 16 17 16 18 17 15 12 17 ...
 $ father_education : int 16 16 16 NA 16 18 17 15 12 17 ...
 $ walk             : int 3 6 8 8 5 1 3 7 2 7 ...
 $ exercise         : int 3 5 1 1 6 1 1 4 2 1 ...
 $ smokenow         : int 2 1 2 2 2 2 2 1 2 1 ...
 $ tense            : int 0 0 1 0 0 2 4 4 0 0 ...
 $ angry            : int 0 0 1 0 0 2 4 4 0 0 ...
 $ age              : int 45 58 29 57 91 54 39 26 49 46 ...
```

You can see how each variable is categorized as ”integer” and “numeric.”  The ones with “character” (as chr) like ethnicity, and sex (which is in binary) should be converted to factors with the function 
`Dataset$variable  <- as.factor(dataset$variable)`. Convert all the binary data into factors:



```r
> Earnings$sex <- as.factor(Earnings$sex)
> Earnings$ethnicity <- as.factor(Earnings$ethnicity)
> Earnings$smokenow <- as.factor(Earnings$smokenow)
```
Now, the data looks good. I can go ahead with the analysis part.



## 📊 Step 2: Explore Data & Correlation

To get a simplistic view of our dataset, we can use the `pairs()` or (`pairs.panels()`: where you get correlation values as well) command, which will show the relationship between all the variables. 

```r
> pairs.panels(Earnings)
```
You can zoom into the image to magnify the corelation values in the upper panel of the variable graph:


<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/Yearly%20Earnings/Images/pairs-panels.png">


The variable `earnk` is perfectly correlated with the variable `earn`, so we have to remove that variable, as well as, `education` is perfectly correlated with `father_education` and `mother_education` **(high multicollinearity)**, so we will be removing those 2 variables as well. Even the variables `tense` and `angry`, we can drop any one of them because **high multicollinearity**.
We may have to apply transformation to our ‘y’ variable `earnk` since it has skewness (right skewed; right asymmetry). 

We will check the names of the variables before we make a model. With the `names()` command you can view the names of all the variables in the dataset. The output:

```r
> names(Earnings)

 [1] "height"           "weight"           "sex"              "earn"             "earnk"            "ethnicity"        "education"        "mother_education"
 [9] "father_education" "walk"             "exercise"         "smokenow"         "tense"            "angry"            "age"             
```
---

## 📐 Step 3: Fit Initial Model

Now we can create a standard model and the formula is:
 E(Y|X) = ß0 + ß1*X1 + ß2*X2 + ß3*X3 + ß4*X4+…… 
 
 The command would be: `m0 <- lm(Y ~ X1 +  X2 + X3 + X4, datafile)`


```r
> m0 <- lm(earnk ~ height + weight + sex + ethnicity + education + walk + 
         exercise + smokenow + angry + age, data = Earnings)
```


---

## 🔄 Step 4: Transform Response Variable

Now, I will use `powerTransform()` on our model `m0` to handle skewness, and I will use the value to transform our response (`earnk`) variable.

```r
> library(car)
> powerTransform(m0)

Estimated transformation parameter:
       Y1 
  0.3183301
```


I will use the value **0.32** to transform my `earnk` variable as well as quadratic transformation for the variable `age` . So we create a nested model and include `age^2` . 


```r
> m1 <- lm((earnk^0.32) ~ height + weight + sex + ethnicity + education + walk + exercise + smokenow + tense + age + I(age^2), Earnings)
```


---

## 📉 Step 5: Regression Diagnostics

We can go ahead and use `plot()` command to understand the 4 graphs and see if we have met the **4 assumptions of linear regression**.
We have already established that we have achieved Independence (by removing multicollinearity variables) between our variables in the earlier steps. So, there goes our first assumption of independence. But nevertheless, we will see the other 3 assumptions in the upcoming `plot()` command.
I will be using `ggplot()` for aesthetic purposes.

### ➤ Linearity & Residuals

```r
> ggplot(data = m1, aes(x = .fitted, y = .resid, size = .cooksd)) +
  labs(title = "Fitted vs. Residuals", x= "Fitted Values", y ="Residuals") + 
  geom_point(color = "dark red") +
  geom_abline(slope = 0, intercept = 0, linetype = 2, color = "black") +
  geom_smooth(method = "loess", se = FALSE, color = "navy", lwd = 1.5)
```

<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/Yearly%20Earnings/Images/Fitted%20vs%20Residuals.png" align = "centre" height = "300" width = "600">


This is a `Fitted vs Residual` plot which tells us about linearity. 
All the points are spread across the plot without creating any pattern (which happens when there are non – linear variables present) and the red line **(lowess fit)** is almost flat indicating linearity. There is slight curve which could be because of outliers present in the dataset.

---

### ➤ Homoscedasticity

```r
> ggplot(data = m1, aes(x = .fitted, y = sqrt(abs(.stdresid)), size = .cooksd)) +
  geom_point(color = "steel blue") + 
  geom_smooth(se=FALSE, color = "dark red") +
  labs(title = "Spread Location Plot", x = "Fitted Values", y = "√(Absolute Std Residuals)")

```

<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/Yearly%20Earnings/Images/Homoscedasticity.png" align = "centre" height = "300" width = "600">



This is a Scale Location Plot which tells us about **homoscedasticity**. As you can see, the values are normally spread across the plot indicating that the model has constant variance. 
However, we can confirm this by using `ncvTest()` command in R.

```r
> ncvTest(m1)

Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.45235, Df = 1, p = 0.50122
```

Since the P-Value is > 0.05, we can conclude that there is constant variance in the model.
We can check if we have any influential outliers present in the dataset by `outlierTest()` command.
There is only 1 outlier, which isn’t influential `cooks.distance = 0.0142`.


---

### ➤ Normality

```r
> ggplot(m1, aes(sample = .stdresid)) + 
  stat_qq(color = "blue4") + 
  stat_qq_line(color = "firebrick3", lwd = 1) +
  labs(title = "QQ Plot", x = "Theoretical", y = "Sample")
```

<img src = "https://github.com/sagarsavalgi/multiple-regression-RStudio/blob/main/Yearly%20Earnings/Images/Normality%20-%20QQ%20Plot.png" align = "centre" height = "500" width = "450">


This is **QQ Plot**, and we can evaluate our 4th assumption of Normality. As you can see, it is not in a straight diagonal line, but has a bit of curvature. This could have happened due to some other extreme values, but otherwise, this looks good.



Now, since all the assumptions are met, I would like to conclude my analysis with `summary()`.

```r
> summary(m1)

Call:
lm(formula = (earnk + 1)^0.32 ~ height + weight + sex + ethnicity + 
    education + walk + exercise + smokenow + tense + age + I(age^2), 
    data = Earnings)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.1853 -0.3924  0.0699  0.4181  4.1488 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)       -1.485e+00  4.280e-01  -3.470 0.000533 ***
height             2.262e-02  6.537e-03   3.461 0.000551 ***
weight            -1.409e-03  5.927e-04  -2.377 0.017573 *  
sex1               4.866e-01  4.853e-02  10.025  < 2e-16 ***
ethnicityHispanic -5.388e-02  8.435e-02  -0.639 0.523066    
ethnicityOther     1.215e-02  1.231e-01   0.099 0.921404    
ethnicityWhite     1.491e-03  5.413e-02   0.028 0.978022    
education          9.404e-02  6.647e-03  14.147  < 2e-16 ***
walk               1.834e-03  6.287e-03   0.292 0.770501    
exercise           7.704e-03  7.774e-03   0.991 0.321850    
smokenow          -2.562e-02  3.792e-02  -0.676 0.499395    
tense             -3.883e-03  7.925e-03  -0.490 0.624279    
age                5.055e-02  5.460e-03   9.258  < 2e-16 ***
I(age^2)          -4.359e-04  5.519e-05  -7.899 4.91e-15 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.6747 on 1771 degrees of freedom
  (31 observations deleted due to missingness)
Multiple R-squared:  0.2817,	Adjusted R-squared:  0.2764 
F-statistic: 53.41 on 13 and 1771 DF,  p-value: < 2.2e-16
```

As per the `summary(m1)` with a significant intercept, holding other variables constant, `education` and `age` combined with the `gender` (if male) seems to be **significant variables** in predicting the earnings of an individual, other variables don’t seem to contribute much to the analysis. 
We can also state that since the adjusted R-squared is 0.2764, then _28% of annual earnings can be explained by the regressors_.
Assumptions of linear regression were met, so I prefer the values of the **m1 model** and therefore reject the ‘Null Hypothesis’


---




















