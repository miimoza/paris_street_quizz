#!/usr/bin/python3

import plotly.express as px
import geopandas as gpd
import shapely.geometry
import numpy as np
import plotly.graph_objects as go
import sys


def show_street(street_name):
    geo_panda = gpd.read_file("data/voie.geojson")
    geo_df = geo_panda.copy(deep=True)
    geo_df = geo_df.query("l_longmin == \"" + street_name + "\"")

    lats = []
    lons = []

    for feature in geo_df.geometry:
        if isinstance(feature, shapely.geometry.linestring.LineString):
            linestrings = [feature]
        elif isinstance(feature, shapely.geometry.multilinestring.MultiLineString):
            linestrings = feature.geoms
        else:
            continue
        for linestring in linestrings:
            x, y = linestring.xy
            lats = np.append(lats, y)
            lons = np.append(lons, x)
            lats = np.append(lats, None)
            lons = np.append(lons, None)

    fig = px.scatter_mapbox(lat=lats, lon=lons, \
                        center=dict(lat=48.86, lon=2.35), zoom=12.2)

    fig.update_traces(marker=dict(size=8, color='red'), selector=dict(mode='markers'))

    fig.update_layout(mapbox_style='open-street-map')
    fig.update_layout(margin={'r':0,'t':0,'l':0,'b':0})
    #fig.update_layout(uirevision=True)
    fig.show()


show_street(sys.argv[1])
