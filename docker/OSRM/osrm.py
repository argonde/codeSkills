#!/usr/bin/python3
# -*- coding: utf-8 -*-
#auth: Ruben López Vázquez
#Calculate distances from WGS84 (UTM) point coordinates from input or .csv file
# -----------------------------------------------------------------

import sys
import argparse
import os
import csv
import requests
import json
import pandas as pd


# Parse input from user
parser = argparse.ArgumentParser()
parser.add_argument('-D',
                    metavar='\"Working Directory\"',
                    help='Usage: Override current directory (include trailing "\\")')
parser.add_argument('-P',
                    metavar='\"Project file\"', help='Usage: Intro csv input file')
parser.add_argument('-N',
                    metavar='\"Output Name\"',
                    help='Usage: Override default csv output name')
parser.parse_args()

# Hardcoded variables here, or use flags to override defaults
# -D = Directory ("c:your/output" - include trailing "/")
directory_loc = r"P:/Company/department/team/workingDirectory/employee/" \
                r"projectNumber/transportAnalysis/"
# -P = Project file
csv_input = 'abTransport.csv'
# -N = output Name
csv_output = 'osrm_output.csv'

# Setting variables using flags ####
if '-D' in sys.argv:
    directory_loc = sys.argv[sys.argv.index('-D') + 1]
if '-P' in sys.argv:
    csv_input = sys.argv[sys.argv.index('-P') + 1]
if '-N' in sys.argv:
    csv_output = sys.argv[sys.argv.index('-N') + 1]

# Project variables
dataIn = os.path.join(directory_loc, csv_input)
result = os.path.join(directory_loc, csv_output)
columns = ['Id', 'Mængde', 'aX', 'aY', 'Biltype', 'bX', 'bY']
url1 = 'https://services.kortforsyningen.dk/?servicename=RestGeokeys_v2&method=koortrans'
url2 = "http://localhost:5000/route/v1/driving/"

# Use pandas fast csv parser to read the input file
if not os.path.isfile(dataIn):
    x = "Could not find JSON with address at: {0}".format(dataIn)
    raise Exception(x)
else:
    # if the file exists, extract the origin & destination coordinates
    places = pd.read_csv(dataIn,
                         sep=';',
                         names=columns
                         )

    # transform the float decimal format from ',' to '.' notation
    aX = places.aX[1:].str.replace(',', '.')
    aY = places.aY[1:].str.replace(',', '.')
    bX = places.bX[1:].str.replace(',', '.')
    bY = places.bY[1:].str.replace(',', '.')
    # use the Pandas data-frame to take its columns into python lists
    alon = aX.tolist()
    alat = aY.tolist()
    blon = bX.tolist()
    blat = bY.tolist()
    qid = places.Id[1:].tolist()
    vol = places.Mængde[1:].tolist()
    carrier = places.Biltype[1:].tolist()

    # loop through the inputfile, and send translate request if needed ...
    outputFileB = 'wgs84_bCoordinates.json'
    wgsDataB = []
    with open(os.path.join(directory_loc, outputFileB), 'w') as jFile:
        # create dictionary to avoid redundant requests
        calls = {}
        # ... on the destination data points
        n1 = 0
        for coordb in blon:
            while n1 < 1:
                if coordb[2] == '.':
                    print('destination coordinates are WGS84')
                    n1 += 1
                else:
                    print('destination coordinates are UTM: translating to WGS84 ...')
                    n = 0
                    for lon, lat in zip(blon, blat):
                        # translate points
                        points = "&ingeop={0},{1}&token=038not25a00real3g0token93br36b21".format(
                            lon, lat)
                        # send 1st request to kortforsyningen: translation to WGS84
                        r = url1 + str(points)
                        if r in calls:
                            n += 1
                            print('request nr.{0} returns: Found local.'.format(n))
                            wgsDataB.append(calls.get(r))
                        else:
                            r1 = requests.get(r)
                            rp1 = r1.json()
                            n += 1
                            print('request nr.{0} returns: '.format(n) + str(r1))
                            response = rp1['Points']
                            wgsDataB.append(response)
                            calls.update({r: response})
                    # save response to .json as backup
                    json.dump(wgsDataB, jFile)
                    n1 += 1
        del calls
    outputFileA = 'wgs84_aCoordinates.json'
    wgsDataA = []
    with open(os.path.join(directory_loc, outputFileA), 'w') as jFile:
        # create dictionary to avoid redundant requests
        calls = {}
        # ... on the start data points
        n2 = 0
        for coorda in alon:
            while n2 < 1:
                if str(coorda)[2] == '.':
                    print('departure coordinates are WGS84')
                    n2 += 1
                else:
                    print('departure coordinates are UTM: translating to WGS84 ...')
                    n = 0
                    for lon, lat in zip(alon, alat):
                        # translate points 
                        points = "&ingeop={0},{1}&token=038not25a00real3g0token93br36b21".format(
                            lon, lat)
                        # send 1st request to kortforsyningen: translation to WGS84
                        r = url1 + str(points)
                        if r in calls:
                            wgsDataA.append(calls.get(r))
                            n2 += 1
                        else:
                            r2 = requests.get(r)
                            n += 1
                            print('request nr.{0} returns: '.format(n) + str(r2))
                            rp2 = r2.json()
                            response = rp2['Points']
                            wgsDataA.append(response)
                            calls.update({r: response})
                    # save response to .json as backup
                    json.dump(wgsDataA, jFile)
                    n2 += 1
        del calls

    # pick from kortfosyningen's response the translated coordinates: read wgsData
    json_dept = os.path.join(directory_loc, outputFileA)
    json_dest = os.path.join(directory_loc, outputFileB)
    destinationData = []
    departureData = []

    # ... on destination data
    if os.stat(json_dest).st_size == 0:
        print("now gathering the WGS84 destination data ...")
        for j in zip(blon, blat):
            destinationData.append(j)
    else:
        # if the file exists, loop through it and save the paired destination points
        with open(json_dest, 'r') as jDictB:
            destinations = json.load(jDictB)
            # extract the destination wgs84 coordinates from the json response
            for z in destinations:
                for y in z:
                    destinationData.append(y['coordinates'])
    print('Got destination data: OK')

    # ... on departure data
    if os.stat(json_dept).st_size == 0:
        print("now gathering the WGS84 departure data ...")
        for k in zip(alon, alat):
            departureData.append(k)
    else:
        # if the file exists, loop through it and save the paired destination points
        with open(json_dept, 'r') as jDictA:
            departures = json.load(jDictA)
            # extract the destination wgs84 coordinates from the json response
            for z in departures:
                for y in z:
                    departureData.append(y['coordinates'])
    print('Got departure data: OK')

    # request from local server distances between UTM (translated) coordinates
    routeLength = []
    routeWeight = []
    calls = {}
    n = 0
    for a, b in zip(departureData, destinationData):
        # request distance calculation between points
        route_csv = "{0},{1};{2},{3}?steps=false&alternatives=false".format(
            a[0], a[1], b[0], b[1])
        r = url2 + str(route_csv)
        r3 = requests.get(r)
        rp3 = r3.json()
        response3 = rp3['routes']
        if r not in calls:
            n += 1
            print(r)
            for s in response3:
                routeLength.append(s['distance'])
                # routeWeight.append(s['weight'])
                calls.update({r: response3})
        else:
            n += 1
            print('request nr.{0} returns: Found local.'.format(n))
            for t in response3:
                routeLength.append(t['distance'])
                routeWeight.append(t['weight'])

    # output: 'qid', 'vol', 'carrier', 'distance', 'weight'
    dataOut = zip(qid, vol, carrier, routeLength, routeWeight)

    # create the output data file to be written at the end
    with open(result, 'w') as outfile:
        wr = csv.writer(outfile, delimiter=',', lineterminator='\n')
        wr.writerows(dataOut)
print('Please find the results in {0}'.format(result))
