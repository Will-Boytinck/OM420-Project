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


#bagging
count_randomforest_bagged <- randomForest(Produce_FruitDV~.-Produce_FruitDV, data = count_data.train, mtry = 17, importance=T)
count_model.prediction_bagged <- predict(count_randomforest_bagged,count_data.val)
count_model.results_bagged <- table(count_data.val$Produce_FruitDV, count_model.prediction_bagged)
count_model.bagged_error <- 1-sum(diag(count_model.results_bagged))/sum(count_model.results_bagged)


#knn continuous data but picking certain columns, this will not run too many ties so that means they are too close together when using (Day_of_Week,Grocery_Purchases,Dairy_Purchases,Meat_Purchases,Deli_Purchases,Produce_FruitDV)
subset_count_data<- select(count_data,Tobacco_Purchases,GM_Purchases,Floral_Purchases,Grocery_Purchases, Produce_FruitDV)
#this also will not run, think of different columns that we could use to pick, even with random subsets it still will not run

sample(1:ncol(count_data), size = 4)

subset_count_data.training_indices <- sample(1:nrow(subset_count_data), size = percen_train * nrow(subset_count_data))
subset_count_data.train <- subset_count_data[subset_count_data.training_indices,]
subset_count_data.rest <- subset_count_data[-subset_count_data.training_indices,]

subset_count_data.validation_indices <- sample(1:nrow(subset_count_data.rest), size = nrow(subset_count_data.rest)*percen_train)
subset_count_data.val = subset_count_data.rest[subset_count_data.validation_indices,]
subset_count_data.test <- subset_count_data.rest[-subset_count_data.validation_indices,]

subset_count_data.k25 <- knn(subset_count_data.train[,-5],subset_count_data.val[,-5], subset_count_data.train[,5], k =1)
subset_count_data.k25_predResults<- table(subset_count_data.val[,5],subset_count_data.k25)
subset_count_data.k25_error <- 1-sum(diag(subset_count_data.k25_predResults))/sum(subset_count_data.k25_predResults)