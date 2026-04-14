//
//  AirQualityDataModel.swift
//  Weather
//
//  Created by Mark Davis on 4/13/26.
//

struct AirQualityResponse {
    let latitude: Double?
    let longitude: Double?
    let current: AirQualityCurrent?
    let forecast: [AirQualityForecastDay]?
}

struct AirQualityCurrent {
    let time: String?
    let usAqi: Int?
    let pm10: Double?
    let pm25: Double?
}

struct AirQualityForecastDay {
    let date: String?
    let pm25High: Double?
    let pm25Low: Double?
    let pm10High: Double?
    let pm10Low: Double?
    let usAqiHigh: Int?
    let usAqiLow: Int?
}

extension AirQualityResponse {
    init(generated payload: GetAirQualityQuery.Data.GetAirQuality) {
        latitude = payload.latitude
        longitude = payload.longitude
        current = payload.current.map { current in
            AirQualityCurrent(
                time: current.time,
                usAqi: current.usAqi,
                pm10: current.pm10,
                pm25: current.pm25
            )
        }
        forecast = payload.forecast?.map { day in
            AirQualityForecastDay(
                date: day.date,
                pm25High: day.pm25High,
                pm25Low: day.pm25Low,
                pm10High: day.pm10High,
                pm10Low: day.pm10Low,
                usAqiHigh: day.usAqiHigh,
                usAqiLow: day.usAqiLow
            )
        }
    }
}
