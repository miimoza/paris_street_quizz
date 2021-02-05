#!/usr/bin/python3

import plotly.express as px
import geopandas as gpd
import shapely.geometry
import numpy as np
import plotly.graph_objects as go


def show_street(street_name):
    geo_panda = gpd.read_file("data/voie.geojson")
    geo_df = geo_panda.copy(deep=True)
    geo_df = geo_df.query("l_longmin == '" + street_name + "'")

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

    fig.update_traces(marker=dict(size=8), selector=dict(mode='markers'))

    #fig.update_layout(mapbox_style='open-street-map')
    fig.update_layout(
    mapbox_style="white-bg",
    mapbox_layers=[
        {
            "below": 'traces',
            "sourcetype": "raster",
            "sourceattribution": "United States Geological Survey",
            "source": [
                "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}"
            ]
        },
        {
            "sourcetype": "raster",
            "sourceattribution": "Government of Canada",
            "source": ["https://geo.weather.gc.ca/geomet/?"
                       "SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX={bbox-epsg-3857}&CRS=EPSG:3857"
                       "&WIDTH=1000&HEIGHT=1000&LAYERS=RADAR_1KM_RDBR&TILED=true&FORMAT=image/png"],
        }
      ])
    fig.update_layout(margin={'r':0,'t':0,'l':0,'b':0})
    #fig.update_layout(uirevision=True)
    fig.show()

show_street("Rue de Buenos Aires")
