#!/usr/bin/env python3
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import plotly.express as px
import numpy as np
import geopandas as gpd
from plotly.subplots import make_subplots
import plotly.graph_objects as go
import time

def get_figure(l_longmin_list, heatmap=True):
    df_places = load_data(l_longmin_list)

    print("get coordinates")
    lon, lat = get_coord(df_places)


    fig = px.scatter_mapbox(df_places, lon=lon, lat=lat, hover_name="L_LONGMIN", \
                            center=dict(lat=48.86, lon=2.35), zoom=12.2)


    # TRACES (markers)
    fig.update_traces(marker=dict(size=8), selector=dict(mode='markers'))

    # LAYOUT (background, margins)
    fig.update_layout(mapbox_style="open-street-map")
    fig.update_layout(margin={"r":0,"t":0,"l":0,"b":0})

    # RETURN
    return fig

def load_geojson(path):
    global geo_panda
    geo_panda = gpd.read_file(path)

def load_data(l_longmin_list):
    df_places = geo_panda.copy(deep=True)


    return df_places

def get_coord(df):
    #lon = []
    #lat = []
    #for i in df["geometry"]:
    #    print("x:" + i.x + " | y:" + i.y)
    #    lon.append(i.x)
    #    lat.append(i.y)
    lat=df.array(feature["geometry"]["coordinates"])[:, 1],
    lon=df.array(feature["geometry"]["coordinates"])[:, 0],


    return lon, lat
