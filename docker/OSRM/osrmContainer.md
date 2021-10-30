osrmContainer
=============
### Motivation
---
Economic activities that involve logistics deal with coordinate points of departure and arrival, from which other relevant data like distance and trajectory must automatically be derived.  
This API is intended to do that, and produce a distance calculation or a verctor trajectory marked by intermediate points 

---

### Dockerfile

This container is based on the [OSRM](https://github.com/Project-OSRM/osrm-backend) project, and it requires the installation of the command [wget](https://www.gnu.org/software/wget/), which is done using the option '[--no-install-recommends](https://ubuntu.com/blog/2019/11/15/we-reduced-our-docker-images-by-60-with-no-install-recommends)' for the purpose of reducing container size. It contains a full image of open source geodata, which can introduce a large amount of data into the container, as in this case, which loads the latest, vector, full [road network of Denmark]( http://download.geofabrik.de/europe/denmark-latest.osm.pbf ).  

The resulting Docker container, according to the base [Dockerfile](https://github.com/Project-OSRM/osrm-backend/blob/master/docker/Dockerfile) on the OSRM repository, builds upon a Debian Linux distribution, and receives API calls over the http protocol on port 5000.  

Besides that, it requires the request be formated as a pair of WGS84 coordinates, first longitude, then latitude. However, one of the possible internet sources of coordinates, as in the case of maps.google.com, where these coordinates are given as "latitud, longitude" pairs.  

---
### Python script
Thus, in order to always meet the container requirements (i.e. for the request to always be a success) a python script was written to take care of:
* [x] Forming the correct request string to the container

* [x] Which includes the right order of origin and destination coordinates (x, y)

* [x] As well as ensuring the correct projection of these coordinates to WSG84

* [x] Accept batch jobs passed on a csv file

A typical request is :
GET /{service}/{version}/{profile}/{coordinates}[.{format}]?option=value&option=value

There are many services supported:

    route, nearest, table, match, trip, tile

The coordinate input can be a string of two points, [or multipoint, defining the route], or a polyline:

    {longitude},{latitude};{longitude},{latitude}[;{longitude},{latitude} ...]
    {polyline} or {polyline6}

The script is written to accept csv files structured as 'IdColumn', 'quantity', 'aX', 'aY', 'vehicleType', 'bX', 'bY' (being 'aX,aY' origin coordinates; 'bX,bY' destination coordinates; and 'quantity' is the tonage). The output file is structured as  an 'idColumn', 'quantity', 'vehicleType', 'routeLength', 'routeWeight', which can be joined to the initial data by 'idColumn'.

The returning response of a single http request is a serialised string (.json).

