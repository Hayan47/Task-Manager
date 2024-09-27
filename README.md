# Task Manager Application

This is a Flutter mobile application that interacts with the DummyJSON API, implements authentication using JWT (JSON Web Token), stores access and refresh tokens in secure storage, and refreshes tokens automatically using Dio. The app also displays a list of to-dos, handling pagination and caching data locally with SQLite.

## Features

- **Authentication with JWT**: The app authenticates users using JWT, storing both the access token and refresh token securely.
- **Secure Storage**: Access and refresh tokens are stored using `flutter_secure_storage` to ensure security.
- **Token Refresh**: The application automatically refreshes the access token when it expires using Dio interceptors.
- **To-do List**: Displays a list of to-dos fetched from the DummyJSON API.
- **Pagination**: To-dos are loaded in pages with efficient scrolling using pagination.
- **Caching with SQLite**: Cached to-do data is stored locally using SQLite for offline access.
- **Internet Connectivity Handling**: The app handles internet connectivity changes and shows appropriate feedback to the user when the internet connection is lost or restored.

## Technologies & Libraries

- **Flutter**: The UI framework used for building the app.
- **Dio**: For making HTTP requests, handling authentication, and refreshing tokens.
- **flutter_secure_storage**: To store access and refresh tokens securely on the device.
- **SQLite**: Used for caching and storing to-do data locally.
- **BLoC (Business Logic Component)**: For state management.
- **Connectivity Plus**: To check for internet connectivity and handle offline scenarios.

## API

This app uses the [DummyJSON API](https://dummyjson.com/) for to-do data and authentication. You can refer to the DummyJSON API documentation for more information.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Hayan47/Task-Manager
   ```

2. Navigate to the project directory:

   ```bash
   cd Task-Manager
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the App
   
   ```bash
   flutter run
   ```

## Usage

## Authentication
1. Upon launching the app for the first time, you will be prompted to log in using your credentials.
2. The app will fetch an access token and a refresh token, which are stored securely using flutter_secure_storage.
3. The access token is used to authenticate API requests, and it will automatically refresh when expired using the refresh token.

## To-Do List
1. After authentication, the app displays a list of to-dos fetched from the DummyJSON API.
2. The app supports pagination, fetching additional tasks as you scroll.
3. Caching: Data is cached locally using SQLite, allowing users to view previously fetched to-dos even without an internet connection.

## Offline Mode
- The app automatically detects when there is no internet connection and allows the user to browse cached data.
- When internet connectivity is restored, the app syncs with the API and fetches the latest data.

## ScreenShots
<p align="center">
  <img src="https://github.com/Hayan47/Hayan47/blob/main/photo_2024-09-27_22-28-31.jpg" width="40%" />
  <img src="https://github.com/Hayan47/Hayan47/blob/main/photo_2024-09-27_22-28-31%20(2).jpg" width="40%" />
</p>
