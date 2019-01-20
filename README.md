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
- RxSwift
- Serialization with Codable protocol
- Core data local persistance
- [HabitTrackerVapor](https://github.com/lucianosky/HabitTrackerVapor), a [Vapor](https://vapor.codes/) backend project to create an API
- Alamofire access to Vapor Cloud backend
- Unit Testing and BDD with Quick and Nimble
- Firebase integration: Crashlytics (crashes & non critical errors), remote config, event logging

## Design
- The UI and UX were also created by the app author
- Color palette: [Dracula](https://github.com/dracula/dracula-theme/) Theme

## Data persistance TO DO:
- Implement Alamofire 5 (still in Beta). I used Alamofire 4.8 with an extension that permits Codable conformance.
- Support offline sync between Core Data and HabitTrackVapor.
- At this moment the Alamofire calls are commented.
- Refactor two different classed that represent a HabitLog. One for Core Data and another for Alamofire.

## Technical stack TO DO:
- Firebase: login 
- Save or export to a Google Calendar
- Increase unit testing coverage
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
