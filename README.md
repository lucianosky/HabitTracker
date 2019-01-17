# HabitTracker
HabitTracker is a productivity app to track daily habits a person wants to persue. It will soon go for testing and later to the App Store.

## Current focus (January 2019): portfolio app
As this moment the focus is to use several technologies from the Swift stack.

## Technologies already implemented
- Browseable month view
- MVVM architecture
- Dependency injection (for later usage with unit testing)
- Basic animation
- View code
- Core data
- RxSwift
- HabitTrackerVapor, a parallel to create an API
- Alamofire access to HabitTrackerVapor

## Data persistance TO DO:
Implement Alamofire 5 (still in Beta). Support offline sync between Core Data and HabitTrackVapor. At this moment the Alamofire calls are commented. I used Alamofire 4.8 with an extension that permits Codable conformance. At this moment there are two different classed that represent an HabitLog. One for Core Data and another for Alamofire.

## Technical stack TO DO:
- Save or export to a Google Calendar
- Firebase usage: logging, crash reporting, warnings
- Unit testing
- UI testing

# App improvement TO DO:
- refactor tableView to view
- create messaging area
- improve animations
- create lock icon
- don't allow changes in future dates
- allow tracking of different habits
- create timeline view
- create all habits view
- create pixel view

# Contribute
Suggestions are welcome, please contact me! :)
