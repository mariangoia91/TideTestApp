# TideTestApp

## Installation and prerequisites
There are no prerequisites as no third parties were used. Just have XCode 8.x installed preferably, as the requirement said Swift 3.

## Running the app
For best behavior, running on a device OR with an iOS Simulator with Address Simulation turned on provides the best results.

# Architecture
The project was architectured around a classic MVC design pattern. Considering the requirement - which is rather straight forward, I've considered that picking a different structural architecture for the project would just overcomplicate things.

## Other design patterns used
I've used the Decorator pattern with the TTALocationManager delegate, as the data it provides is only used by one viewcontroller at a certain time, therefore only one-to-one relationships between classes were required, and delegation is ideal for these kind of relationships. Also used it for the extension of UIViewController to add an activity indicator to it.

The singleton pattern was used for the LocationManager, we have one instance that stays alive and only gets initialised once - pretty much exactly what we need for a continuous location listener.

Also, I've used Facade pattern in the LocationManager, providing a nice and easy to use and understand interface for the manager's functionalities

# Overall Approach to the problem
The approach was very straight forward:
1. Build a tab-bar
2. Build two viewcontrollers, one with a table, one with a map
3. Build a location manager to get the location
4. Implement the request for bars around the location obtained from component 3
5. Populate the table and the map
6. Implement table behavior
7. Implement map behavior
8. Write this readme

# Places I would improve if time was infinite
1. The first thing I would improve to this project is to implement a smart caching mechanism, so that not only the app works when offline, but that if the user is inside a "zone" (center location + radius) he has visited before, the request for bars is not made, but the data gets retrieved from the cache. I've already added CoreData and a DB to the project with the intent of implementing this.
2. A prettier implementation of the Google Places getter, with a fully mature "Place" object and proper mapping of all its components. The current implementation is "quick and dirty", as it does the exact requested job for the given requirement of the test but is not a scalable solution.
3. Some prettier UI, but as it was not requested, I have not added any.
4. Maybe a bar detail screen
5. More information inside the map annotation, maybe a picture of the bar (would have required a custom annotation view and those are a bit of a pain to make)

# Testing
I was asked to make this test in a rush so I didnt't get to implement the unit tests. Here's a list of tests that I would implement.

1. Tests for the Google Place helper, to see if all the "real" results are shown. In order to do this, check for a location (lat, long, and a radius) where you know the amount of bars that will be returned (just by doing a request on the Google Places API web client) and then checking against the number of results returned by 'googlePlacesForLocation'.
Also, for 'distanceBetweenLocations' checking the distance between two locations on google maps, grabbing their coordinates and feeding them to our method to check if it returns correct results.

2. Tests for the location manager:
- checking if the location manager is enabled, if not, checking if the alert explaining what to do is shown
- checking if the delegate method 'locationFound' feeds a valid location
