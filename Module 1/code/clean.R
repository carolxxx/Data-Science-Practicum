############################## Read data ##############################
library(readr)
bodyfat <- read_csv("data/BodyFat.csv", col_types = cols(IDNO = col_skip()))



############################## Select model ##############################

##### The below table shows that only ‘Density’ has a significant linear
##### relationship with ‘Fat’, which proves Siri's equation to be correct.

summary(lm.fat <- lm(BODYFAT ~ .,data = bodyfat))
#Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
#(Intercept)  4.190e+02  9.802e+00  42.750   <2e-16 ***
#DENSITY     -3.816e+02  7.559e+00 -50.481   <2e-16 ***
#AGE          1.078e-02  8.808e-03   1.224    0.222    
#WEIGHT       1.197e-02  1.467e-02   0.816    0.415    
#HEIGHT      -1.782e-02  3.019e-02  -0.590    0.556    
#ADIPOSITY   -5.493e-02  8.113e-02  -0.677    0.499    
#NECK        -2.062e-02  6.427e-02  -0.321    0.749    
#CHEST        2.993e-02  2.856e-02   1.048    0.296    
#ABDOMEN      2.260e-02  3.016e-02   0.749    0.454    
#HIP          1.611e-02  4.023e-02   0.401    0.689    
#THIGH        1.354e-03  3.980e-02   0.034    0.973    
#KNEE        -3.978e-02  6.705e-02  -0.593    0.554    
#ANKLE       -7.170e-02  6.073e-02  -1.181    0.239    
#BICEPS      -6.291e-02  4.688e-02  -1.342    0.181    
#FOREARM      4.324e-02  5.447e-02   0.794    0.428    
#WRIST        3.640e-02  1.480e-01   0.246    0.806 


##### There are several significant predictors for the response variable ‘Density’.
summary(lm.density <- lm(DENSITY ~ ., data = bodyfat[-42,-1]))
plot(lm.density, which = 4)
abline(h = 4/(252-15), lty = 2)
summary(lm.density1 <- lm(DENSITY ~ ., data = bodyfat[-42,-1]))
layout(matrix(1:4, ncol = 2))
plot(lm.density1)

##### The 39th gay weights 363 ponds and the 42nd gay is only 29.50 inches tall
##### They are considered to be outliers

# BODYFAT DENSITY   AGE WEIGHT HEIGHT ADIPOSITY  NECK CHEST ABDOMEN   HIP THIGH  KNEE
#   33.8  1.0202    46 363.15  72.25      48.9  51.2 136.2   148.1 147.7  87.3  49.1
#   31.7  1.0250    44 205.00  29.50      29.9  36.6 106.0   104.3 115.5  70.6  42.5

layout(1)
plot(lm.density1, which = 4)
abline( h = 4/(251-15), col = 'red', lty = 2)
summary(lm.density2 <- lm(DENSITY ~ ., data = bodyfat[-c(39,42),-1]))

layout(matrix(1:4, ncol = 2))
plot(lm.density2)

library(car)
outlierTest(lm.density2)


##### the 182nd and 224th points both have relatively large density, 
##### which leads to small body fat percentage compare the the fitted value.
# 182 bodyfat = 0.0
# 224 bodyfat = 6.1

# Multivariate Imputation by Chained Equations

bodyfat2 <- bodyfat
bodyfat2[c(182, 224), 1] <- NA

library(mice)
set.seed(12345)
miceMod <- mice(bodyfat2, method="rf")
miceOutput <- complete(miceMod)
miceOutput[c(182,224),]

bodyfat.clean <- miceOutput[-c(39,42), ]
write_csv(bodyfat.clean, "data/BodyFatClean.csv")
