 #Apriori 

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from mlxtend.frequent_patterns import apriori, association_rules
data =pd.read_csv('Online Retail.csv')
data.head()
data.columns
data.shape
data.isnull().values.any()
data.isnull().sum()
data['Description']= data['Description'].str.strip()  #to remove spaces
data.dropna(axis=0,subset=['InvoiceNo'],inplace=True)   #to drop rows which nan
data['InvoiceNo']= data['InvoiceNo'].astype('str')     #to convert values in string
data = data[~data['InvoiceNo'].str.contains('C')]     #to drop rows where there is c 
data.Country.unique()   #Returns an array of all the unique values in the Country column

basket_France = (data[data['Country']=="France"]
          .groupby(['InvoiceNo', 'Description'])['Quantity']
          .sum().unstack().reset_index().fillna(0)
          .set_index('InvoiceNo'))
print(basket_France)
def hot_encode(x):
  if(x<=0):
    return 0
  if(x>=1):
    return 1
basket_encoded = basket_France.applymap(hot_encode)  #apply hot_encode to the basket_france
basket_France=basket_encoded    #reassigns the hot-encoded DataFrame (basket_encoded) back to the original basket_France.
basket_France.head()           #print first 5 rows of transformed
freq_items = apriori(basket_France,min_support=0.1, use_colnames=True)
rules = association_rules(freq_items,metric='lift',min_threshold=1)
rules= rules.sort_values(['confidence','lift'], ascending =[False, False])
print(rules.head())
_________________________________________________________________________________
#Clustering Hierarchial

import matplotlib.pyplot as plt
import pandas as pd
%matplotlib inline
import numpy as np
dataset = pd.read_csv('shopping-data.csv')
dataset.shape
dataset.head()
data = dataset.iloc[:,3:5].values
data
import scipy.cluster.hierarchy as shc
plt.figure(figsize=(10,7))
plt.title("Customer Dendograms")
dend= shc.dendrogram(shc.linkage(data, method='ward'))
from sklearn.cluster import AgglomerativeClustering
cluster = AgglomerativeClustering(n_clusters=5, metric='euclidean', linkage='ward')
lables_=cluster.fit_predict(data)
lables_

________________________________________________________________________________
#Decision Tree
import numpy as np
import pandas as pd
from sklearn.tree import DecisionTreeRegressor, plot_tree
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import seaborn as sns
import matplotlib.pyplot as plt
import warnings
# Ignore warnings for cleaner output
warnings.filterwarnings("ignore")
# Load the dataset
df = pd.read_csv("medical_insurance.csv")
# Display dataset info
print(df.info())
# Check for missing values
print(df.isna().sum())
#Converting categorical columns into numeric
df['sex'].replace({"male": 0, "female": 1}, inplace=True)
sex_value = {"female": 1, "male": 0}
print("Sex Value Encoding:", sex_value)

df['smoker'].replace({"yes": 0, "no": 1}, inplace=True)
smoker_value = {"no": 1, "yes": 0}
print("Smoker Value Encoding:", smoker_value)

# Convert 'region' column into dummy variables (one-hot encoding)
df = pd.get_dummies(df, columns=['region'])
print(df.head())

# Define feature matrix (X) and target variable (y)
X = df.drop("charges", axis=1)  # Dropping the target variable 'charges'
y = df["charges"]  # Target variable
#Splitting the data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
#Initialize and train the Decision Tree Regressor
dt_reg = DecisionTreeRegressor()
dt_reg.fit(X_train, y_train)
# Make predictions on the test set
y_pred = dt_reg.predict(X_test)

#Evaluate the Model
mae = mean_absolute_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
r2 = r2_score(y_test, y_pred)

print(f"Mean Absolute Error (MAE): {mae}")
print(f"Mean Squared Error (MSE): {mse}")
print(f"Root Mean Squared Error (RMSE): {rmse}")
print(f"R² Score: {r2}")
#Plot the Decision Tree:
plt.figure(figsize=(45, 40))
plot_tree(dt_reg, filled=True, feature_names=X.columns)
plt.title("Decision Tree")
plt.show()
#Training Error Analysis
y_pred_train = dt_reg.predict(X_train)

mse_train = mean_squared_error(y_train, y_pred_train)
print("Mean Squared Error (Train) --->", mse_train)

mae_train = mean_absolute_error(y_train, y_pred_train)
print("Mean Absolute Error (Train) --->", mae_train)

rmse_train = np.sqrt(mse_train)
print("Root Mean Square Error (Train) --->", rmse_train)
r2_train = r2_score(y_train, y_pred_train)
print("R² Score (Train) --->", r2_train)

# Display feature column names
column_names = X.columns
print(column_names)
# Create JSON-like data structure for model features and encodings
json_data = {
    "sex": sex_value,
    "smoker_value": smoker_value,
    "columns": list(column_names)
}
print(json_data)

# Define sample inputs for prediction
age = 21.0
sex = "female"
bmi = 33.7
children = 1.0
smoker = "no"
region = "northeast"

# Convert region to its corresponding column name in one-hot encoding
region = "region_" + region
print(region)
region_index = list(column_names).index(region)
print(region_index)
test_array = np.zeros(len(column_names))

test_array[0] = age
test_array[1] = json_data['sex'][sex]
test_array[2] = bmi
test_array[3] = children
test_array[4] = json_data['smoker_value'][smoker]
test_array[region_index] = 1

print(test_array)
#Predict charges using the trained model
charges = round(dt_reg.predict([test_array])[0], 2)
print("Predicted Medical Insurance Charges is:", charges, "/- Rs. Only")
____________________________________________________________________________
#Naive Bayers

import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.naive_bayes import GaussianNB, MultinomialNB, BernoulliNB
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
import warnings
warnings.filterwarnings('ignore')
df = pd.read_excel("weathers.xlsx")
df

df1=df.dropna()
df1
df1["outlook"].replace({"overcast":1, "rainy":2, "sunny":3},inplace=True)
df1["temperature"].replace({"mild":0,"hot":1,"cool":2},inplace=True)
df1["humidity"].replace({"high":0,"normal":1},inplace=True)
df1["play"].replace({"no":0,"yes":1},inplace=True)

#Train Split Test:
x=df1.drop("play",axis=1)
y=df1["play"]
x_train, x_test, y_train, y_test = train_test_split(x,y,test_size=0.2,random_state=42, stratify=y)

#Model Training:
gnb_model = GaussianNB()
gnb_model.fit(x_train,y_train)
y_pred = gnb_model.predict(x_test)

cnf_matrix = confusion_matrix(y_test,y_pred)
print("Confusion Matrix:\n",cnf_matrix)
print("-"*60
acc_score = accuracy_score(y_test,y_pred)
print("Accuracy Score:",acc_score)
print("-"*60)
clf_report = classification_report(y_test,y_pred)
print("Classification Report:\n",clf_report)
Single user input testing:
column_names = x.columns
column_names
outlook_value={'overcast':1, 'rainy':2, 'sunny':3}
temperature_value={'mild':0,'hot':1,'cool':2}
humidity_value={'high':0,'normal':1}
json_data = {
    'outlook':outlook_value,
    'temperature':temperature_value,
    'humidity':humidity_value
}   json_data
Import json
with open('DWDM9.json', 'w') as f:
    json.dump(json_data, f)
outlook='rainy'
temperature='mild'
humidity='high'
windy=1.0
test_array = np.zeros(len(x.columns))
test_array[0] = json_data['outlook'][outlook]
test_array[1] = json_data['temperature'][temperature]
test_array[2] = json_data['humidity'][humidity]
test_array[3] = windy
test_array
play=gnb_model.predict([test_array])[0]
if play==1:
    print("Play")
else:
    print("No Play")

____________________________________________________________________________

#k-Means

Importing Libraries and dataset
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler, MinMaxScaler
import matplotlib.pyplot as plt
import seaborn as sns
df= pd.read_csv("Country_clusters.csv")
df
df1= pd.get_dummies(df)
df1
df.info()
sns.scatterplot(x = df['Latitude'], y=df['Longitude'])

#Visualization

numeric_df=df.select_dtypes(include=[int,float])
std_scalar = StandardScaler()
x=numeric_df
array = std_scalar.fit_transform(x)
x = pd.DataFrame(array, columns=x.columns)
x
from sklearn.preprocessing import StandardScaler

# Creating an instance of StandardScaler
std_scalar = StandardScaler()

# Applying the scaler to the 'Latitude' and 'Longitude' columns
array = std_scalar.fit_transform(df1[['Latitude', 'Longitude']])

# Creating a DataFrame with the scaled values
x_scaled = pd.DataFrame(array, columns=['Latitude', 'Longitude'])

# Concatenating the scaled columns back with the rest of the dataset
x = pd.concat([x_scaled, df1.drop(['Latitude', 'Longitude'], axis=1)], axis=1)

# Display the final DataFrame
x.head()
kmean_model = KMeans(n_clusters=3)
y_pred = kmean_model.fit_predict(x)
y_pred
x['Traget'] = y_pred
x

plt.scatter(x = df['Latitude'], y= df['Longitude'], c= y_pred, cmap='rainbow')

