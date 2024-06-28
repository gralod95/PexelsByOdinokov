# Project Overview: Pexels Image Feed
The Pexels Image Feed project is an iOS application designed to display an infinite scroll feed of images sourced from the Pexels API. Developed as a test task, the project aims to provide a seamless browsing experience with the following core functionalities:

- **Infinite Scrolling**: Continuously loads images as the user scrolls down the feed.
- **Detail View**: Allows users to view a full-sized image and additional details.
- **Smooth Performance**: Ensures efficient loading and display of images through effective caching and networking practices.

# Key Technologies and Architecture
The project is built using the MVVM (Model-View-ViewModel) architecture, which promotes a clear separation of concerns and enhances maintainability.

Technologies Used:

- UIKit
- URLSession
- Swift Concurrency

# System Design
<img width="810" alt="image" src="https://github.com/gralod95/PexelsByOdinokov/assets/18089555/f75f865a-5254-4439-878b-228b9239dfc3">

System Design Components:
- Application:
  - App
  - Coordinator
  - Factory
- Scene:
  - ViewController
  - View
  - ViewData
  - ViewModel
- Domain:
  - UseCase
  - State
  - Entities
- Services:
  - Service
  - Dto

# Responsibilities:
- Application Level: Responsible for high-level logic.
- Scene Level: Responsible for feature-level logic.
- Domain Level: Responsible for business logic of the app.
- Services Level: Responsible for networking.

## Responsibilities in Application Level:
- AppDelegate and SceneDelegate: Responsible for reacting to app actions.
- Coordinator: Responsible for opening screens in the proper way and time.
- Factory: Responsible for creating screens.

## Responsibilities in Scene Level:
- ViewController: Manages view lifecycle events and connects the view and viewModel.
- View: Responsible for displaying content properly.
- ViewModel: Manages content retrieval and processing user actions.
- ViewData: A plain entity that defines how the view will display content.

## Responsibilities in Domain Level:
- UseCase: Provides data from cache or network.
- State: Manages cached data.
- Entity: A plain entity returned by the UseCase.

## Responsibilities in Services Level:
- Service: Loads data from the network.
- Dto: A plain entity returned by the Service.

# Pros and Cons of the Chosen Technologies
## Pros:
- Separating the app into several levels enhances maintainability.
- Using UseCase State reduces unnecessary internet traffic.
- Swift concurrency ensures the main thread is used only for UI activities, with other threads handling additional tasks.

## Cons:
- Separating the app into several levels increases development and maintenance costs.
- Using UseCase State increases the app size.

# Potential Improvements
- Add Dependency Injection (DI) for more effective memory management.
- Establish a stronger separation between design levels by using protocols and dividing the project into several modules.
- Implement cache management and cleaning in UseCase State to prevent uncontrolled memory usage.
- Integrate SwiftUI for future enhancements.
- Integrate with data storage to cache data between app launches.
