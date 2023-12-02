from itertools import combinations
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn import metrics
import matplotlib.pyplot as plt

# TODO:
# why are all the accuracys either 75 or 85
# Analyze what predictors are the most efficient
# ALSO remember: "accuracy" just means how the model is at predicting
    # if we want to know what combination of predictors you'll have to dig deeper
    # # {{True positive predictions in the cnf matrix}}

# References I used for this model:
# 1. https://www.statology.org/logistic-regression-python/
# 2. https://realpython.com/logistic-regression-python/
# 3. https://towardsdatascience.com/logistic-regression-using-python-sklearn-numpy-mnist-handwriting-recognition-matplotlib-a6b31e2b166a


sure_fire = []
sure_fire2 = []
accuracy_list = []

def main():
    data = load_data()
    for i in range(2,9):
        combinations = regression_combinations(i)
        for combination in combinations:
            create_fit(combination, data)
    
    analyze_fits()
    
    

def regression_combinations(i) -> list:
    '''
    using our binary values, define an array s.t it contains a nested set
    of combinations with nBeta = 2-8
    15C2 = 105 inherently unique and non repetive sets
    15C3 = 455 
    15C4 = 1365
    15C5 = 3003
    15C6 = 5005
    15C7 = 6435
    15C8 = 6435
    '''
    # our combination array to be populated
    list_combinations = []
    # define column name array
    # index+1 is the map to the excel data
    COLUMN_NAMES = ['Grocery', 'Dairy', 'Tobacco', 'Produce', 'Meat',
                    'Health', 'Deli', 'GM', 'Floral', 'Bakery', 
                    'Water', 'Bulk_Foods', 'Photo', 'Frozen_food', 'Pets']
    # define predictor
    PREDICTOR = 'Produce_FruitDV'
    
    # create combinations with the predictor included
    # nBeta = i
    list_combinations = [combo + (PREDICTOR,) for combo in combinations(COLUMN_NAMES, i)]
   
    # return combinations to be used later
    print("Combinations created...")
    return list_combinations
                    
def load_data():
    '''
    load the data, return it
    '''
    # read the file (data from binaryQuery.txt)
    data_file = 'binaryQuery.xlsx'
    data = pd.read_excel(data_file)
    # return the data
    print("Data loaded in...")
    return data

def partition_data(X, Y):
    '''
    partition the data into training and test sets
    return them
    '''
    #split the dataset into training (70%) and testing (30%) sets
    X_train,X_test,y_train,y_test = train_test_split(X,Y,test_size=0.3,random_state=0)
    return X_train,X_test,y_train,y_test

def make_map(num_predictors, data, combination):
    '''
    with the current amount of predictors, map
    the data accordingly
    this code is ugly, please disregard
    '''
    
    # TODO: are we mapping and getting the data right? Everything is going 
    # almost too fast.
    
    if num_predictors == 2:
        X = data[[str(combination[0]), str(combination[1])]]
        Y = data[str(combination[2])] # predictor
    
    elif num_predictors == 3:
        X = data[[str(combination[0]), str(combination[1]), str(combination[2])]]
        Y = data[str(combination[3])] 
    
    elif num_predictors == 4:
        X = data[[str(combination[0]), str(combination[1]), str(combination[2]), str(combination[3])]]
        Y = data[str(combination[4])]      
    
    elif num_predictors == 5:
        X = data[[str(combination[0]), str(combination[1]), str(combination[2]), str(combination[3]), str(combination[4])]]  
        Y = data[str(combination[5])]
    
    elif num_predictors == 6:
        X = data[[str(combination[0]), str(combination[1]), str(combination[2]), str(combination[3]), str(combination[4]), str(combination[5])]]
        Y = data[str(combination[6])]
       
    elif num_predictors == 7:
        X = data[[str(combination[0]), str(combination[1]), str(combination[2]), str(combination[3]), str(combination[4]), str(combination[5]), str(combination[6])]]
        Y = data[str(combination[7])]
        
    elif num_predictors == 8:
        X = data[[str(combination[0]), str(combination[1]), str(combination[2]), str(combination[3]), str(combination[4]), str(combination[5]), str(combination[6]), str(combination[7])]]    
        Y = data[str(combination[8])]
        
    return X,Y


 # potential params:
    # fit_intercept=Boolean (true by default)
    # class_weight=None     (balanced by default)
    # solver                ('newton-cg'. 'lbfgs', 'sag', 'saga')
    # max_iter              (100 by default)
    # intercept_scaling     (1.0 by default)
    # penalty               (l2 by default --> ('l1', 'elastic-net', 'none'))
    
    #cnf_matrix = metrics.confusion_matrix(Y_test, Y_prediction)
    #print(cnf_matrix)

def create_fit(combination, data):
    '''
    for each combination, create a logistic fit.
    return the results
    '''
    # 1. map the data according to combination
    num_predictors = len(combination)-1
    X,Y = make_map(num_predictors,data,combination)
    X_train,X_test,Y_train,Y_test = partition_data(X,Y)
    
    # create the model
    model = LogisticRegression(class_weight=None, solver='liblinear', max_iter=100000,
    intercept_scaling=2.0, C=0.05, dual=True, multi_class='ovr')
    model.fit(X_train, Y_train)
    Y_prediction = model.predict(X_test)
    accuracy = metrics.accuracy_score(Y_test, Y_prediction)
    t = (int(accuracy*100))
    accuracy_list.append(t)
    
    #print(f"Accuracy: {accuracy}")
    if accuracy >= 0.85:
        sure_fire.append(combination)
        
    if accuracy >= 0.90:
        sure_fire2.append(combination)
        

def analyze_fits():
    '''
    for each fit, graph the accuracy using matplotlib
    '''
    plt.plot(accuracy_list)
    plt.savefig('clr.png')
    plt.show
    


main()