library(pacman)
pacman::p_load("Hmisc", "ISLR", "ggplot2", "class")

# -- DATA EXPLORATION

summary(iris)

describe(iris)

str(iris)

# Histograms by group
ggplot(iris, aes(x=Sepal.Length)) + geom_histogram() + facet_grid(~Species) + theme_bw()
ggplot(iris, aes(x=Sepal.Width)) + geom_histogram() + facet_grid(~Species) + theme_bw()
ggplot(iris, aes(x=Petal.Length)) + geom_histogram() + facet_grid(~Species) + theme_bw()
ggplot(iris, aes(x=Petal.Width)) + geom_histogram() + facet_grid(~Species) + theme_bw()

# Scatterplots by species
qplot(Sepal.Length, Sepal.Width, data=iris, color=Species)
qplot(Petal.Length, Petal.Width, data=iris, color=Species)

# -- DATA NORMALIZATION

# Scale: (x - mean(x)) / sd(x)
iris_normalize <- iris
iris_normalize[, -5] <- scale(iris[, -5])

# -- TRAIN AND TEST MODEL 

set.seed(9999)
ind <- sample(2, nrow(iris_normalize), replace=TRUE, prob=c(0.6, 0.4))
train <- iris_normalize[ind == 1, ]
test <- iris_normalize[ind == 2, ]

# Initialize variables for KNN
KnnTestPrediction <- list()
accuracy <- numeric()

# -- RUN KNN

# Run KNN for different values of k
for(k in 1:50) {
  KnnTestPrediction[[k]] <- knn(train[, -5], test[, -5], train$Species, k, prob=TRUE)
  accuracy[k] <- sum(KnnTestPrediction[[k]] == test$Species) / length(test$Species) * 100
}

# Confusion matrix for a specific k (e.g., k=1)
k <- 1
table(test$Species, KnnTestPrediction[[k]])

# Accuracy for a specific k (e.g., k=1)
sum(KnnTestPrediction[[k]] == test$Species) / length(test$Species) * 100

# Plot accuracy for different k values
plot(accuracy, type="b", col="blue", cex=1, pch=1,
     xlab="k", ylab="Accuracy", 
     main="Accuracy by k")

# Vertical line to mark the maximum accuracy
abline(v=which(accuracy == max(accuracy)), col="red", lwd=1.5)

# Grey horizontal lines for the maximum and minimum accuracy
abline(h=max(accuracy), col="grey", lty=2)
abline(h=min(accuracy), col="grey", lty=2)
