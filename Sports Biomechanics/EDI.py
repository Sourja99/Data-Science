from pyexpat import model
from re import A, X
from turtle import ht
import numpy as np
import pandas as pd
import streamlit as st
import webbrowser
import pickle
import scipy.stats as stats

from PIL import Image

def flex(degrees):
    degrees = int(degrees)

    if (degrees>30 and degrees>70):
     x="Reduce the Temp to 30 and moisture to 70"
    elif(degrees<30 and degrees<70):
        x="Increase the temp to 30 and moisture to 70" 
    elif(degrees == 30 and degrees==70):
        x="Your food is safe" 
    return x

def main():
    st.title("REAL TIME FOOD MONITORING SYSTEM")

    html_temp = """
    <div style="background-color:white;padding:10px">
    <h2 style="color:black;text-align:center;">FOOD CONDITION ANALYSIS</h2>
    </div>
    """
    image = Image.open('cp_main_img.jpg')
    st.image(image, caption='Sensor Data on FOOD')

    st.title("For geting real time data OF SENSORS")

    if st.button("THINGSpeak"):
        webbrowser.open('https://thingspeak.com/channels/1733229/private_show')  # Go to example.com

   
    st.write("Here, you can see the real time data of the food (BANANNA)")
    

    st.markdown(html_temp,unsafe_allow_html=True)
    moisture = st.text_input("Moisture","Type Here")
    temp = st.text_input("Temperature","Type Here")
    # gas = st.text_input("Gas","Type Here")
    result=""

    if st.button("Predict"):
        result=flex(moisture,temp)

    st.write('The output is {}'.format(result))
        #st.success("The food is save")
    
    st.title("Our DATASET FOR BANANNA")
    
    #st.plot()
    df=pd.read_csv('dataset.csv')
    st.write(df)

    html_gas = """
    <div style="background-color:orange;padding:30px">
    <h2 style="color:white;text-align:center;">GAS DATA ANALYSIS</h2>
    </div>
    """
    
    st.write("THE K-NN Analysis")
    img = Image.open('download.png')
    st.image(img,width=600,caption='10-NN Cluster Analysis on Air_Quality')

    st.markdown(html_gas,unsafe_allow_html=True)

    st.write("")
    st.write("")
    st.write("")

    gas_b = st.text_input("GAS_DATA","Type Here")
    
    result_g=""
    if st.button("FOOD QUALITY"):
        #result_g=predict_gas(gas_b)
        print("hello")
    #st.success('The output is {}'.format(result_g))    

    if st.button("About US"):
        
        st.text("Vishwakarma Institue of Technology ,pune")
        st.text("SY- Electronics And Tellecommunications EDI project")
        st.text("35) Sourjadip Pramanik")
        st.text("50) Vaibhav Kadam")
        st.text("53) Vijay Singh")
        st.text("55) Vishal Gurudasani")
        st.text("56) Vishal Phonde")

if __name__=='__main__':
    main()