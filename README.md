# Applying KNN to the Iris dataset 

### Introduction

The Iris dataset is a classic dataset in machine learning and statistics, often used for classification tasks. It contains measurements of **four features** (sepal length, sepal width, petal length, and petal width) for 150 iris flowers, belonging to three species: **Setosa**, **Versicolor**, and **Virginica**. The goal of this analysis is to explore the dataset, preprocess the data, and apply the KNN algorithm to classify iris flowers based on their measurements.

#### TL;DR 

- The optimal value of k for this dataset is 5, achieving an accuracy of 96.67%.

- `Petal.Length` and `Petal.Width` are the most discriminative features for classification.

- The misclassifications occurred primarily between `Versicolor` and `Virginica`, which have overlapping feature values.

### DATA EXPLORATION 

- The dataset was explored using summary statistics, visualizations, and descriptive analysis with the `Hmisc` and `ggplot2` packages. 
  <details>
  <summary> Summary - Visualizations </summary>

  ![image](https://github.com/user-attachments/assets/c749b165-5e1c-4574-baa9-540b4b334d40)
 
</details>

- The numeric features were normalized using the scale() function to ensure that all features contributed equally to the distance calculations in KNN. The normalization formula used was:
Scaled value=x−mean(x)/sd(x)
```
iris_normalize <- iris
iris_normalize[, -5] <- scale(iris[, -5])
```

### MODEL

- The dataset was split into a training set (60% of the data, used to train the model) and test set (40% of the data, used to evaluate performance
```
set.seed(9999)
ind <- sample(2, nrow(iris_normalize), replace=TRUE, prob=c(0.6, 0.4))
train <- iris_normalize[ind == 1, ]
test <- iris_normalize[ind == 2, ]
```  
- The KNN algorithm was applied to classify the iris species:
  -  The `knn()` function from the `class` package was used to predict the species for different values of k (from 1 to 50).
  -  For each k, the accuracy of the model was calculated as the percentage of correct predictions on the test set.
```
# Initialize variables for KNN
KnnTestPrediction <- list()
accuracy <- numeric()

# -- RUN KNN

# Run KNN for different values of k
for(k in 1:50) {
  KnnTestPrediction[[k]] <- knn(train[, -5], test[, -5], train$Species, k, prob=TRUE)
  accuracy[k] <- sum(KnnTestPrediction[[k]] == test$Species) / length(test$Species) * 100
}
```

### PERFORMANCE

- Accuracy Plot: The plot of accuracy vs. k showed that accuracy initially increased with k, reached a peak, and then plateaued or decreased. The highest accuracy was achieved at k=5.
  <details>
  <summary> Accuracy </summary>

  ![image](https://github.com/user-attachments/assets/5a3a7564-b868-4814-9998-caace94b797d)
</details>

- Confusion Matrix: For k=5, the confusion matrix indicated:
```
          Predicted
Actual     Setosa Versicolor Virginica
Setosa      20        0         0
Versicolor   0        18        2
Virginica    0         1        19
```

- Optimal k: The optimal value of k was 5, with an accuracy of 96.67%
