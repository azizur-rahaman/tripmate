# TripMate

A Flutter application for discovering cities with weather information and beautiful imagery.

## Features

- 🔍 City search with autocomplete using Geoapify API
- 🌤️ Real-time weather information via OpenWeatherMap
- 📸 Beautiful city images from Unsplash
- 💾 Local caching with Isar database
- 📱 Clean architecture with BLoC pattern

## Setup

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK
- iOS/Android development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/azizur-rahaman/tripmate.git
   cd tripmate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   
   Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

4. **Get API Keys**

   You need to obtain API keys from the following services:

   - **Geoapify** (City Search)
     - Sign up at: https://geoapify.com
     - Free tier: 3,000 requests/day
     - Add your key to `.env`: `GEOAPIFY_API_KEY=your_key_here`

   - **OpenWeatherMap** (Weather Data)
     - Sign up at: https://openweathermap.org/api
     - Free tier: 1,000 requests/day
     - Add your key to `.env`: `WEATHER_API_KEY=your_key_here`

   - **Unsplash** (City Images)
     - Sign up at: https://unsplash.com/developers
     - Create a new application
     - Add your keys to `.env`:
       - `UNSPLASH_ACCESS_KEY=your_access_key_here`
       - `UNSPLASH_SECRET_KEY=your_secret_key_here`

5. **Run the app**
   ```bash
   flutter run
   ```

## Environment Variables

The app uses `flutter_dotenv` to manage API keys securely. Never commit your `.env` file to version control.

**Required environment variables:**
- `GEOAPIFY_API_KEY` - Geoapify geocoding API key
- `WEATHER_API_KEY` - OpenWeatherMap API key
- `UNSPLASH_ACCESS_KEY` - Unsplash access key
- `UNSPLASH_SECRET_KEY` - Unsplash secret key

## Architecture

This project follows Clean Architecture principles with the following layers:

- **Presentation Layer**: BLoC pattern for state management
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Repositories and data sources (remote & local)

## Tech Stack

- **State Management**: flutter_bloc
- **Networking**: dio, retrofit
- **Local Database**: isar
- **Dependency Injection**: get_it
- **Image Caching**: cached_network_image
- **Environment Variables**: flutter_dotenv

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
