<<<<<<< HEAD
User Directory Application (Advanced)

A scalable and production-ready Flutter application demonstrating clean architecture, robust state management, API integration, and offline-first design.

✨ Overview

This application fetches user data from a remote API and presents it with advanced features like search, pagination, error handling, and offline caching—mimicking real-world app behavior.

🚀 Key Features

👥 User Listing & Detail View
Fetches live data from JSONPlaceholder API
Displays:
Name
Email
City (from nested address)
Detailed user screen with:
Full name
Email & Phone
Website
Complete address
Company details

🔄 Advanced State Management
Explicit state modeling using sealed classes:
Loading
Success
Error
Empty
PaginationLoading
Predictable and maintainable state transitions
Built using Riverpod + StateNotifier

🔍 Search Functionality
Real-time search by user name
Case-insensitive filtering
Debounced input (300ms) for performance optimization

📜 Pagination (Client-Side)
Infinite scrolling implementation
Data loaded in batches of 6 users
Smooth UX without API pagination support

⚠️ Error Handling & Retry
Graceful API failure handling
User-friendly error UI
Retry mechanism triggers fresh API call

🌐 Offline Support (Bonus)
API response cached using local storage
Automatically falls back to cached data when offline
Improves reliability and user experience

🏗️ Architecture

This project follows Layered Clean Architecture to ensure scalability and maintainability.

lib/
│
├── data/           # API services, models, local storage
├── domain/         # Business logic, repository contracts
├── presentation/   # UI, state management (Riverpod)
│
└── core/           # Common utilities, constants, helpers

🔹 Architecture Highlights
Clear separation of concerns
Testable and modular codebase
Scalable structure for larger applications

⚙️ State Management Choice

Riverpod is used because:

Compile-time safety
Better dependency management
No reliance on BuildContext
Highly scalable for large apps

🛠️ Tech Stack
Category	Technology
Framework	Flutter
State Management	Riverpod
Networking	Dio
Local Storage	SharedPreferences
Code Generation	Freezed, JSON Serializable
UI Enhancements	Shimmer (Skeleton Loading)

📦 Performance Optimizations
Efficient list rendering using ListView.builder
Debounced search to reduce unnecessary rebuilds
Controlled state updates to avoid UI over-rendering

▶️ Getting Started
✅ Prerequisites
Flutter SDK (latest stable)
Dart SDK

👨‍💻 Author

Aman Chaudhary
=======
# AviaraAssignment
AviaraAssignment
>>>>>>> 57338651aa19ca1a53469fcfbda7ea28e5a37297
