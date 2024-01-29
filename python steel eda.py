
# eda and datapreprocessing on steelset
import pandas as pd
steel = pd.read_csv(r"C:\Users\ajay a j\Desktop\steel project\steelset.csv")
# basic data understanding
import numpy as np
infoofset=steel.info()
# there are 33045 rows across 10 columns
steel.describe()
# describe gives the statisticl insights 
# unique values
steel['Type'].value_counts()
#FULL LENGTH-30477 ,CAB -1290,COIL - 615,CRSD -369,SHORT LENGTH -294
steel['Grade'].value_counts()
#500D-28460, 550D - 4585

# eda - business moments
# 1st moment business decisions / Measures of central tendency

#mean- avg value
qty_mean = steel['Quantity'].mean()
 # mean of quantity is 5.92
rate_mean = steel['Rate'].mean() 
 # mean of rate is 48521.11
 
 # median - centre most value
qty_median = steel['Quantity'].median()
# median of quantity is 3.9
rate_median = steel['Rate'].median() 
  #median of rate is 45700
  
  # mode - most repeated value
Type_mode = steel['Type'].mode()
#full length  type of steel is sold more
Length_mode = steel['Length'].mode()
#  steel of 12m lenght is sold more

# 2nd moment business decisions / Measures of dispersion
# standard deviation

qty_std = steel['Quantity'].std()
# quantity column has a std dev of 6.66 shows data is dispersed acccoring to the values
rate_std = steel['Rate'].std() 
#rate column has a std dev of 9641.88 shows data is widely dispersed

# variance

qty_var = steel['Quantity'].var()
# quantity column has a variance of 44.46 shows data is dispersed acccoring to the values
rate_var = steel['Rate'].var() 
#rate column has a variance of 92965999.36 shows data is widely dispersed


# 3rd moment business decisions / Measures of symmetry
# skewness

qty_skew = steel['Quantity'].skew()
# quantity column has a skewness of 2.2 shows it is  positively skewed  and unsymmetric
rate_std = steel['Rate'].skew() 
#rate column has a skewness of 0.7 shows rate is normally distributed and symmetric

# 4th moment business decisions / Measures of tailedness
# kurtosis

qty_kurt = steel['Quantity'].kurtosis()
# quantity column has a kurtosis of 5 shows it has high  tails  and leptokurtic
rate_kurt = steel['Rate'].kurtosis() 
#rate column has a kurtosis of 0 shows rate is mesokurtic and and has no tails 

# Graphical representation

import matplotlib.pyplot as plt

import seaborn as sns

import scipy.stats as stats
import pylab

prob= stats.probplot(steel.Quantity , dist="norm",plot=pylab)


# histogram shows the distirbution of frequency of data
plt.hist(steel.Quantity, bins=10, color="Green")
# is shows data is distributed more over  0 to 10
plt.hist(steel.Rate, bins=5, color="bLue")

#seaborn histogram
sns.displot(steel.Rate, bins=10)
# distplot gives graph with line and histogram
sns.distplot(steel.Quantity, bins=10,hist=True)


# barplot to show the distribution of a categorical
plt.bar(height=steel.Quantity,x=steel.Type,width=0.8)

# boxplot - to check for outliers

plt.boxplot(steel.Quantity)
plt.boxplot(steel.Rate)

# to check the distrbution of data kaggle density plot
import seaborn as sns
sns.kdeplot(steel.Quantity,bw=0.5, fill=True)

sns.kdeplot(steel.Rate,bw=0.8, fill=True)

# scatter plot is used to show correlation between two numeric variables
plt.scatter(x=steel['Quantity'],y=steel['Rate'],color="red")

# to check if data is normally distributed or not
import scipy.stats as stats
import pylab
stats.probplot(steel.Quantity,dist='norm',plot=pylab)

# data preprocessing

# typecasting 

#steel.Date=steel.Date.astype('Date')
#i tried changing date but it didn't worked
# handling duplicates
 
dupli_steel=steel.duplicated()
steel= steel.drop_duplicates()
# before there were 33045 rows , after preprocessing it is changed to 33007

# missing value analysis

steel.isnull().sum()
 #there are 14 missing values in Quantity and 16 in Rate column
 
 #treating missing values
 # we can just delete rows having missing by code (variable.drop_na(axis=0,inplace=True) but we may lose important information that's why imputation is a good approach
steel.isnull().sum()
  #there are 14 missing values in Quantity and 16 in Rate column
 # we can just fill the missing values manually
steel['Quantity'].fillna(steel['Quantity'].mean(),inplace= True)
steel['Rate'].fillna(steel['Rate'].mean(),inplace= True)
steel.isnull().sum()
# now there are 0 missing values
 # or by  using libraries
from sklearn.impute import SimpleImputer 
mean_imputer= SimpleImputer(missing_values=np.nan,strategy="mean")
 
#mean_imputer = SimpleImputer(missing_values = np.nan, strategy = 'mean')
#steel["Quantity"] = pd.DataFrame(mean_imputer.fit_transform(steel[["Quantity"]]))

#mean_imputer = SimpleImputer(missing_values = np.nan, strategy = 'most_frequent')
#steel["Rate"] = pd.DataFrame(mean_imputer.fit_transform(steel[["Rate"]]))



#zero and near zero variance feautures
# the numeric variables in  dataset dont  have zero variance , so we don't have to delete an column

#outlier treament
# outlier treatment

# presence of outliers can be detected by using boxplot
plt.boxplot(steel.Quantity)

plt.boxplot(steel.Rate)

#there are more outliers in quantity than in rate


# manual treatment by determining quantiles 
# or by just using libraries
from feature_engine.outliers import Winsorizer
IQr_winso = Winsorizer(capping_method = 'iqr',tail= 'both', fold = 1.5, variables=['Quantity'])
steel.Quantity=IQr_winso.fit_transform(steel[['Quantity']]) 

IQr_winsor = Winsorizer(capping_method = 'iqr',tail= 'both', fold = 1.5, variables=['Rate'])
steel.Rate=IQr_winsor.fit_transform(steel[['Rate']]) 

# cehck for outliers 
plt.boxplot(steel.Quantity)
plt.boxplot(steel.Rate)
 # now there are no outliers
 # there's
 # encoding
DUm_type =pd.get_dummies(steel.Type)
 # there's no need for normalization or transformation as we are preparing data to work on machine learning algorithms
 
 # get the preprocessed data
steel.to_csv('preprocessed_steel.csv', index=False)
