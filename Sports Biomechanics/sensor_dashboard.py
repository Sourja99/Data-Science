#from asyncio.windows_events import NULL
#from logging import PlaceHolder
from re import X
import time  # to simulate a real time data, time loop
import webbrowser
import numpy as np  # np mean, np random
import pandas as pd  # read csv, df manipulation
import plotly.express as px  # interactive charts
import streamlit as st  # 🎈 data web app development
#from pages import ecg_p1
#from multipage import MultiPage
#app = MultiPage()
import matplotlib.pyplot as plt
import plotly.graph_objects as go
from plotnine import ggplot, aes, geom_line
import matplotlib
import array as arr
matplotlib.use('TkAgg')
#from prophet import Prophet

import csv
import math
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
# Helps to obtain the FFT
import scipy.fftpack    
# Various operations on signals (waveforms)
import scipy.signal as signal


from PIL import Image

st.set_page_config(
    page_title="Sports Biomechanics",
    page_icon="✅",
    layout="wide",
)

# # read csv from a github repo
# #dataset_url = "https://raw.githubusercontent.com/Sourja99/MyPython/d5dcbb9abb1493b37a4cf65ed0105fe570e816f0/ecg_sensor_tst%20-%20Sheet1.csv"
# dataset_url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRlHI3DSI1tIDoH5--pO12SLdyFtLoqf0RtbZXxsce2LrtV7kyx9wdEPJ-hwxHJnQANFDAWHPoKRtls/pub?output=csv"
# # read csv from a URL
# @st.experimental_memo
# def get_data() -> pd.DataFrame:
#     return pd.read_csv(dataset_url)
#     #return pd.read_html("https://docs.google.com/spreadsheets/d/e/2PACX-1vRlHI3DSI1tIDoH5--pO12SLdyFtLoqf0RtbZXxsce2LrtV7kyx9wdEPJ-hwxHJnQANFDAWHPoKRtls/pubhtml")

# df = get_data()

def main_page():

    html_temp = """
    <div style="background-color:white;padding:10px">
    <h2 style="color:black;text-align:center;">Our DataSet</h2>
    </div>
    """
    html_gas = """
    <div style="background-color:orange;padding:10px">
    <h2 style="color:white;text-align:center;">Sensor Data</h2>
    </div>
    """

    st.markdown("# Sports Biomechanics 🎈")
    st.sidebar.markdown("# Home page 🎈")
    # dashboard title
    st.title("Real-Time Sensor Analysis")
    image = Image.open('sport_biomechanics.jpg')
    st.image(image,caption='Sports Biomechanics')

    # read csv from a github repo
    dataset_url = "edi_sheet.csv"
    #dataset_url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRlHI3DSI1tIDoH5--pO12SLdyFtLoqf0RtbZXxsce2LrtV7kyx9wdEPJ-hwxHJnQANFDAWHPoKRtls/pub?output=csv"
# read csv from a URL
    @st.experimental_memo
    def get_data() -> pd.DataFrame:
        return pd.read_csv(dataset_url)
        #return pd.read_html("https://docs.google.com/spreadsheets/d/e/2PACX-1vRlHI3DSI1tIDoH5--pO12SLdyFtLoqf0RtbZXxsce2LrtV7kyx9wdEPJ-hwxHJnQANFDAWHPoKRtls/pubhtml")

    df = get_data()

    st.markdown("# Real time Dataset ✅")
    # top-level filters
    st.markdown(html_temp,unsafe_allow_html=True)
    df=pd.DataFrame(df)
    st.write(df)

#job_filter = st.sidebar("Select the Sensor data",list(df.columns))
    #st.selectbox('Sensor Analysis：')
    #st.selectbox.subheader('1. Chose the sensor to be seen :')
    st.write("")
    st.write("")
    st.markdown(html_gas,unsafe_allow_html=True)
    option = st.selectbox('Sensor Used',('Ecg','Uv','Gyro','Hand Movement Analysis','Respiratory Breathing Analysis','Pulse & SpO2'))
 #'Flex','FSR','Strain'



#option = st.sidebar.selectbox('Sensor',list(df.columns.values))
    placeholder = st.empty()

    with placeholder.container():
        fig_col1, fig_col2 = st.columns(2)
        with fig_col1:
            st.write('You selected:', option)

    
# dataframe filter
            print(option)
    # page_names_to_funcs = {
    # "Main Page": main_page,
    # "Page 2": page2,
    # "Page 3": page3,
    # }
#df = df.option
#print(df)
#st.write(df)
            if option == 'Ecg':
                df1 = df[df.columns[:3]]
                st.write(df1)
                
            if option == 'Uv':
                df2 = df[df.columns[0:2]] + df[df.columns[3:4]] 
                st.write(df2)
            #fig1 =plt.plot(df.columns[1], df.columns[2])
            #st.write(fig1)
            # chart_data = pd.DataFrame(
            # df[df.columns['Ecg']],
            # columns= df.columns['Time'])

            # st.line_chart(chart_data)
            # df.plot(x = df[df[['Time']]], y= df[df[['Ecg']]], kind = 'line')
            # plt.show()
            # df = pd.DataFrame(df,columns=['Time','Ecg (bps)'])
            # df.plot(x ='Time', y='Ecg (bps)' , kind = 'line')
            # plt.show()
        #app.add_page("Upload Data", ecg_p1.app)
            #page2()
                
            if option == 'Gyro':
                df = df[df.columns[:5]]
                st.write(df)
            if option == 'Hand Movement Analysis':
                df = df[df.columns[:8]]
                st.write(df)
            if option == 'Respiratory Breathing Analysis':
                df = df[df.columns[:]]
                st.write(df)
            if option == 'Pulse & SpO2':
                df = df[df.columns[:3]]
                st.write(df)
            time.sleep(1)
        #with fig_col2:
            # df9 = pd.read_csv('ecg_sensor_tst - Sheet1.csv')
            # (
                
            #     ggplot(df9)  # What data to use
            #     + aes(x="Time", y="Flex (Degrees)")  # What variable to use
            #     + geom_line()  # Geometric object to use for drawing
            # )
        
        with fig_col2:
            #df4 = pd.DataFrame(df,columns=['Time','Ecg (bps)','Uv (mW/cm2)','Flex (Degrees)'])
            #df4.plot(x ='Time', y='Ecg (bps)' , kind = 'line')
            #st.line_chart(df4)
            df = pd.read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRlHI3DSI1tIDoH5--pO12SLdyFtLoqf0RtbZXxsce2LrtV7kyx9wdEPJ-hwxHJnQANFDAWHPoKRtls/pub?output=csv")
            #df = df.set_index(‘Date’)
            #st.line_chart(df)
            df = pd.DataFrame(dict(
            X_axis = [i for i in range(1000)],
            #Y_axis = np.random.randint(10, 50, 100)
            Y_axis = np.random.randint(10, 50, 1000) 
            #Y2_axis = np.random.randint(1, 5, 1000)
            ))
            #The plot
            fig = px.line(        
            df, #Data Frame
            x = "X_axis", #Columns from the data frame
            y = "Y_axis",
            #title = "Line frame"
            )
            fig.update_traces(line_color = "maroon")
            st.plotly_chart(fig)


#st.dataframe(df.option)
    
    

def page2():
    st.title("# Movement Analysis for Hand Muscles  ❄️")

    st.sidebar.markdown("# FSR & FLEX ❄️")
    image = Image.open('EMG.jpg')
    st.image(image,caption='Working of emg/fsr')

    html_allsensor = """
    <div style="background-color:blue;padding:10px">
    <h2 style="color:white;text-align:center;">Muscle Analysis is done to provide better performance 🎉</h2>
    </div>
    """
    st.subheader('Signal Analysis & Filter')

    st.markdown(html_allsensor, unsafe_allow_html=True)
    st.sidebar.markdown("# BLYNK APP 🎈")
    st.title("For Muscle analysis")

    if st.button("Colab file"):
        webbrowser.open('https://colab.research.google.com/drive/1ABYfstLjKyIlkjtGDfdU-JvhgzXUn4SM#scrollTo=vQYcKLnf4XkD')  # Go to example.com
    #a=arr.array('d',[1.2,1.3,2.3])
    # x=arr.array('d',[15,15,15,15,15,16,872,456,900,752,16,924,
    # 1000,16,987,16,960,982,16,986,16,1005,962,1024,1011,984,1024,1024,
    # 1024,1024,986,993,17,16,16,15,16,15,15,15,15,15,1015,1024,1024,1024,1009,
    # 872,966879,15,,15,16,522,241,80,302,786,16,16,16,578,798,793,774,792,17,15,17,
    # 565,855,986,1009,1023,857,888,213,17,17,18,521,872,900,922,890,900,908,18,18,17,
    # 18,18,18,987,1005,986,824,886,19,18,18,18,18,18,960,543,358,21,709,20,17,17,966,991,
    # 1006,944,1015,950,957,925,962,912,980,972,1016,1003,1017,1016,1024,1024,954,1002,17,
    # 16,16,882,916,932,885,929,193,957,17,16,17,16,17,927,266,585,999,764,752,16,969,989,
    # 905,949,820,360,989,969,973,845,250,963,219,330,17,18])
    df1 = pd.read_csv("edi_sheet.csv")
    df1 = pd.DataFrame(dict(
        X_axis = np.random.randint(10, 50, 171),
        #Y_axis = np.random.randint(10, 50, 100)
        #Y_axis = y 
        Y_axis = np.random.randint(1, 5,171)
        ))
            #The plot
    fig = px.line(        
        df1, #Data Frame
        x = "X_axis", #Columns from the data frame
        y = "Y_axis",
        #title = "Line frame"
        )
    fig.update_traces(line_color = "yellow")
    st.plotly_chart(fig)

def page3():
    css_example = '''
    <h1>Electrocardiogram (ECG) & Its Analysis !   <i class="fa-solid fa-heart-pulse fa-3x"></i></h1>                                                                                                                                                       
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">                                                                                                                                                                                                                                                                                                        
    
    '''
    css_example2 = '''
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">   
    <h1>Detecting (Bpm)    <i class="fa-solid fa-heart-pulse"></i></h1>                                                                                                                                                       
    '''
    html_ecg = """
    <div style="background-color:red;padding:10px">
    <h2 style="color:white;text-align:center;">ECG Sensor Dataset And Its Analysis</h2>
    </div>
    """

    html_ecg2 = """
    <div style="background-color:orange;padding:10px">
    <h2 style="color:white;text-align:center;">Peak detected and beats taken out</h2>
    </div>
    """

    st.markdown(css_example, unsafe_allow_html=True)
    st.sidebar.markdown(css_example2,unsafe_allow_html=True)
    st.subheader("ECG Analysis")

    image = Image.open('ecg1.jpg')
    st.image(image,width=1170,caption='Ecg an Important to ones vital')

    st.markdown(html_ecg, unsafe_allow_html=True)

    dfx=pd.read_csv('ecgdata.csv')  
    #dfx[dfx.columns[1:3]]
    #st.write(dfx)

#### Analysis ECG #####
    fig_d, fig_hr, fig_af= st.columns(3)

    with fig_d:
        df1=pd.DataFrame(dfx[dfx.columns[2:3]])

    df2=df1[0:534]
    df1[df1.columns[0:1]]
    y = [e for e in df2['Ecg ']]
    N = len(y)
    # sample spacing
    Fs = 1000
    T = 1.0 / Fs
    #Compute x-axis
    x = np.linspace(0.0, N*T, N)
    #Compute FFT
    yf = scipy.fftpack.fft(y)
    xf = np.linspace(0,500, 534)

    fig_td = plt.figure()
    # fig_td.canvas.set_window_title('Time domain signals')
    # #fig_fd = plt.figure()
    # #fig_fd.canvas.set_window_title('Frequency domain signals')
    # ax1 = fig_td.add_subplot(211)
    # ax1.set_title('Before filtering')
    # ax2 = fig_td.add_subplot(212)
    # ax2.set_title('After filtering')

    with fig_hr:
       # from matplotlib import pyplot as plt
        #hr = plt.plot(x,y, color='r', linewidth=0.7)
        #st.pyplot(hr)
       # fig = m.plot(fcst)
       # from matplotlib import pyplot as plt
        #plt.savefig('figure.png')
        #st.pyplot(hr)
       # image = Image.open('ecg3.png')
        #st.image(image,caption='Raw ECG Signal')
        #plt.plot(x,y)
        #hr = plt.show()
        #hr
        #st.pyplot(hr)
        #print(len(xf),len(yf))

        df1 = pd.DataFrame(dict(
        X_axis = x,
        #Y_axis = np.random.randint(10, 50, 100)
        Y_axis = y 
        #Y2_axis = np.random.randint(1, 5, 1000)
        ))
            #The plot
        fig = px.line(        
        df1, #Data Frame
        x = "X_axis", #Columns from the data frame
        y = "Y_axis",
        #title = "Line frame"
        )
        fig.update_traces(line_color = "maroon")
        st.plotly_chart(fig)

    b, a = signal.butter(4, 50/(Fs/2), 'low')

    tempf = signal.filtfilt(b,a, y)
    #b, a = signal.butter(1, band_filt/(Fs/2), 'bandstop')
    tempf = signal.filtfilt(b,a, y)
    yff = scipy.fftpack.fft(tempf)

    nyq_rate = Fs/ 2.0
    # The desired width of the transition from pass to stop.
    width = 5.0/nyq_rate
    # The desired attenuation in the stop band, in dB.
    ripple_db = 60.0
    # Compute the order and Kaiser parameter for the FIR filter.
    O, beta = signal.kaiserord(ripple_db, width)
    # The cutoff frequency of the filter.
    cutoff_hz = 4.0


    taps = signal.firwin(O, cutoff_hz/nyq_rate, window=('kaiser', beta), pass_zero=False)
    # Use lfilter to filter x with the FIR filter.
    y_filt = signal.lfilter(taps, 1.0, tempf)
    yff = scipy.fftpack.fft(y_filt)
    #Plot filtered outputs
    #ax4.plot(xf, 2.0/N * np.abs(yff[:N]), color='g', linewidth=0.7)
    #ax4.set_ylim([0 , 0.2])

    with fig_af:
        # plt.plot(x,y_filt, color='g', linewidth=0.7);
        # fig = plt.show()
        
        # #st.write(fi)
        # # st.write("")
        # # st.write("")
        # # st.write("")
        # # st.write("")
        # image = Image.open('ecg4.png')
        # st.image(image,caption='Filtered Ecg Signal')
        # fig
        df1 = pd.DataFrame(dict(
        X_axis = x,
        #Y_axis = np.random.randint(10, 50, 100)
        Y_axis = y_filt 
        #Y2_axis = np.random.randint(1, 5, 1000)
        ))
            #The plot
        fig = px.line(        
        df1, #Data Frame
        x = "X_axis", #Columns from the data frame
        y = "Y_axis",
        #title = "Line frame"
        )
        fig.update_traces(line_color = "maroon")
        st.plotly_chart(fig)
    
    st.markdown(html_ecg2, unsafe_allow_html=True)
    image = Image.open('ecg7.png')
    st.image(image,caption='Peak ECG Signal')

################################


def page4():
    st.title('All Sensor Interface')
    image = Image.open('allsensor.jpg')
    st.image(image,caption='Sports Biomechanics & Gait Analysis')

    html_allsensor = """
    <div style="background-color:orange;padding:10px">
    <h2 style="color:white;text-align:center;">The Real Time feed is provided 🎉</h2>
    </div>
    """
    st.subheader('Preliminary Analysis Done here')

    st.markdown(html_allsensor, unsafe_allow_html=True)
    st.sidebar.markdown("# BLYNK APP 🎈")
    st.title("For geting real time Dashboard for all the Sensor")

    if st.button("BLYNK APP"):
        webbrowser.open('https://blr1.blynk.cloud/dashboard/71538/global/filter/384031/organization/71538/devices/231959/dashboard')  # Go to example.com

page_names_to_funcs = {
    "Home Page": main_page,
    "Hand Movement Analysis": page2,
    "ECG Analysis":page3,
    "All the Sensors": page4,
}

st.sidebar.title("Select the Analysis")
selected_page = st.sidebar.selectbox("Sensor details", page_names_to_funcs.keys())
page_names_to_funcs[selected_page]()

st.sidebar.title("About Us")
st.sidebar.text("Vishwakarma Institue of Technology")
st.sidebar.text("Electronics And Tellecommunications")
st.sidebar.text("SY-ET-D-B2_Grp1")
st.sidebar.subheader("Contributers🎉")
st.sidebar.text("35) Sourjadip Pramanik")
st.sidebar.text("50) Vaibhav Kadam")
st.sidebar.text("53) Vijay Kumar Singh")
st.sidebar.text("55) Vishal Gurudasani")
#st.sidebar.text("56) Vishal Phonde")

st.sidebar.title("Give us your review here")
result = st.sidebar.text_input(label='Feedback',value='Write Here',max_chars=600)
#st.sidebar.progress(result)
          
if len(result)>12:
    st.sidebar.success('Feedback sent Successfully')#'The output is {}'.format(result_g)'
    print(result)