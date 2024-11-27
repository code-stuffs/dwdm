create database customer_service;
use customer_service;
CREATE TABLE customer_queries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    query_type VARCHAR(50),
    customer_type VARCHAR(50),
    urgency_level VARCHAR(50),
    sentiment VARCHAR(50),
    escalation TINYINT(1)
);
INSERT INTO customer_queries (query_type, customer_type, urgency_level, sentiment, escalation) VALUES
('Technical', 'Standard', 'High', 'Negative', 1),
('Billing', 'Premium', 'Medium', 'Positive', 0),
('Account', 'Enterprise', 'Low', 'Neutral', 0),
('Technical', 'Enterprise', 'High', 'Negative', 1),
('Billing', 'Standard', 'Low', 'Positive', 0),
('General', 'Premium', 'High', 'Negative', 1),
('Technical', 'Standard', 'Medium', 'Neutral', 0),
('Account', 'Premium', 'High', 'Negative', 1),
('Billing', 'Enterprise', 'Low', 'Positive', 0),
('Technical', 'Premium', 'Medium', 'Positive', 0),
('General', 'Standard', 'High', 'Negative', 1),
('Technical', 'Enterprise', 'Low', 'Positive', 0),
('Account', 'Standard', 'Medium', 'Neutral', 0),
('General', 'Premium', 'Low', 'Negative', 0),
('Billing', 'Enterprise', 'High', 'Negative', 1),
('Technical', 'Premium', 'High', 'Positive', 0),
('General', 'Enterprise', 'Medium', 'Negative', 1),
('Account', 'Standard', 'Low', 'Positive', 0),
('Billing', 'Premium', 'Medium', 'Neutral', 0),
('Technical', 'Enterprise', 'High', 'Negative', 1),
('General', 'Standard', 'Medium', 'Positive', 0);

#Naïve Bayers Implementation:
# Import necessary libraries
import mysql.connector
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, classification_report
import numpy as np

# Database connection details
db_config = {
    'user': 'root',
    'password': ' ',
    'host': 'localhost',
    'database': 'customer_service'
}

# Connect to the MySQL database
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Fetch the dataset from the database
query = "SELECT query_type, customer_type, urgency_level, sentiment, escalation FROM customer_queries"
cursor.execute(query)
data = cursor.fetchall()

# Close the database connection
cursor.close()
conn.close()

# Create a DataFrame from the fetched data
columns = ['query_type', 'customer_type', 'urgency_level', 'sentiment', 'escalation']
df = pd.DataFrame(data, columns=columns)

# Encode categorical features using separate LabelEncoders for each column
encoders = {}
for column in df.columns[:-1]:
    encoders[column] = LabelEncoder()
    df[column] = encoders[column].fit_transform(df[column])

# Split the dataset into features and labels
X = df.drop('escalation', axis=1)
y = df['escalation']

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the Naive Bayes model using MultinomialNB
model = MultinomialNB()
model.fit(X_train, y_train)

# Predict on the testing set
y_pred = model.predict(X_test)

# Calculate and print the training and testing accuracy
training_accuracy = model.score(X_train, y_train)
testing_accuracy = accuracy_score(y_test, y_pred)
print(f"Training Accuracy: {training_accuracy:.2f}")
print(f"Testing Accuracy: {testing_accuracy:.2f}")

# Print the classification report
print("\nClassification Report:\n", classification_report(y_test, y_pred))

# Single user input testing
def predict_escalation(query_type, customer_type, urgency_level, sentiment):
    # Encode the input features using the fitted encoders
    try:
        query_type_encoded = encoders['query_type'].transform([query_type])[0]
        customer_type_encoded = encoders['customer_type'].transform([customer_type])[0]
        urgency_level_encoded = encoders['urgency_level'].transform([urgency_level])[0]
        sentiment_encoded = encoders['sentiment'].transform([sentiment])[0]
    except KeyError as e:
        raise ValueError(f"Input contains an unknown value: {e}")

    # Combine the encoded features into a single array
    input_data = np.array([[query_type_encoded, customer_type_encoded, urgency_level_encoded, sentiment_encoded]])

    # Create a DataFrame with the same column names as used in training
    input_df = pd.DataFrame(input_data, columns=X.columns)

    # Predict escalation
    prediction = model.predict(input_df)
    return "Escalation" if prediction[0] == 1 else "No Escalation"

# Example input
query_type_input = 'Technical'
customer_type_input = 'Premium'
urgency_level_input = 'High'
sentiment_input = 'Negative'

# Test with a single input
try:
    result = predict_escalation(query_type_input, customer_type_input, urgency_level_input, sentiment_input)
    print(f"Prediction for the input query: {result}")
except ValueError as e:
    print(e)

#naive bayers with importing csv

# Import necessary libraries
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, classification_report
import numpy as np

# Load the dataset from a CSV file
data_file = "customer_queries.csv"  # Update with your CSV file path
df = pd.read_csv(data_file)

# Encode categorical features using separate LabelEncoders for each column
encoders = {}
for column in df.columns[:-1]:
    encoders[column] = LabelEncoder()
    df[column] = encoders[column].fit_transform(df[column])

# Split the dataset into features and labels
X = df.drop('escalation', axis=1)
y = df['escalation']

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the Naive Bayes model using MultinomialNB
model = MultinomialNB()
model.fit(X_train, y_train)

# Predict on the testing set
y_pred = model.predict(X_test)

# Calculate and print the training and testing accuracy
training_accuracy = model.score(X_train, y_train)
testing_accuracy = accuracy_score(y_test, y_pred)
print(f"Training Accuracy: {training_accuracy:.2f}")
print(f"Testing Accuracy: {testing_accuracy:.2f}")

# Print the classification report
print("\nClassification Report:\n", classification_report(y_test, y_pred))

# Single user input testing
def predict_escalation(query_type, customer_type, urgency_level, sentiment):
    # Encode the input features using the fitted encoders
    try:
        query_type_encoded = encoders['query_type'].transform([query_type])[0]
        customer_type_encoded = encoders['customer_type'].transform([customer_type])[0]
        urgency_level_encoded = encoders['urgency_level'].transform([urgency_level])[0]
        sentiment_encoded = encoders['sentiment'].transform([sentiment])[0]
    except KeyError as e:
        raise ValueError(f"Input contains an unknown value: {e}")

    # Combine the encoded features into a single array
    input_data = np.array([[query_type_encoded, customer_type_encoded, urgency_level_encoded, sentiment_encoded]])

    # Create a DataFrame with the same column names as used in training
    input_df = pd.DataFrame(input_data, columns=X.columns)

    # Predict escalation
    prediction = model.predict(input_df)
    return "Escalation" if prediction[0] == 1 else "No Escalation"

# Example input
query_type_input = 'Technical'
customer_type_input = 'Premium'
urgency_level_input = 'High'
sentiment_input = 'Negative'

# Test with a single input
try:
    result = predict_escalation(query_type_input, customer_type_input, urgency_level_input, sentiment_input)
    print(f"Prediction for the input query: {result}")
except ValueError as e:
    print(e)


