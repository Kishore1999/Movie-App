# TMDb Movie App - Implementation Plan

## Overview
Build a SwiftUI iOS app integrating with TMDb API featuring popular movies list, search, movie details with trailer playback, and persistent favorites.

## Current State
- Xcode project exists at `/Users/zuperhuman/Documents/Kishore/POC's/The Movie Database`
- `MovieList.swift` has `MovieListData` and `Movie` models (properly mapped)
- `ContentView.swift` has placeholder content
- `Network/` folder is empty
- No ViewModels, no additional Views

---

## Final File Structure

```
The Movie Database/
├── Models/
│   ├── MovieList.swift          # MODIFY - add Identifiable, Hashable
│   ├── MovieDetail.swift        # CREATE
│   ├── MovieCredits.swift       # CREATE
│   ├── MovieVideos.swift        # CREATE
│   └── Genre.swift              # CREATE
│
├── Network/
│   ├── Constants.swift          # CREATE
│   ├── APIError.swift           # CREATE
│   ├── APIEndpoint.swift        # CREATE
│   └── NetworkManager.swift     # CREATE
│
├── ViewModels/
│   ├── MoviesListViewModel.swift    # CREATE
│   ├── MovieDetailViewModel.swift   # CREATE
│   └── FavoritesManager.swift       # CREATE
│
├── Views/
│   ├── Components/
│   │   ├── AsyncPosterImage.swift   # CREATE
│   │   ├── RatingView.swift         # CREATE
│   │   ├── LoadingView.swift        # CREATE
│   │   └── ErrorView.swift          # CREATE
│   │
│   ├── Home/
│   │   ├── MoviesListView.swift     # CREATE
│   │   └── MovieRowView.swift       # CREATE
│   │
│   ├── Detail/
│   │   ├── MovieDetailView.swift    # CREATE
│   │   ├── TrailerPlayerView.swift  # CREATE
│   │   └── CastListView.swift       # CREATE
│   │
│   └── Favorites/
│       └── FavoritesView.swift      # CREATE
│
├── ContentView.swift            # MODIFY - TabView navigation
└── The_Movie_DatabaseApp.swift  # MODIFY - inject FavoritesManager
```

---

## Implementation Phases

### Phase 1: Foundation (Network Layer)
**Files to create:**

1. **`Network/Constants.swift`**
   - API key, base URL, image base URLs
   - Image size constants (w500, w780, w185)

2. **`Network/APIError.swift`**
   - Custom error enum: invalidURL, noData, decodingError, networkError, httpError
   - LocalizedError conformance for user-friendly messages

3. **`Network/APIEndpoint.swift`**
   - Enum cases: popular, movieDetail, movieCredits, movieVideos, search
   - URL building with query parameters

4. **`Network/NetworkManager.swift`**
   - Singleton with shared instance
   - Generic `fetch<T: Decodable>` using async/await
   - Specific methods: `fetchPopularMovies`, `fetchMovieDetail`, `fetchMovieCredits`, `fetchMovieVideos`, `searchMovies`

---

### Phase 2: Models
**Files to create/modify:**

1. **`Models/MovieList.swift`** (MODIFY)
   - Add `Identifiable` and `Hashable` conformance to `Movie`

2. **`Models/Genre.swift`** (CREATE)
   ```swift
   struct Genre: Codable, Identifiable, Hashable {
       let id: Int
       let name: String
   }
   ```

3. **`Models/MovieDetail.swift`** (CREATE)
   - Full movie details with: runtime, genres array, tagline, budget, revenue
   - CodingKeys for snake_case mapping

4. **`Models/MovieCredits.swift`** (CREATE)
   - `MovieCredits` with cast and crew arrays
   - `CastMember`: id, name, character, profilePath, order
   - `CrewMember`: id, name, job, department

5. **`Models/MovieVideos.swift`** (CREATE)
   - `MovieVideos` with results array
   - `Video`: id, key (YouTube ID), name, site, type
   - Computed properties for YouTube URL and thumbnail

---

### Phase 3: Persistence
**File to create:**

1. **`ViewModels/FavoritesManager.swift`**
   - `@MainActor` ObservableObject
   - `@Published favoriteMovies: [Movie]`
   - Store as JSON in UserDefaults (key: `"favorite_movies"`)
   - Methods: `addFavorite`, `removeFavorite`, `isFavorite`, `toggleFavorite`
   - Load on init, save on every change

---

### Phase 4: ViewModels
**Files to create:**

1. **`ViewModels/MoviesListViewModel.swift`**
   - `@Published movies, searchResults, isLoading, error, searchQuery`
   - Popular movies fetching with pagination
   - Debounced search (0.5s delay)
   - `displayedMovies` computed property

2. **`ViewModels/MovieDetailViewModel.swift`**
   - `@Published movieDetail, credits, videos, isLoading, error`
   - Parallel fetch of detail, credits, and videos
   - `trailer` computed property (filter type == "Trailer", site == "YouTube")
   - `topCast` (first 10 cast members)
   - `formattedRuntime` (e.g., "2h 15m")

---

### Phase 5: Reusable Components
**Files to create:**

1. **`Views/Components/AsyncPosterImage.swift`**
   - Wrapper around AsyncImage with placeholder
   - Loading and error states

2. **`Views/Components/RatingView.swift`**
   - Star icon + rating number display
   - Format: "8.5" with star icon

3. **`Views/Components/LoadingView.swift`**
   - Centered ProgressView with optional message

4. **`Views/Components/ErrorView.swift`**
   - Error message display with retry button
   - Closure for retry action

---

### Phase 6: Main Views
**Files to create:**

1. **`Views/Home/MovieRowView.swift`**
   - Poster (60x90) | Title + Rating + Release Year | Favorite heart button
   - Note: Duration NOT shown on list (only on detail page to avoid extra API calls)
   - NavigationLink wrapper

2. **`Views/Home/MoviesListView.swift`**
   - Navigation title "Popular Movies"
   - `.searchable` modifier for search
   - List of MovieRowView items
   - Pagination on scroll to bottom
   - Loading/error/empty states

3. **`Views/Detail/TrailerPlayerView.swift`**
   - UIViewRepresentable wrapping WKWebView
   - YouTube embed URL: `https://www.youtube.com/embed/{key}?playsinline=1`
   - 16:9 aspect ratio

4. **`Views/Detail/CastListView.swift`**
   - Horizontal ScrollView
   - Cast member cards: profile image, name, character

5. **`Views/Detail/MovieDetailView.swift`**
   - ScrollView layout:
     - Backdrop image (top)
     - Trailer player (if available)
     - Title + favorite button
     - Rating | Duration | Release year
     - Genre tags (horizontal)
     - Overview/Plot
     - Cast section

6. **`Views/Favorites/FavoritesView.swift`**
   - List of favorited movies (reuse MovieRowView)
   - Empty state message when no favorites

---

### Phase 7: App Integration
**Files to modify:**

1. **`ContentView.swift`**
   - TabView with two tabs:
     - Movies (film icon) -> MoviesListView
     - Favorites (heart.fill icon) -> FavoritesView

2. **`The_Movie_DatabaseApp.swift`**
   - Create `@StateObject FavoritesManager`
   - Inject via `.environmentObject()`

---

## Key Implementation Details

### API Endpoints
| Endpoint | URL |
|----------|-----|
| Popular | `/movie/popular?api_key={KEY}&page={N}` |
| Details | `/movie/{id}?api_key={KEY}` |
| Videos | `/movie/{id}/videos?api_key={KEY}` |
| Credits | `/movie/{id}/credits?api_key={KEY}` |
| Search | `/search/movie?api_key={KEY}&query={Q}&page={N}` |

### Image URLs
- Poster: `https://image.tmdb.org/t/p/w500{posterPath}`
- Backdrop: `https://image.tmdb.org/t/p/w780{backdropPath}`
- Profile: `https://image.tmdb.org/t/p/w185{profilePath}`

### YouTube Trailer Approach
- Use WKWebView with YouTube embed URL
- Format: `https://www.youtube.com/embed/{videoKey}?playsinline=1`
- No external dependencies required

### Favorites Persistence
- Store `[Movie]` as JSON in UserDefaults
- Key: `"favorite_movies"`
- Encode/decode using JSONEncoder/JSONDecoder

---

## Verification Plan

1. **Build & Run** - Ensure project compiles without errors

2. **Popular Movies**
   - Launch app -> Movies tab shows loading -> Popular movies appear
   - Scroll down -> Pagination loads more movies

3. **Search**
   - Type in search bar -> Results appear after debounce
   - Clear search -> Returns to popular movies

4. **Movie Details**
   - Tap movie -> Detail screen opens
   - Verify: trailer plays, title, rating, duration, genres, cast displayed

5. **Favorites**
   - Tap heart on movie -> Heart fills (favorited)
   - Switch to Favorites tab -> Movie appears
   - Kill app -> Relaunch -> Favorites still there
   - Tap heart again -> Unfavorited, removed from list

6. **Error Handling**
   - Disable network -> Error view with retry button
   - Enable network -> Tap retry -> Data loads

---

## File Count Summary
| Category | New | Modified |
|----------|-----|----------|
| Models | 4 | 1 |
| Network | 4 | 0 |
| ViewModels | 3 | 0 |
| Views | 10 | 0 |
| App | 0 | 2 |
| **Total** | **21** | **3** |

---

## Notes
- No external dependencies (SPM packages not required)
- Minimum iOS target: iOS 15+ (for AsyncImage, async/await)
- User has API key ready - will be added to `Constants.swift`
- Duration shown only on detail page (avoids extra API calls per movie on list)
