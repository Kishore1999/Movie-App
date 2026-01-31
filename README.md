# Movie-App
# The Movie Database

A SwiftUI iOS app that integrates with The Movie Database (TMDb) API to browse popular movies, search, view details, and manage favorites.

## Setup

### Requirements
- Xcode 15.0+
- iOS 17.0+
- TMDb API Key (free at [themoviedb.org](https://www.themoviedb.org/settings/api))

### Configuration

1. Clone the repository
2. Open `The Movie Database.xcodeproj` in Xcode
3. Add your TMDb API key in `Network/Constants.swift`:
   ```swift
   enum APIConstants {
       static let apiKey = "YOUR_API_KEY_HERE"
       // ...
   }
   ```
4. Build and run (Cmd + R)

### Dependencies
- **None** - Pure SwiftUI implementation with no external packages

## Implemented Features

### Home Screen
- Netflix-style 3-column grid layout
- Infinite scroll with pagination
- Pull to refresh
- Shimmer loading animation during search

### Search
- Debounced search using Combine (500ms delay)
- Real-time results as you type
- Empty state for no results

### Movie Details
- Hero backdrop image with gradient overlay
- Play trailer button (opens YouTube)
- Movie metadata: title, rating, runtime, release year, tagline
- Genre tags
- Plot overview
- Horizontal scrolling cast list with profile images

### Favorites
- Add/remove movies from favorites
- Persisted using UserDefaults
- Dedicated Favorites tab
- Bounce animation on heart button

### Context Menu
- Long press on movie poster for quick actions:
  - Play Trailer
  - Add/Remove from Favorites

### Performance
- Custom image caching (memory + disk)
- Cached images load instantly on scroll

## Architecture

```
The Movie Database/
├── Models/           # Data models (Movie, MovieDetail, Credits, Videos)
├── Network/          # API layer (NetworkManager, Endpoints, Constants)
├── ViewModels/       # Business logic (MoviesListViewModel, MovieDetailViewModel)
├── Views/
│   ├── Components/   # Reusable UI (FavoriteButton, CachedAsyncImage, ShimmerView)
│   ├── Home/         # Movies list and grid
│   ├── Detail/       # Movie detail screen
│   └── Favorites/    # Favorites list
└── Utilities/        # Helpers (YouTubeHelper)
```

## Assumptions

- User has a valid TMDb API key
- Internet connection is required for all features
- YouTube app is optional (falls back to Safari for trailers)
- Device runs iOS 17 or later

## Known Limitations

| Limitation | Reason |
|------------|--------|
| Trailers open externally | YouTube embed returns Error 153 in WKWebView due to playback restrictions |
| Swipe-to-go-back disabled on detail view | Custom navigation bar back button overrides system gesture |
| No offline mode | App requires network for all data |
| No unit/UI tests | Not implemented in this POC |
| Favorites limited to ~100 movies | UserDefaults storage constraint |

## API Endpoints Used

| Feature | Endpoint |
|---------|----------|
| Popular Movies | `GET /movie/popular` |
| Search Movies | `GET /search/movie` |
| Movie Details | `GET /movie/{id}` |
| Movie Credits | `GET /movie/{id}/credits` |
| Movie Videos | `GET /movie/{id}/videos` |

## Screenshots
<img width="1170" height="2532" alt="IMG_1415" src="https://github.com/user-attachments/assets/334dfe72-601b-43a4-b3ec-7a6e01b39985" />

<img width="1170" height="2532" alt="IMG_1416" src="https://github.com/user-attachments/assets/1629f559-44f3-437c-9f43-c2888f19d7fa" />
<img width="1170" height="2532" alt="IMG_1417" src="https://github.com/user-attachments/assets/f03f9582-60b6-46b1-87df-ceb26bb9fee3" />
<img width="1170" height="2532" alt="IMG_1418" src="https://github.com/user-attachments/assets/206001fe-4555-4220-945d-26960d4fd8d6" />


## License

This project is for demonstration purposes only. TMDb API usage is subject to their [Terms of Service](https://www.themoviedb.org/terms-of-use).
