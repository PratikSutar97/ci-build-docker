import streamlit as st
import pandas as pd
import numpy as np
import plotly_express as px
import os

'''
# Club and Nationality App

This very simple webapp allows you to select and visualize players from certain clubs and certain nationalities.
'''
# S3_BUCKET_NAME=os.environ['S3_BUCKET_NAME']
# CSV_FILE_NAME=os.environ['CSV_FILE_NAME']
# S3_FILE_PATH='s3://' + str(S3_BUCKET_NAME) + '/' + str(CSV_FILE_NAME)
# df = st.cache(pd.read_csv)("football_data.csv")
df = st.cache_data(lambda: pd.read_csv("football_data.csv"))()
# df = pd.read_csv("s3://my-test-bucket/sample.csv")
# df = pd.read_csv(S3_FILE_PATH)

clubs = st.sidebar.multiselect('Show Player for clubs?', df['Club'].unique())
nationalities = st.sidebar.multiselect('Show Player from Nationalities?', df['Nationality'].unique())

new_df = df[(df['Club'].isin(clubs)) & (df['Nationality'].isin(nationalities))]
st.write(new_df)

# Create distplot with custom bin_size
fig = px.scatter(new_df, x ='Overall',y='Age',color='Name')

'''
### Here is a simple chart between player age and overall
'''

st.plotly_chart(fig)
