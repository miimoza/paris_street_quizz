# main.py

import figure
import server

# Paris Clusters

def main():
    figure.load_geojson('data/voie.geojson')
    server.start_server('Paris Clusters β')

if __name__ == '__main__':
    main()
