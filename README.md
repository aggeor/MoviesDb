# MoviesDb
> A mobile app for discovering and exploring movies from themoviedb.org.

[![Swift Version][swift-image]][swift-url]

Browse an extensive directory of movies with high-quality posters and details, including titles, overviews, release dates, ratings, genres, and runtime.  

Each movie has a dedicated detail view showing comprehensive information and cast members. You can explore the main actors in each film, including their names, characters, and profile pictures.

## Requirements

This project was built using **Xcode 26.0.1** and **Swift 6.2**. Mac/macOS is required.

## Installation

1. Install Xcode
2. Clone repository using Xcode

```
git clone https://github.com/aggeor/MoviesDb.git
```

3. Create Secrets.plist to store TMDb api key:
    1. In `XCode`, Create a new `Secrets.plist` file in the top level directory of the project
    2. Add `API_KEY` with your api key `value`
    3. Select Project on left side navigation panel and go to `Project` → `Build Settings` → `Packaging`.
    4. Under Packaging, change `Info.plist File` value to `Secrets.plist`

4. Create a simulator device to run the app
5. Run the app

## App architecture

The app uses MVVM (Model-View-ViewModel) architecture:

Main screen:
MainView → MainViewModel → Movie

Detail screen:
MovieDetailView → MovieDetailViewModel → MovieDetails + Credits

Networking uses URLSession and is mockable for tests. Movie data is displayed using SwiftUI views and LazyVGrid for the movie grids.

## Features

- Browse popular movies.

- Search for movies.

- View detailed information for each movie:

  - Overview(Title, Poster image)

  - Genres

  - Release date

  - Runtime
  
  - Rating and vote count

  - Production Status

  - External navigation to TMDb and IMDb through web views
  
  - Description

  - Cast members (with names, characters, and profile pictures) with navigation to external profile web views


## Screenshots

| Main Screen | Search Results | Movie Details | Cast Webview | Link Webview |
|------------|----------------|---------------|--------------|--------------|
| <img width="200" alt="Main Screen" src="https://github.com/user-attachments/assets/e7b59a85-2f93-4fa8-a80a-e713aed5f358" /> | <img width="200" alt="Search Results" src="https://github.com/user-attachments/assets/2ed97d90-3202-489e-97f8-175ae7e0c783" /> | <img width="200" alt="Movie Details" src="https://github.com/user-attachments/assets/1d389dac-38c6-44e4-be41-16ec4923091c" /> | <img width="200" alt="Link Webview" src="https://github.com/user-attachments/assets/ab12d86c-bb39-4360-930f-c627c4a2451e" /> | <img width="200" alt="Cast Webview" src="https://github.com/user-attachments/assets/0613f959-2b7d-40de-85c2-a37da5a55bbe" /> |


## Testing

Unit tests are included using XCTest.

- **MainViewModelTests**
  - Tests the main screen logic for fetching popular movies and searching.
  - Handles:
    - Success responses
    - Empty results
    - Partial or malformed JSON
    - Pagination (`fetchNextIfNeeded`)
  - Uses `MockURLProtocol` for network mocking.

- **MovieDetailViewModelTests**
  - Tests fetching movie details and credits.
  - Handles:
    - Success responses
    - Invalid URLs
    - Server errors (e.g., 500)
    - Partial or malformed JSON
  - Uses `MockURLProtocol` for mock network responses.


- **MovieModelsTests**
  - Tests decoding of `Movie`, `MovieDetail`, and `Credits` models from JSON.
  - Validates:
    - Correct parsing of fields
    - Proper handling of optional or missing fields
    - Data integrity when mapping JSON to models
    - Date formatting helper function

## Credits

Used Swift with SwiftUI

Used [themoviedb.org api](https://developer.themoviedb.org/)

## Contact
Aggelos Georgiadis – [LinkedIn](https://www.linkedin.com/in/aggelos-georgiadis-16a1b6189/) - [Github](https://github.com/aggeor/) – ag.gewr@gmail.com

[swift-image]:https://img.shields.io/badge/swift-6.2-orange.svg
[swift-url]: https://swift.org/
