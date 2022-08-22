# -*- coding: utf-8 -*-
"""
Created on Wed Aug 10 07:51:45 2022

@author: PascalDupontBrussels
Anaconda Spyder
"""

import pandas as pd
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

#reading excel or xlsx files
data = pd.read_excel('articles.xlsx')

#summary of the data
data.describe()

#summary of the columns
data.info()

#counting the number of articles per source
# format of the groupby: df.groupby([''])
# format of the groupby: df.groupby(['column to group'])
# format of the groupby: df.groupby(['column to group']) ['column to count or to sum']
# format of the groupby: df.groupby(['column to group']) ['column to count'].count()
# format of the groupby: df.groupby(['column to group']) ['column to sum'].sum()

data.groupby(['source_id'])['article_id'].count().sort_values(ascending=True)

#number of reaction to the article by publisher
data.groupby(['source_id'])['engagement_reaction_count'].sum().sort_values(ascending=True)

#dropping a column
data = data.drop('engagement_comment_plugin_count' , axis=1)

#functions in Python
def thisfunction():
    print('this is my first function')
    
thisfunction()    

#this is fuction with variables
def aboutMe(name, surname, location):
    print('this is '+name+' my surname is '+surname+' I am from '+location)
    return name, surname, location
    
a = aboutMe('Pascal', 'Dupont', 'Brussels')    

#using FOR loops in function
def favfood(food):
    for x in food:
        print('top food is '+x)  

fastfood = ['burgers' , 'pizza' , 'pie']

favfood(fastfood)

#creating a keyword flag
keyword = 'crash'

#let's create  a for loop  to isolate each title row for 10 lines

keyword_flag = []
for x in range(0,10):
    heading = data['title'][x]
    if keyword in heading:
        flag = 1
    else:
        flag = 0
    keyword_flag.append(flag)
    
#let's create  a for loop  to isolate each title row forfull lengh of the rows    
keyword = 'crash'

length = len(data)  
keyword_flag = []
for x in range(0,length):
    heading = data['title'][x]
    if keyword in heading:
        flag = 1
    else:
        flag = 0
    keyword_flag.append(flag)
    
 #creating a function       
def keywordflag(keyword):    
     length = len(data)  
     keyword_flag = []
     for x in range(0,length):
         heading = data['title'][x]
         try:
             if keyword in heading:
                 flag = 1
             else:
                 flag = 0
         except:
             flag = 0
         keyword_flag.append(flag)
     return keyword_flag 

keywordflag = keywordflag('murder')    


#creating new column in data frame
data['keyword_flag'] = pd.Series(keywordflag)

SentimentIntensityAnalyzer
sent_int = SentimentIntensityAnalyzer()

text = data['title'][15]
sent = sent_int.polarity_scores(text)

neg = sent['neg']
pos = sent['pos']
neu = sent['neu']

#adding a FOR loop to extract sentiment per title
title_neg_sentiment = []
title_pos_sentiment = []
title_neu_sentiment = []

length = len(data)

for x in range(0,length):
    try:
        text = data['title'][x]
        sent_int = SentimentIntensityAnalyzer()
        sent = sent_int.polarity_scores(text)
        neg = sent['neg']
        pos = sent['pos']
        neu = sent['neu']
    except:
        neg = 0
        pos = 0
        neu = 0
    title_neg_sentiment.append(neg)
    title_pos_sentiment.append(pos)
    title_neu_sentiment.append(neu)
    
#changer col list to series
title_neg_sentiment = pd.Series(title_neg_sentiment)
title_pos_sentiment = pd.Series(title_pos_sentiment)
title_neu_sentiment = pd.Series(title_neu_sentiment)

#add new cols to data frame
data['title_neg_sentiment'] = title_neg_sentiment
data['title_pos_sentiment'] = title_pos_sentiment
data['title_neu_sentiment'] = title_neu_sentiment

#writing the data to .xlsx
#data.to_excel('blogme_clean.xlsx', index = False)
data.to_excel('blogme_clean.xlsx', sheet_name='blogmedata', index = False)



    
    
    
    

    




































 
 


   



























