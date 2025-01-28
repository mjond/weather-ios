# iOS Weather App

This is a simple SwiftUI app to show current weather and forecasted weather. This project uses an MVVM architecture. Please keep in mind the purpose of this isn't to show UI/UX design but rather architecture patterns, data handling, and testing :)

This app uses Core Location and MapKit to search for locations. No third-party SDKs are used in this project to showcase using what comes with the phone. All icons are from SF Symbols and dark mode is supported. Voice Over accessibility is supported.

## Requirements
- Xcode 16.x
- Swift 5
- Minimum iOS: 17.0

## Data Fetching
This app uses data from [Open-Meteo](https://open-meteo.com/), an organization giving free weather data at the personal project tier. The data is fetched using the `WeatherService` class which utilizes `URLSession` and `JSONDecoder`.

To see a sample weather response from Open-Meteo like this project uses, enter this call into Postman:
```
https://api.open-meteo.com/v1/forecast?current=temperature_2m,weather_code,apparent_temperature,&daily=temperature_2m_min,temperature_2m_max,weather_code,sunrise,sunset,precipitation_probability_mean,precipitation_sum,uv_index_max,wind_speed_10m_max,wind_direction_10m_dominant,wind_gusts_10m_max&timezone=auto&latitude=40.73&longitude=-73.93&forecast_days=10&hourly=temperature_2m,is_day,weather_code&temperature_unit=fahrenheit
```

## Navigation

This app uses `NavigationStack` with `NavigationPath` for navigation.

## Features

### Home
This is the main view of the application. It displays the current weather, 24 hourly forecase, and 10 day forcast. This view defaults to the user's current location.

<p float="left">
    <img src="Screenshots/home.PNG" alt="drawing" width="250"/>
    <img src="Screenshots/home_dark_mode.PNG" alt="drawing" width="250"/>
</p>

### Day Detail
Tapping on a day from the Home screen will bring the user to the Day Detail View.

<img src="Screenshots/day_detail.PNG" alt="drawing" width="250"/>
<img src="Screenshots/day_detail_dark_mode.PNG" alt="drawing" width="250"/>

### Location Search
Tapping on the magnifying glass icon from the Home screen's navigation bar will bring the user here. This view utilizes the `MKLocalSearchCompleter` from MapKit to search for locations.

<img src="Screenshots/location_search.PNG" alt="drawing" width="250"/>

### Settings
Tapping on the gear icon from the Home screen's navigation bar will bring the user to Settings where the user can change between Imperial and Metric.

<img src="Screenshots/settings.PNG" alt="drawing" width="250"/>

### Location
If a user denies location services, or turns it off at a later time, then the user is prompted to allow location services.

<img src="Screenshots/location_denied.PNG" alt="drawing" width="250"/>
