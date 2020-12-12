#!/usr/bin/env python3

import figure

import dash
import dash_html_components as html
import dash_core_components as dcc

def main():
    # LOAD FILE ONCE
    figure.load_geojson("data/voie.geojson")
    # START SERVER
    start_server()

def start_server():
    #with open('data/l_longmin_list') as f:
    #    l_longmin_list = f.read().splitlines()

    # INPUT SECTION
    headerSection = [
        html.H1("Devine la rue")
    ]

    inputSection = [
        dcc.Input(id='input-on-submit', value='', type="text"),
        html.Button('Verifier', id='submit-val', n_clicks=0)
    ]

    # MAP SECTION
    mapSection = dcc.Graph(id='output-iframe', style=styleMap)

    # DASH
    app = dash.Dash(__name__)
    app.layout = html.Div([
        html.Div(headerSection, style = styleHeaderDiv),
        html.Div([
            html.Div(mapSection, style = styleMapDiv),
            html.Div(inputSection, style = styleInputDiv)
        ], style = styleMainSection)

    ], style = styleContainer)

    # CALLBACKS
    @app.callback(
        dash.dependencies.Output('output-iframe', 'figure'),
        [dash.dependencies.Input('submit-val', 'n_clicks')],
        [dash.dependencies.State('l_longmin', 'value')])
    def update_output(n_clicks, value):
        print("value: " + str(value))
        return figure.get_figure(value)

    # RUN SERVER
    app.run_server(debug=False, port=8052)

styleContainer = {
    'width': '100vw',
    'height': '100vh',
    'backgroundColor': 'green',
    'padding': '0px',
    'flex-direction': 'column',
    'display': 'flex'
}

styleHeaderDiv = {
    'backgroundColor': 'red',
    'padding': '4px',
    'font-size' : '12px'
}

styleMainSection = {
    'overflow': 'hidden',
    'backgroundColor': 'lime',
    'flex': '1',
    'flex-direction': 'row',
    'display': 'flex'
}

styleMapDiv = {
    'backgroundColor': 'yellow',
    'padding': '4px',
    'flex': '1'
}

styleMap = {
    'height': '100%',
    'width': '100%'
}

styleInputDiv = {
    'backgroundColor': 'purple',
    'flex-direction': 'column',
    'display': 'flex'
}

styleInput = {
    'backgroundColor': 'orange',
    'overflow-y': 'scroll',
    'flex-direction': 'column',
    'display': 'flex'
}

if __name__ == "__main__":
    main()
