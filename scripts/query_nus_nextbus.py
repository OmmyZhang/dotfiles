#!/usr/bin/env python3
import requests
import sys


stop = sys.argv[1] if len(sys.argv) > 1 else "LT27"

headers = {
    "User-Agent": "NextBus Bot (email:me@hereiszyn.com)"
}
r = requests.get(f"https://nnextbus.nusmods.com/ShuttleService?busstopname={stop}", headers=headers)

if r.status_code == 200:
    data = r.json()
    print(f"<b>{stop}</b>")
    try:
        for bus in data["ShuttleServiceResult"]["shuttles"]:
            if not bus["name"].startswith("PUB"):
                print(f"{bus['name']}: {bus['arrivalTime']} {bus['nextArrivalTime']}")
    except KeyError:
        pass