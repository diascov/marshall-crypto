# Marshall Crypto

## Overview  
**Marshall Crypto** is an iOS application created as part of the interview process for a Senior iOS Developer position at **Marshall Group**, Stockholm, Sweden.

---

## Installation and Environment Setup  

### Requirements:  
- **Xcode**: Version 16.0  
- **Minimum Deployment Target**: iOS 17.0  

---

## Dependencies (SPM):  
- [Firebase iOS SDK](https://github.com/firebase/firebase-ios-sdk) **v11.5.0**  
- [Google Sign-In iOS](https://github.com/google/GoogleSignIn-iOS) **v8.0.0**  
- Core feature package is injected directly into the main `MarshallCrypto` target.

---

## Features  

### Authentication  
- **Sign in with Google**:  
  - Users authenticate using their Google account.  
  - On selecting "Sign in with Google," users are prompted to provide consent. The flow handled by Google and stored in Google frameworks.

---

### Crypto Currencies List  
- **Main functionality** includes:  
  - Display of real-time cryptocurrency prices using the [CoinGecko API](https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd).  
  - Conversion of prices between USD and SEK using the [Exchange Rate API](https://v6.exchangerate-api.com/v6/api_key/latest/USD).  
  - **Search**: Filters the list based on input characters (found in names).  
  - **Settings**:  
    - **Show prices in SEK**: Toggles between USD and SEK, recalculating prices as needed.  
    - **Sort by**:  
      - **Name**: Alphabetical order.  
      - **Rank**: From highest to lowest rank.  
      - **Current price**: From highest to lowest.  

- **List Features**:  
  - **Icons**: Displays the cryptocurrency icon.  
  - **Daily Change Indicator**:  
    - Green arrow for positive changes.  
    - Red arrow for negative changes.  
  - **Prices**: Rounded to 2 decimals, with values below 0.01 displayed as `"-"`.  
  - **Favorites**:  
    - Mark items as favorites by tapping the ⭐ on the details screen.  
    - Favorites are shown in a separate section.  

- **Profile Access**:  
  Tap the profile icon to view account details.  

---

### Crypto Currency Details  
- Information includes:  
  - Name and abbreviation.  
  - Cryptocurrency icon.  
  - Last update timestamp.  
  - Current, highest, and lowest prices in the selected currency (USD/SEK).  
  - Daily price change.  
  - Toggle for marking the currency as a favorite.  

---

### Profile  
- Accessible from the "Crypto Currencies List" screen.  
- Displays:  
  - User’s name.  
  - Email address used for signing in.  
  - Option to **Sign Out**.  

---

## Localization  
- Supports **English** and **Swedish**.  
- App language reflects the system language setting.  

---

## Core Feature Package  
- Contains the application's main functionality.  

---

## Unit Tests  
Unit testing covers key components:  
- ViewModels.  
- Entities.  
- Formatters.  
- Localizations.  

---

## Accessibility  
- Supports both **portrait** and **landscape** modes.  
- Accessibility font scaling is implemented.  
- Light/Dark mode adapts to system settings.  

---

## Code Owners  
📧 **dmitrii.iascov@gmail.com**  

## WARNING
**API restrictions: Please be aware that the app uses limited public API that allows you to fetch up to 25 requests per day**
