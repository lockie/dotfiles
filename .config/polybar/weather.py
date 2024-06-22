#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests

CITY = "3193044" #"545673"
API_KEY = "XXX OPENWEATHERMAP API KEY XXX"
UNITS = "Metric"

try:
    REQ = requests.get("http://api.openweathermap.org/data/2.5/weather?id={}&appid={}&units={}".format(CITY, API_KEY, UNITS))  # noqa
    # HTTP CODE = OK
    if REQ.status_code == 200:
        CURRENT = REQ.json()["weather"][0]["main"].lower()
        TEMP = int(float(REQ.json()["main"]["temp"]))
        HUM = int(float(REQ.json()["main"]["humidity"]))
        WIND = round(float(REQ.json()["wind"]["speed"]))
        print("{} {}% {}m/s {}°C".format(CURRENT, HUM, WIND, TEMP))
    else:
        print("ERR " + str(REQ.status_code))
except:
    print("ERR")
