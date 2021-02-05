# figure.py

import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import plotly.express as px
import numpy as np
import geopandas as gpd
from plotly.subplots import make_subplots
import plotly.graph_objects as go

import time

def get_figure(libact_list, display_type='heatmap', center=dict(lat=48.86, lon=2.35), zoom=12.2):

    df_places = load_data(libact_list)
    df = px.data.gapminder().query("year == 2007")

    """lon, lat = get_coord(df_places)

    if display_type == 'heatmap':
        fig = px.density_mapbox(df_places, hover_name='l_longmin', \
                            radius=8, center=center, zoom=zoom)
        fig.update(layout_coloraxis_showscale=False)
    else:
        fig = px.scatter_mapbox(df_places, hover_name='l_longmin', \
                            center=center, zoom=zoom)

"""
    # TRACES (markers)
    fig.update_traces(marker=dict(size=8), selector=dict(mode='markers'))

    # LAYOUT (background, margins)

    

    fig.update_layout(mapbox_style='open-street-map')
    fig.update_layout(margin={'r':0,'t':0,'l':0,'b':0})
    fig.update_layout(uirevision=True)

    # RETURN
    return fig

def load_geojson(path):
    global geo_panda
    geo_panda = gpd.read_file(path)

def load_data(libact_list):
    df_places = geo_panda.copy(deep=True)

    if (libact_list == None or len(libact_list) == 0):
        return df_places.query("l_longmin != 'Locaux Vacants' and\
                                l_longmin != 'Locaux en travaux' and\
                                l_longmin != 'Bureau en boutique'")

    print('Generate geopandas dataframe with libacts: ' + str(libact_list))
    df_final = df_places[df_places.l_longmin == libact_list[0]]
    for libact in libact_list[1:]:
        print('Add:' + libact)
        df_final = df_final.append(df_places[df_places.l_longmin == libact])

    # merge all mdr

    return df_final

def get_coord(df):
    lon = []
    lat = []
    for i in df['geometry']:
        lon.append(i.x)
        lat.append(i.y)

    return lon, lat
