# CountryList App - VIPER Architecture with SwiftUI

This app demonstrates the use of the VIPER architecture, implemented with SwiftUI, Networking Layer, and Local Storage for saving favorites and details. The app also includes a customizable design with a skeleton loader for loading screens.

## Features

- **VIPER Architecture**: The app follows the VIPER pattern (View, Interactor, Presenter, Configurator, Router) for clean architecture and separation of concerns.
- **Networking Layer**: A modular networking layer to handle API requests and responses.
- **Local Storage**: The app supports saving user preferences like favorites using local storage, ensuring that data persists across app sessions.
- **SwiftUI**: The app uses SwiftUI for the details screen.
- **Customizable Design**: The design is fully customizable, allowing easy adjustments UI elements.
- **Skeleton Loader**: A skeleton loader is used to provide a placeholder UI during data fetching.

## Architecture

This app follows the VIPER (View, Interactor, Presenter, Entity, Router) architecture to promote modularity and maintainability. The key components of the architecture are as follows:

- View: The XIB views that handle the user interface.
- Interactor: Calling the networking layer.
- Presenter: The component that formats data from the Interactor to be displayed in the View.
- Router: Handles navigation logic and routing between different screens.

## Networking
The networking layer handles all API requests and responses. It uses URLSession for making network calls and provides methods for interacting with RESTful APIs. Responses are parsed into model objects that are passed to the Interactor.

## Local Storage
The app uses local storage to save user preferences such as favorites and details. This is achieved using UserDefaults or CoreData, depending on the type of data stored.

## UI Design
The UI is built using SwiftUI & UIKit, which is easy to use and maintain. The app supports a customizable design.
