import pandas as pd
from sqlalchemy import create_engine
import os

##EXTRACT
def extract():
    ## Download the CSV file for cleaning
    url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vQJsb33W01fApfnvcf7-RKwx746xyt9E0EUp6wnFIeFFv1o2VDK87hiXlJ4yubqpd9V_mXeGN6ab1TB/pub?output=csv"
    # Read and put the csv into a data frame
    df = pd.read_csv(url)
    return df

## Transformation
def transform(df):
## Import the extracted csv and transform the phone number colums, here i will replace the x in the phone number with a dash(-)
    df['Phone 1'] = df['Phone 1'].str.replace('x', '-')
    df['Phone 2'] = df['Phone 2'].str.replace('x', '-')
    #print(df.head())
    return df

##Load
## Now I load the cleaned data into my postgres db. I use the environment variables defined in my variables file here
def load(df):
    ##Environmenta varialbes
    db_user = os.getenv('POSTGRES_USER')
    db_password = os.getenv('POSTGRES_PASSWORD')
    db_name = os.getenv('POSTGRES_DB')

    #Connect to the db
    connection_string = create_engine(f'postgresql://{db_user}:{db_password}@127.0.0.1:5432/{db_name}')

    df.to_sql('Customers', connection_string, schema="base")
    print(df)

##Call the variables
if __name__ == "__main__":
    df = extract()
    df_transform = transform(df)
    load(df_transform)    


