# -*- coding: utf-8 -*-
"""
Created on Mon Aug  1 08:38:42 2022

@author: PascalDupontBrussels
Anaconda Spyder

"""

import json
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

#method 1 to read json data
json_file = open('loan_data_json.json')
data = json.load(json_file)

#method 2 to read json data
with open('loan_data_json.json') as json_file:
    data = json.load(json_file)

#transform to dataframe
loandata = pd.DataFrame(data)

#finding unique values for the purpose column
loandata['purpose'].unique()

#describe the data
loandata.describe()

#describe the data for a specific column
loandata['int.rate'].describe()
loandata['fico'].describe()
loandata['dti'].describe()

# using exp() exponent toget the annual income
#1_income = loandata['log.annual.inc']
#2_+_income = np.exp(loandata['log.annual.inc'])
income = np.exp(loandata['log.annual.inc'])
loandata['annualincome'] = income

#working with arrays
# creation
arr = np.array([1, 2, 3, 4]) 

#0D array
arr = np.array(43)

#1D array
arr = np.array([1, 2, 3, 4])

#2D array
arr = np.array([[1,2,3], [4,5,6]])

#working with IF statements

a = 40
b = 500
c = 30

if b > a and b < c:
     print('b is greater than a but less than c')
elif b > a and b > c:
    print('b is greater than a and c')
else:
     print('no condition met') 
    
# FICO score 
fico = 700

# fico >= 300 and < 400: 'Very Poor'
# fico >= 400 and ficoscore < 600: 'Poor'
# fico >= 601 and ficoscore < 660: 'Fair'
# fico >= 660 and ficoscore < 780: 'Good'
# fico >=780: 'Excellent'    

if fico >= 300 and fico < 400:
    ficocat = 'Very Poor'
elif fico >= 400 and fico < 600:
    ficocat = 'Poor'
elif fico >= 601 and fico < 660:
    ficocat = 'Fair'
elif fico >= 660 and fico < 780:
    ficocat = 'Good'
elif fico >= 780:
    ficocat = 'Excellent'
else:
    ficocat = 'Unknown'
print(ficocat)
    
#applying for loops to loandata

#using first 10

for x in range(0,10):
    category =loandata['fico'][x]     
    if category >= 300 and category < 400:
        cat = 'Very Poor'
    elif category >= 400 and category < 600:
        cat = 'Poor'
    elif category >= 601 and category < 660:
        cat = 'Fair'
    elif category >= 660 and category < 700:
        cat = 'Good'
    elif category >= 700:
        cat = 'Excellent'
    else:
        cat = 'Unknown'     
 
#applying for loops to all loandata'fico'

ficocat =[]
length = len(loandata)

for x in range(0,length):
    category =loandata['fico'][x]     
    if category >= 300 and category < 400:
        cat = 'Very Poor'
    elif category >= 400 and category < 600:
        cat = 'Poor'
    elif category >= 601 and category < 660:
        cat = 'Fair'
    elif category >= 660 and category < 700:
        cat = 'Good'
    elif category >= 700:
        cat = 'Excellent'
    else:
        cat = 'Unknown'
    ficocat.append(cat)   
    
ficocat = pd.Series(ficocat)    
        
loandata['fico.category'] = ficocat

#testing error

ficocat =[]
length = len(loandata)

for x in range(0,length):
    category ='red'

    try:    
        if category >= 300 and category < 400:
            cat = 'Very Poor'
        elif category >= 400 and category < 600:
            cat = 'Poor'
        elif category >= 601 and category < 660:
            cat = 'Fair'
        elif category >= 660 and category < 700:
            cat = 'Good'
        elif category >= 700:
            cat = 'Excellent'
        else:
            cat = 'Unknown'
    except:
         cat = 'Error_Unknown'
         
    ficocat.append(cat)   
    
ficocat = pd.Series(ficocat)    
        
loandata['fico.category'] = ficocat

#df.loc as conditional statements
#df.loc[df[columnName] condition, new column name] = 'value if condition is met

#for interst rate, a new column is wanted. rate> 0.12 (12%) then high, else low(interest rate)

loandata.loc[loandata['int.rate'] > 0.12, 'int.rate.type'] = 'High'
loandata.loc[loandata['int.rate'] <= 0.12, 'int.rate.type'] = 'Low'

#number of loans/rows by fico.category (poor, etc)

catplot = loandata.groupby(['fico.category']).size()
catplot.plot.bar(color = 'green', width = 0.1)
plt.show()


purposeCount = loandata.groupby(['purpose']).size()
catplot.plot.bar(color = 'red', width = 0.2)
plt.show()

#scatter plots (needs an x and y values of variable)

ypoint = loandata['annualincome']
xpoint = loandata['dti']
plt.scatter(xpoint, ypoint, color ='#4caf50')
plt.show()

# writing to .csv
loandata.to_csv('loan_cleaned.csv', index= True)


























































    
    
    
    