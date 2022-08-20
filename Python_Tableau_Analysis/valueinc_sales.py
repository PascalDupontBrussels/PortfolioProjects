# -*- coding: utf-8 -*-
"""
Created on Fri Jul 22 10:20:16 2022

@author: PascalDupontBrussels
Anaconda Spyder
"""

import pandas as pd

#file_name = pd.read_csv('file.csv') <-- format of read_csv
#data = pd.read_csv('transaction.csv')
data = pd.read_csv('transaction.csv', sep=';')

#Summary of the data 
data.info()

#working with calulations
#Defining variables

CostPerItem = 11.73
SellingPricePerItem = 21.11
NumberOfItemPurchased = 6

#Mathematical Operation on Tableau
ProfitPerItem = 21.11 - 11.73
ProfitPerItem = SellingPricePerItem - CostPerItem

ProfitBytransaction = ProfitPerItem * NumberOfItemPurchased
CostPerTransaction = CostPerItem * NumberOfItemPurchased
SellingPriceperTransaction = SellingPricePerItem * NumberOfItemPurchased

#Costpertransaction Column calculation
#CostPertransaction = CostPeritem * NumberofitemsPurchases
#variable = dataframe['column_name] 
CostPerItem = data['CostPerItem']
NumberOfItemsPurchased = data['NumberOfItemsPurchased']
CostPerTransaction = NumberOfItemsPurchased * CostPerItem

SellingPricePerItem = data['SellingPricePerItem']

#Adding a column to a dataframe
data['CostPerTransaction'] = CostPerTransaction

#Sales per transaction
data['SalesPerTransaction'] = data['SellingPricePerItem'] * data['NumberOfItemsPurchased']

#Profit Calulation = Sales - Cost
data['ProfitByTransaction'] = data['SalesPerTransaction'] - data['CostPerTransaction']

#Markup = (Sales- Cost)/ cost
#data['Markup'] = (data['SalesPerTransaction'] - data['CostPerTransaction']) / data['CostPerTransaction']
data['Markup'] = data['ProfitByTransaction'] / data['CostPerTransaction']

#data.info()
#Rouding Marking
#roundmarkup =  round(data['Markup'],2)
data['Markup'] = round(data['Markup'],2)

#Combining data Fields

myname = 'Pascal ' + 'Dupont'
my_date = 'day' + '-' + 'month' + '-' + 'year'
my_date = data['Day'] + data['Month'] + data['Year'] #not working int+str

#Checking columnsdata type
print(data['Day'].dtype)  

#Change Column Type
day = data['Day'].astype(str)
year = data['Year'].astype(str)

print(year.dtype)  

my_date = day + '-' + data['Month'] + '-' + year

#Add a new column date in our data
data['date'] = my_date

#Using iloc to view specific columns/rows

data.iloc[0]  # views the row with index 0
data.iloc[3]  # views row 3
data.iloc[0:5]  # views first 5 row
data.iloc[-4:]  # views the four last rows
data.head(5) # brings  in first 5 rows
data.iloc[:,2] # all rows column 2
data.iloc[4,2] # row 4 column 2

#Using Split to split the ClientKeywords Field
#new_var = column.str.split('sep', expand = True)
split_col = data['ClientKeywords'].str.split(',', expand = True)

#Creating new columns forthe split columns in ClientKeywords
data['ClientAge'] = split_col[0]
data['ClientType'] = split_col[1]
data['LengthOfContract'] = split_col[2]

#Using the replace function
data['ClientAge'] = data['ClientAge'].str.replace('[', '') 
data['LengthOfContract'] = data['LengthOfContract'].str.replace(']', '') 

data['ClientAge'] = data['ClientAge'].str.replace("'", '')
data['ClientType'] = data['ClientType'].str.replace("'", '')                                                  
data['LengthOfContract'] = data['LengthOfContract'].str.replace("'", '')

#Using the lower function itemsto lowercase
data['ItemDescription'] = data['ItemDescription'].str.lower()

#How to Merge files
#Bringing a new dataset
season = pd.read_csv('value_inc_seasons.csv', sep=';')

#Merging files: merge_dataframe = pd.merge(old_dataframe, new_dataframe, on = 'key'. (here->Month))
data = pd.merge(data, season, on ='Month')

#Dropping Columns
#dataframe = dataframe.drop('columns name' , axis =1)
#dataframe = dataframe.drop(['columns name1', 'columns name2', 'columns name3'] , axis =1)
data = data.drop('Year', axis = 1)
data = data.drop(['Month', 'Day', 'ClientKeywords'], axis = 1)

#Export into a .csv
data.to_csv('ValueInc_Cleaned.csv', index = False)













