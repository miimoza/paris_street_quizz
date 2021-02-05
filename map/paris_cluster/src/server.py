# server.py

import figure

import os

import dash
import dash_html_components as html
import dash_core_components as dcc

def start_server(title):
    with open('data/libact_list') as f:
        libact_list = f.read().splitlines()

    headerSection = [
        html.H1(title),
    ]

    inputSection = [
        #dcc.Checklist(
        #    id='libact-checklist',
        #    options=[
        #        {'label': libact, 'value': libact} for libact in libact_list
        #    ],
        #    style=styleInput
        #),
        html.H3('Affichage'),
        dcc.Dropdown(
            id='display-selector',
            options=[
                {'label': 'Heat map', 'value': 'heatmap'},
                {'label': 'Points', 'value': 'plots'},
            ],
            value='heatmap',
            searchable=False,
            clearable=False,
            multi=False,
            style=styleDisplaySelector
        ),
        html.Br(),
        html.H3('Filtres'),
        dcc.Dropdown(
            id='libact-selector',
            options=[
                {'label': libact, 'value': libact} for libact in libact_list
            ],
            value=[],
            placeholder='Cherchez...',
            searchable=True,
            clearable=True,
            multi=True,
            style=styleLibactSelector
        ),
        #html.Button('Actualiser', id='submit-button', n_clicks=0)
    ]

    # MAP SECTION
    mapSection = dcc.Graph(
        id='output-graph',
        config={
            'displaylogo': False,
            'showscale': False,
            'modeBarButtonsToRemove': ['pan2d', 'lasso2d']
        },
        style=styleMap
    )

    # DASH
    assets_path = os.getcwd() + '/assets'
    app = dash.Dash(__name__, assets_folder=assets_path)
    app.title = title
    app.layout = html.Div([
        html.Div(headerSection, style = styleHeaderDiv),
        html.Div([
            html.Div(inputSection, style = styleInputDiv),
            html.Div(mapSection, style = styleMapDiv)
        ], style = styleMainSection)

    ], style = styleContainer)

    # CALLBACKS
    @app.callback(
        dash.dependencies.Output('output-graph', 'figure'),
        [
            #dash.dependencies.Input('submit-button', 'n_clicks'),
            dash.dependencies.Input('display-selector', 'value'),
            dash.dependencies.Input('libact-selector', 'value')
        ],
        [
            #dash.dependencies.State('libact-checklist', 'value')
        ]
    )
    def update_output(display_type, libact_list):
        return figure.get_figure(libact_list, display_type)

    # RUN SERVER
    app.run_server(debug=False, port=8052)

styleContainer = {
    'width': '100vw',
    'height': '100vh',
    'padding': '0px',
    'flex-direction': 'column',
    'display': 'flex'
}

styleHeaderDiv = {
    'font-family': 'monospace',
    'color': '#ebf5ff',
    'backgroundColor': '#007eff',
    'padding': '8px',
    'font-size' : '12px'
}

styleDisplaySelector = {
    'width': '20ch',
}


styleLibactSelector = {
    'width': '40ch',
    'height': '50%'
}

styleMainSection = {
    'overflow': 'hidden',
    'flex': '1',
    'flex-direction': 'row',
    'display': 'flex'
}

styleMapDiv = {
    'flex': '1'
}

styleMap = {
    'height': '100%',
    'width': '100%'
}

styleInputDiv = {
    'font-family': 'monospace',
    'color': '#007eff',
    'backgroundColor': '#ebf5ff',
    'padding': '8px',
    'flex-direction': 'column',
    'display': 'flex'
}

styleInput = {
    'overflow-y': 'scroll',
    'flex-direction': 'column',
    'display': 'flex'
}