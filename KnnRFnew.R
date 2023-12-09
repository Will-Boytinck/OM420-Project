library(MASS)
library(tidyverse)
library(class)
library(readxl)
library(randomForest)

#Binary data here 

all_data<- read.csv("projectData.csv")
all_data$Produce_FruitDV <- factor(all_data$Produce_FruitDV)

percen_train <-  1/2
all_data.training_indices <- sample(1:nrow(all_data), size = percen_train * nrow(all_data))
all_data.train <- all_data[all_data.training_indices,]
all_data.rest <- all_data[-all_data.training_indices,]

all_data.validation_indices <- sample(1:nrow(all_data.rest), size = nrow(all_data.rest)*percen_train)
all_data.val = all_data.rest[all_data.validation_indices,]
all_data.test <- all_data.rest[-all_data.validation_indices,]


#k = 1
k1 <- knn(all_data.train[,-17],all_data.val[,-17], all_data.train[,17], k =1)
predResults<- table(all_data.val[,17],k1)
1-sum(diag(predResults))/sum(predResults)

# Random Forest Begins here
randomForestData <- read.csv("projectData.csv") #this one is using binary variable, will try this with occurences to see if that makes it better
randomForestData$Produce_FruitDV <- factor(randomForestData$Produce_FruitDV)
randomforest.training_indices <- sample(1:nrow(randomForestData), size = percen_train * nrow(randomForestData))
randomForestData.train <- randomForestData[randomforest.training_indices,]
randomForestData.rest <- randomForestData[-randomforest.training_indices,]

randomforest.validation_indices <- sample(1:nrow(randomForestData.rest), size = nrow(randomForestData.rest)*percen_train)
randomForestData.val = randomForestData.rest[randomforest.validation_indices,]
randomForestData.test <- randomForestData.rest[-randomforest.validation_indices,]

randomforestmodel16try <- randomForest(Produce_FruitDV~.-Produce_FruitDV, data = randomForestData.train, mtry = 16, importance=T)

randomforestmodel16try.modelprediction <- predict(randomforestmodel16try,randomForestData.val)
randomforestmodel16try.modelresults <- table(randomForestData.val$Produce_FruitDV, randomforestmodel16try.modelprediction)
randomforestmodel16try.error_rate <- 1-sum(diag(randomforestmodel16try.modelresults))/sum(randomforestmodel16try.modelresults)


randomforestmodel4try <- randomForest(Produce_FruitDV~.-Produce_FruitDV, data = randomForestData.train, mtry = 4, importance=T)

randomforestmodel4try.modelprediction <- predict(randomforestmodel4try,randomForestData.val)
randomforestmodel4try.modelresults <- table(randomForestData.val$Produce_FruitDV, randomforestmodel4try.modelprediction)
randomforestmodel4try.error_rate <- 1-sum(diag(randomforestmodel4try.modelresults))/sum(randomforestmodel4try.modelresults)


## Occurrences data begins below
count_data<- read.csv("Count Occurences_Query.csv")
count_data$Produce_FruitDV <- factor(count_data$Produce_FruitDV)

percen_train <-  1/2
count_data.training_indices <- sample(1:nrow(count_data), size = percen_train * nrow(count_data))
count_data.train <- count_data[count_data.training_indices,]
count_data.rest <- count_data[-count_data.training_indices,]

count_data.validation_indices <- sample(1:nrow(count_data.rest), size = nrow(count_data.rest)*percen_train)
count_data.val = count_data.rest[count_data.validation_indices,]
count_data.test <- count_data.rest[-count_data.validation_indices,]



#knn models
k10 <- knn(count_data.train[,-17],count_data.val[,-17], count_data.train[,17], k =10)
k10predResults<- table(count_data.val[,17],k10)
k10_error <- 1-sum(diag(k10predResults))/sum(k10predResults)

#tried 100,90 it is too big 
k55 <- knn(count_data.train[,-17],count_data.val[,-17], count_data.train[,17], k =55)
k55predResults<- table(count_data.val[,17],k55)
k55_error <- 1-sum(diag(k55predResults))/sum(k55predResults)

k45 <- knn(count_data.train[,-17],count_data.val[,-17], count_data.train[,17], k =45)
k45predResults<- table(count_data.val[,17],k45)
k45_error <- 1-sum(diag(k45predResults))/sum(k45predResults)


k50 <- knn(count_data.train[,-17],count_data.val[,-17], count_data.train[,17], k =50)
k50predResults<- table(count_data.val[,17],k50)
k50_error <- 1-sum(diag(k50predResults))/sum(k50predResults)


#Randomforest begins below

count_randomforest <- randomForest(Produce_FruitDV~.-Produce_FruitDV, data = count_data.train, mtry = 4, importance=T)

count_model.prediction <- predict(count_randomforest,count_data.val)
count_model.results <- table(count_data.val$Produce_FruitDV, count_model.prediction)
1-sum(diag(count_model.results))/sum(count_model.results)

# Against test set
count_model.prediction_testset <- predict(count_randomforest,count_data.test)
count_model.results_testset <- table(count_data.test$Produce_FruitDV, count_model.prediction_testset)
1-sum(diag(count_model.results_testset))/sum(count_model.results_testset)

#bagging
count_randomforest_bagged <- randomForest(Produce_FruitDV~.-Produce_FruitDV, data = count_data.train, mtry = 16, importance=T)
count_model.prediction_bagged <- predict(count_randomforest_bagged,count_data.val)
count_model.results_bagged <- table(count_data.val$Produce_FruitDV, count_model.prediction_bagged)
count_model.bagged_error <- 1-sum(diag(count_model.results_bagged))/sum(count_model.results_bagged)


#knn continuous data but picking certain columns (Day_of_Week,Grocery_Purchases,Dairy_Purchases,Meat_Purchases,Deli_Purchases,Produce_FruitDV)
subset_count_data<- read.csv("Count Occurences_subset.csv")

subset_count_data$Produce_FruitDV <- factor(subset_count_data$Produce_FruitDV)
subset_count_data.training_indices <- sample(1:nrow(subset_count_data), size = percen_train * nrow(subset_count_data))
subset_count_data.train <- subset_count_data[subset_count_data.training_indices,]
subset_count_data.rest <- subset_count_data[-subset_count_data.training_indices,]

subset_count_data.validation_indices <- sample(1:nrow(subset_count_data.rest), size = nrow(subset_count_data.rest)*percen_train)
subset_count_data.val = subset_count_data.rest[subset_count_data.validation_indices,]
subset_count_data.test <- subset_count_data.rest[-subset_count_data.validation_indices,]

subset_count_data.k7 <- knn(subset_count_data.train[,-17],subset_count_data.val[,-17], subset_count_data.train[,17], k =7)
subset_count_data.k7_predResults<- table(subset_count_data.val[,17],subset_count_data.k7)
subset_count_data.k7_error <- 1-sum(diag(subset_count_data.k7_predResults))/sum(subset_count_data.k7_predResults)


#KNN model with no Produce Purchases
no_produce_purchases_count<- read.csv("Count Occurences_No 30.csv")
no_produce_purchases_count$Produce_FruitDV <- factor(no_produce_purchases_count$Produce_FruitDV)
no_produce_purchases_count.training_indices <- sample(1:nrow(no_produce_purchases_count), size = percen_train * nrow(no_produce_purchases_count))
no_produce_purchases_count.train <- no_produce_purchases_count[no_produce_purchases_count.training_indices,]
no_produce_purchases_count.rest <- no_produce_purchases_count[no_produce_purchases_count.training_indices,]

no_produce_purchases_count.validation_indices <- sample(1:nrow(no_produce_purchases_count.rest), size = nrow(no_produce_purchases_count.rest)*percen_train)
no_produce_purchases_count.val = no_produce_purchases_count.rest[no_produce_purchases_count.validation_indices,]
no_produce_purchases_count.test <- no_produce_purchases_count.rest[-no_produce_purchases_count.validation_indices,]

no_produce.k55 <- knn(no_produce_purchases_count.train[,-16],no_produce_purchases_count.val[,-16], no_produce_purchases_count.train[,16], k =55)
no_produce.k55.predResults<- table(no_produce_purchases_count.val[,16],no_produce.k55)
no_produce.k55_error <- 1-sum(diag(no_produce.k55.predResults))/sum(no_produce.k55.predResults)

no_produce.k45 <- knn(no_produce_purchases_count.train[,-16],no_produce_purchases_count.val[,-16], no_produce_purchases_count.train[,16], k =45)
no_produce.k45.predResults<- table(no_produce_purchases_count.val[,16],no_produce.k45)
no_produce.k45_error <- 1-sum(diag(no_produce.k45.predResults))/sum(no_produce.k45.predResults)


no_produce.k15 <- knn(no_produce_purchases_count.train[,-16],no_produce_purchases_count.val[,-16], no_produce_purchases_count.train[,16], k =15)
no_produce.k15.predResults<- table(no_produce_purchases_count.val[,16],no_produce.k15)
no_produce.k15_error <- 1-sum(diag(no_produce.k15.predResults))/sum(no_produce.k15.predResults)
