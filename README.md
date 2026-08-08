# E-Commerce Mobile Application

A production-oriented Flutter e-commerce application built with the **Fake Store API**, designed with a clean architecture, reactive state management, persistent local storage, and a responsive user experience.

The project focuses not only on implementing the required e-commerce features, but also on maintaining a clean separation of concerns, predictable state management, reliable error handling, and a maintainable codebase.

---

## Overview

This application provides a complete e-commerce flow:

**Authentication → Product Discovery → Product Details → Cart Management → Persistent Cart → User Profile**

Users can authenticate through the Fake Store API, browse and search products, filter products by category, inspect product details, manage their shopping cart, and view their profile information.

The application also persists important user data locally so that the experience remains consistent across application sessions.

---

## Features

### Authentication

* User login using the Fake Store API authentication endpoint
* Securely stores the authentication token locally
* Restores authentication state when the application starts
* Handles invalid credentials with user-friendly error messages
* Handles connection failures and request timeouts
* Prevents technical API/Dio exceptions from being exposed directly to users
* Logout functionality
* Clears authentication state when logging out

### Product Discovery

* Fetches products from the Fake Store API
* Displays all available products
* Product cards with relevant product information
* Product details view
* Product images
* Product prices
* Product ratings
* Product descriptions
* Category browsing
* "All" products filter
* Search products by title
* Loading states while retrieving products
* Error states when API requests fail
* Empty states where applicable

### Shopping Cart

* Add products to cart
* Automatically increases quantity when an existing product is added again
* Increase product quantity
* Decrease product quantity
* Automatically removes products when quantity reaches zero
* Remove individual products
* Display individual product prices
* Display product quantities
* Calculate total cart price
* Calculate total item count
* Clear cart
* Persistent cart storage using local storage

### User Profile

* Fetches authenticated user's information from the Users endpoint
* Displays:

  * Full name
  * Username
  * Email
  * Phone number
  * City
  * Street
* Loading state while profile information is retrieved
* Profile error handling
* Logout functionality

### User Experience

* Responsive Flutter UI
* Bottom navigation between:

  * Products
  * Cart
  * Profile
* Interactive product and cart controls
* User-friendly error messages
* Loading indicators during asynchronous operations
* Persistent local application state

---

## Tech Stack

| Technology            | Purpose                                   |
| --------------------- | ----------------------------------------- |
| **Flutter**           | Cross-platform application framework      |
| **Dart**              | Programming language                      |
| **Riverpod**          | State management and dependency injection |
| **Dio**               | HTTP networking and API communication     |
| **SharedPreferences** | Local persistence                         |
| **Fake Store API**    | Product, authentication, and user data    |
| **Git / GitHub**      | Version control                           |

---

## API

The application uses the [Fake Store API](https://fakestoreapi.com/) as its backend.

### Authentication

```text
POST /auth/login
```

Used to authenticate users and obtain an API token.

### Products

```text
GET /products
```

Retrieves all products.

### Product Details

```text
GET /products/{id}
```

Retrieves information about a specific product.

### Categories

```text
GET /products/categories
```

Retrieves available product categories.

### Category Products

```text
GET /products/category/{category}
```

Retrieves products belonging to a specific category.

### Users

```text
GET /users
GET /users/{id}
```

Used to retrieve user information for the profile section.

---

## Architecture

The project follows a feature-oriented architecture designed to keep responsibilities separated and make the application easier to maintain and extend.

```text
lib/
│
├── core/
│   ├── network/
│   │   └── api_client.dart
│   │
│   └── storage/
│       └── local_storage.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── model/
│   │   │   └── user_model.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── profile_screen.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   ├── products/
│   │   ├── model/
│   │   │   └── product.dart
│   │   └── presentation/
│   │       ├── product_screen.dart
│   │       ├── product_details_screen.dart
│   │       ├── widgets/
│   │       │   └── product_card.dart
│   │       └── providers/
│   │           └── product_provider.dart
│   │
│   ├── cart/
│   │   ├── model/
│   │   │   └── cart_item.dart
│   │   └── presentation/
│   │       ├── cart_screen.dart
│   │       └── providers/
│   │           └── cart_provider.dart
│   │
│   └── home/
│       └── presentation/
│           └── home_screen.dart
│
└── main.dart
```

### Architectural responsibilities

**Presentation**

Responsible for displaying UI and responding to user interaction.

**Providers**

Manage reactive application state and coordinate asynchronous operations using Riverpod.

**Repositories**

Handle communication between the application and external data sources.

**Models**

Represent API and application data in strongly typed Dart objects.

**Core**

Contains reusable infrastructure such as networking and local storage.

This separation prevents UI components from becoming responsible for API communication or persistence logic.

---

## State Management

The application uses **Riverpod** for state management.

Riverpod is used for:

* Authentication state
* Authentication loading state
* Product data
* Categories
* Search state
* Selected category
* Cart state
* User profile state
* Dependency injection for repositories and services

For example, the application exposes the cart through an `AsyncNotifierProvider`, allowing the UI to react automatically when cart data changes.

```dart
final cartProvider =
    AsyncNotifierProvider<CartNotifier, List>(
  CartNotifier.new,
);
```

This allows cart operations such as adding, removing, and updating quantities to immediately propagate through the UI.

---

## Local Persistence

The application uses `SharedPreferences` for local persistence.

The following data is stored locally:

### Authentication

```text
token
userId
```

The authentication token allows the application to restore the user's logged-in state when the application starts.

### Cart

Cart items are serialized into JSON and stored locally.

Example:

```json
[
  {
    "id": 1,
    "title": "Fjallraven Backpack",
    "price": 109.95,
    "image": "...",
    "quantity": 2
  }
]
```

When the application starts, the stored cart is decoded and restored into the Riverpod cart state.

This means the cart does not depend solely on the current application process.

---

## Error Handling

Network operations are asynchronous and can fail for several reasons.

The application handles common failure scenarios including:

* Invalid login credentials
* HTTP authentication errors
* Connection timeouts
* Network connection failures
* API request failures
* Product loading failures
* Profile loading failures
* Missing user information
* Empty application states

Technical exceptions are intentionally not displayed directly to users.

For example, instead of displaying a raw Dio exception such as:

```text
DioException [bad response]...
```

the user receives:

```text
Invalid username or password.
```

This keeps technical implementation details inside the application layer while presenting meaningful feedback to users.

---

## Application Flow

```text
                    ┌───────────────┐
                    │   App Launch  │
                    └───────┬───────┘
                            │
                            ▼
                 ┌────────────────────┐
                 │ Check Local Token  │
                 └─────────┬──────────┘
                           │
                 ┌─────────┴─────────┐
                 │                   │
             Token exists        No token
                 │                   │
                 ▼                   ▼
          ┌────────────┐      ┌────────────┐
          │ Home Screen│      │Login Screen│
          └─────┬──────┘      └─────┬──────┘
                │                   │
                │             Successful login
                │                   │
                │                   ▼
                │             ┌────────────┐
                └────────────►│ Home Screen│
                              └─────┬──────┘
                                    │
                 ┌──────────────────┼──────────────────┐
                 │                  │                  │
                 ▼                  ▼                  ▼
             Products              Cart             Profile
                 │                  │                  │
                 ▼                  │                  ▼
           Search / Filter          │               User Data
           Product Details          │                  │
                 │                  │                  ▼
                 └──────────► Add / Manage ◄────── Logout
                              Cart Items
```

---

## Cart Logic

The cart is designed around product identity rather than individual cart entries.

When a product is added:

```text
Product already exists?
        │
   ┌────┴────┐
   │         │
  Yes        No
   │         │
   ▼         ▼
Increase    Create
quantity    cart item
```

Quantity management follows:

```text
Increase → quantity + 1

Decrease → quantity - 1

Quantity reaches 0
        ↓
Remove item
```

The total price is calculated from:

```text
product price × quantity
```

and summed across all cart items.

---

## Running the Project

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Git
* A supported Flutter development environment
* Chrome for Flutter Web testing
* Android/iOS tooling if targeting mobile devices

Verify Flutter:

```bash
flutter doctor
```

### Clone the repository

```bash
git clone <repository-url>
cd ecommerce_app
```

### Install dependencies

```bash
flutter pub get
```

### Run static analysis

```bash
flutter analyze
```

### Run the application

For Chrome:

```bash
flutter run -d chrome
```

For an available mobile device:

```bash
flutter devices
flutter run -d <device-id>
```

---

## Testing the Application

A basic functional verification should cover the following flow.

### Authentication

1. Launch the application.
2. Confirm the login screen appears first.
3. Enter valid Fake Store API credentials.
4. Confirm successful navigation to the application.
5. Try incorrect credentials.
6. Confirm a concise authentication error is displayed.
7. Logout.
8. Confirm the application returns to the login screen.

### Products

1. Confirm products are loaded from the API.
2. Open a product.
3. Confirm product information is displayed.
4. Search by product title.
5. Select a category.
6. Select "All".
7. Verify loading and error states.

### Cart

1. Add a product.
2. Open the cart.
3. Increase quantity.
4. Decrease quantity.
5. Remove the product.
6. Add multiple products.
7. Verify the total price.
8. Verify total item count.
9. Restart the application.
10. Confirm the cart is restored from local storage.

### Profile

1. Open Profile.
2. Confirm user information is retrieved from the API.
3. Verify name, username, email, and phone.
4. Logout.
5. Confirm the authentication session is removed.

---

## Code Quality

The project emphasizes several maintainability principles:

### Separation of Concerns

UI, networking, persistence, models, repositories, and state management are separated rather than being placed into large monolithic widgets.

### Strongly Typed Models

API responses are converted into Dart models rather than passing raw JSON throughout the UI.

### Reactive State

Riverpod allows UI components to react to state changes without manually synchronizing multiple screens.

### Centralized Networking

API communication is handled through a reusable Dio client.

### Local Persistence

Authentication and cart state are stored independently from presentation widgets.

### User-Friendly Error Handling

Backend and networking errors are translated into meaningful application-level feedback.

---

## Design Decisions

### Why Riverpod?

Riverpod provides:

* Reactive state management
* Dependency injection
* Testability
* Clear provider relationships
* Good separation between business logic and UI

### Why Dio?

Dio provides:

* HTTP requests
* Configurable timeouts
* Interceptors
* Structured error handling
* Request/response logging during development

### Why SharedPreferences?

For this assignment, `SharedPreferences` is sufficient for lightweight local persistence such as:

* Authentication tokens
* User identifiers
* Serialized cart data

For a production application containing sensitive credentials or significantly more complex local data, a more secure storage/database solution would be appropriate.

---

## Known API Limitation

This application uses the **Fake Store API**, which is intended for development and demonstration purposes rather than as a production backend.

Therefore:

* Authentication is based on the API's demo users.
* Product data is provided by the external API.
* User information is API-provided demo data.
* The application does not implement real payment processing.
* The application does not represent a production commerce backend.

The project architecture, however, is designed so that the data source can be replaced without requiring the UI to be rewritten.

---

## Future Improvements

Possible extensions include:

* Real user registration
* OAuth / Google authentication
* Secure token storage
* Refresh-token authentication
* Backend-powered persistent carts
* Checkout flow
* Payment integration
* Order history
* Wishlist persistence
* Product pagination
* Advanced filtering and sorting
* Product reviews
* Push notifications
* Automated unit and widget tests
* Offline-first caching
* Better image caching
* Accessibility improvements
* CI/CD pipeline

These are intentionally outside the core scope of the current Fake Store API assignment.

---

## Git Workflow

Git was used throughout development to maintain a clear history of changes.

Commits are organized around meaningful changes rather than large, unrelated batches.

Examples:

```text
feat: implement product browsing
feat: add category filtering
feat: implement cart quantity management
feat: persist cart locally
feat: implement user authentication
feat: add user profile
fix: handle authentication errors
fix: improve cart persistence
```

This makes the development history easier to review and understand.

---

## Project Goals

The goal of this project is not simply to make an application that "works."

The project demonstrates the ability to:

* Consume REST APIs
* Build a responsive Flutter interface
* Manage asynchronous application state
* Structure a maintainable Flutter project
* Persist application data locally
* Handle network and API failures
* Separate presentation from application logic
* Build reusable components
* Think about edge cases and user experience
* Maintain a meaningful Git history

---

## Author

**FADED**
[Mahlet Getinet.  CTC-1238-26]

---

## License

This project was developed for educational and demonstration purposes using the Fake Store API.
