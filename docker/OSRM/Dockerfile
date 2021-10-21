FROM osrm/osrm-backend
RUN apt-get update && apt-get install -y --no-install-recommends wget

RUN mkdir /data
RUN wget http://download.geofabrik.de/europe/denmark-latest.osm.pbf -O /data/denmark-latest.osm.pbf

RUN /usr/local/bin/osrm-extract -p /opt/car.lua /data/denmark-latest.osm.pbf
RUN /usr/local/bin/osrm-partition /data/denmark-latest.osrm
RUN /usr/local/bin/osrm-customize /data/denmark-latest.osrm

ENTRYPOINT /usr/local/bin/osrm-routed --algorithm mld /data/denmark-latest.osrm
