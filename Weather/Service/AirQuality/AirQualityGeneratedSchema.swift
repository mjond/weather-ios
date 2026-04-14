//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
    import Foundation

    public protocol GraphQLInputValue {}

    public struct GraphQLVariable {
        let name: String

        public init(_ name: String) {
            self.name = name
        }
    }

    extension GraphQLVariable: GraphQLInputValue {}

    public extension JSONEncodable {
        func evaluate(with _: [String: JSONEncodable]?) throws -> Any {
            return jsonValue
        }
    }

    public typealias GraphQLMap = [String: JSONEncodable?]

    public extension Dictionary where Key == String, Value == JSONEncodable? {
        var withNilValuesRemoved: [String: JSONEncodable] {
            var filtered = [String: JSONEncodable](minimumCapacity: count)
            for (key, value) in self {
                if value != nil {
                    filtered[key] = value
                }
            }
            return filtered
        }
    }

    public protocol GraphQLMapConvertible: JSONEncodable {
        var graphQLMap: GraphQLMap { get }
    }

    public extension GraphQLMapConvertible {
        var jsonValue: Any {
            return graphQLMap.withNilValuesRemoved.jsonValue
        }
    }

    public typealias GraphQLID = String

    public protocol APISwiftGraphQLOperation: AnyObject {
        static var operationString: String { get }
        static var requestString: String { get }
        static var operationIdentifier: String? { get }

        var variables: GraphQLMap? { get }

        associatedtype Data: GraphQLSelectionSet
    }

    public extension APISwiftGraphQLOperation {
        static var requestString: String {
            return operationString
        }

        static var operationIdentifier: String? {
            return nil
        }

        var variables: GraphQLMap? {
            return nil
        }
    }

    public protocol GraphQLQuery: APISwiftGraphQLOperation {}

    public protocol GraphQLMutation: APISwiftGraphQLOperation {}

    public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

    public protocol GraphQLFragment: GraphQLSelectionSet {
        static var possibleTypes: [String] { get }
    }

    public typealias Snapshot = [String: Any?]

    public protocol GraphQLSelectionSet: Decodable {
        static var selections: [GraphQLSelection] { get }

        var snapshot: Snapshot { get }
        init(snapshot: Snapshot)
    }

    public extension GraphQLSelectionSet {
        init(from decoder: Decoder) throws {
            if let jsonObject = try? APISwiftJSONValue(from: decoder) {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(jsonObject)
                let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

                self.init(snapshot: optionalDictionary)
            } else {
                self.init(snapshot: [:])
            }
        }
    }

    enum APISwiftJSONValue: Codable {
        case array([APISwiftJSONValue])
        case boolean(Bool)
        case number(Double)
        case object([String: APISwiftJSONValue])
        case string(String)
        case null

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode([String: APISwiftJSONValue].self) {
                self = .object(value)
            } else if let value = try? container.decode([APISwiftJSONValue].self) {
                self = .array(value)
            } else if let value = try? container.decode(Double.self) {
                self = .number(value)
            } else if let value = try? container.decode(Bool.self) {
                self = .boolean(value)
            } else if let value = try? container.decode(String.self) {
                self = .string(value)
            } else {
                self = .null
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case let .array(value):
                try container.encode(value)
            case let .boolean(value):
                try container.encode(value)
            case let .number(value):
                try container.encode(value)
            case let .object(value):
                try container.encode(value)
            case let .string(value):
                try container.encode(value)
            case .null:
                try container.encodeNil()
            }
        }
    }

    public protocol GraphQLSelection {}

    public struct GraphQLField: GraphQLSelection {
        let name: String
        let alias: String?
        let arguments: [String: GraphQLInputValue]?

        var responseKey: String {
            return alias ?? name
        }

        let type: GraphQLOutputType

        public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
            self.name = name
            self.alias = alias

            self.arguments = arguments

            self.type = type
        }
    }

    public indirect enum GraphQLOutputType {
        case scalar(JSONDecodable.Type)
        case object([GraphQLSelection])
        case nonNull(GraphQLOutputType)
        case list(GraphQLOutputType)

        var namedType: GraphQLOutputType {
            switch self {
            case let .nonNull(innerType), let .list(innerType):
                return innerType.namedType
            case .scalar, .object:
                return self
            }
        }
    }

    public struct GraphQLBooleanCondition: GraphQLSelection {
        let variableName: String
        let inverted: Bool
        let selections: [GraphQLSelection]

        public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
            self.variableName = variableName
            self.inverted = inverted
            self.selections = selections
        }
    }

    public struct GraphQLTypeCondition: GraphQLSelection {
        let possibleTypes: [String]
        let selections: [GraphQLSelection]

        public init(possibleTypes: [String], selections: [GraphQLSelection]) {
            self.possibleTypes = possibleTypes
            self.selections = selections
        }
    }

    public struct GraphQLFragmentSpread: GraphQLSelection {
        let fragment: GraphQLFragment.Type

        public init(_ fragment: GraphQLFragment.Type) {
            self.fragment = fragment
        }
    }

    public struct GraphQLTypeCase: GraphQLSelection {
        let variants: [String: [GraphQLSelection]]
        let `default`: [GraphQLSelection]

        public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
            self.variants = variants
            self.default = `default`
        }
    }

    public typealias JSONObject = [String: Any]

    public protocol JSONDecodable {
        init(jsonValue value: Any) throws
    }

    public protocol JSONEncodable: GraphQLInputValue {
        var jsonValue: Any { get }
    }

    public enum JSONDecodingError: Error, LocalizedError {
        case missingValue
        case nullValue
        case wrongType
        case couldNotConvert(value: Any, to: Any.Type)

        public var errorDescription: String? {
            switch self {
            case .missingValue:
                return "Missing value"
            case .nullValue:
                return "Unexpected null value"
            case .wrongType:
                return "Wrong type"
            case let .couldNotConvert(value, expectedType):
                return "Could not convert \"\(value)\" to \(expectedType)"
            }
        }
    }

    extension String: JSONDecodable, JSONEncodable {
        public init(jsonValue value: Any) throws {
            guard let string = value as? String else {
                throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
            }
            self = string
        }

        public var jsonValue: Any {
            return self
        }
    }

    extension Int: JSONDecodable, JSONEncodable {
        public init(jsonValue value: Any) throws {
            guard let number = value as? NSNumber else {
                throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
            }
            self = number.intValue
        }

        public var jsonValue: Any {
            return self
        }
    }

    extension Float: JSONDecodable, JSONEncodable {
        public init(jsonValue value: Any) throws {
            guard let number = value as? NSNumber else {
                throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
            }
            self = number.floatValue
        }

        public var jsonValue: Any {
            return self
        }
    }

    extension Double: JSONDecodable, JSONEncodable {
        public init(jsonValue value: Any) throws {
            guard let number = value as? NSNumber else {
                throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
            }
            self = number.doubleValue
        }

        public var jsonValue: Any {
            return self
        }
    }

    extension Bool: JSONDecodable, JSONEncodable {
        public init(jsonValue value: Any) throws {
            guard let bool = value as? Bool else {
                throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
            }
            self = bool
        }

        public var jsonValue: Any {
            return self
        }
    }

    public extension RawRepresentable where RawValue: JSONDecodable {
        init(jsonValue value: Any) throws {
            let rawValue = try RawValue(jsonValue: value)
            if let tempSelf = Self(rawValue: rawValue) {
                self = tempSelf
            } else {
                throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
            }
        }
    }

    public extension RawRepresentable where RawValue: JSONEncodable {
        var jsonValue: Any {
            return rawValue.jsonValue
        }
    }

    public extension Optional where Wrapped: JSONDecodable {
        init(jsonValue value: Any) throws {
            if value is NSNull {
                self = .none
            } else {
                self = try .some(Wrapped(jsonValue: value))
            }
        }
    }

    extension Optional: JSONEncodable {
        public var jsonValue: Any {
            switch self {
            case .none:
                return NSNull()
            case let .some(wrapped as JSONEncodable):
                return wrapped.jsonValue
            default:
                fatalError("Optional is only JSONEncodable if Wrapped is")
            }
        }
    }

    extension Dictionary: JSONEncodable {
        public var jsonValue: Any {
            return jsonObject
        }

        public var jsonObject: JSONObject {
            var jsonObject = JSONObject(minimumCapacity: count)
            for (key, value) in self {
                if case let (key as String, value as JSONEncodable) = (key, value) {
                    jsonObject[key] = value.jsonValue
                } else {
                    fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
                }
            }
            return jsonObject
        }
    }

    extension Array: JSONEncodable {
        public var jsonValue: Any {
            return map { element -> (Any) in
                if case let element as JSONEncodable = element {
                    return element.jsonValue
                } else {
                    fatalError("Array is only JSONEncodable if Element is")
                }
            }
        }
    }

    extension URL: JSONDecodable, JSONEncodable {
        public init(jsonValue value: Any) throws {
            guard let string = value as? String else {
                throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
            }
            self.init(string: string)!
        }

        public var jsonValue: Any {
            return absoluteString
        }
    }

    extension Dictionary {
        static func += (lhs: inout Dictionary, rhs: Dictionary) {
            lhs.merge(rhs) { _, new in new }
        }
    }

#elseif canImport(AWSAppSync)
    import AWSAppSync
#endif

public final class GetAirQualityQuery: GraphQLQuery {
    public static let operationString =
        "query GetAirQuality($latitude: Float!, $longitude: Float!, $forecastDays: Int) {\n  getAirQuality(\n    input: {latitude: $latitude, longitude: $longitude, forecastDays: $forecastDays}\n  ) {\n    __typename\n    latitude\n    longitude\n    current {\n      __typename\n      time\n      usAqi\n      pm10\n      pm25\n    }\n    forecast {\n      __typename\n      date\n      pm25High\n      pm25Low\n      pm10High\n      pm10Low\n      usAqiHigh\n      usAqiLow\n    }\n  }\n}"

    public var latitude: Double
    public var longitude: Double
    public var forecastDays: Int?

    public init(latitude: Double, longitude: Double, forecastDays: Int? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.forecastDays = forecastDays
    }

    public var variables: GraphQLMap? {
        return ["latitude": latitude, "longitude": longitude, "forecastDays": forecastDays]
    }

    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]

        public static let selections: [GraphQLSelection] = [
            GraphQLField("getAirQuality", arguments: ["input": ["latitude": GraphQLVariable("latitude"), "longitude": GraphQLVariable("longitude"), "forecastDays": GraphQLVariable("forecastDays")]], type: .object(GetAirQuality.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }

        public init(getAirQuality: GetAirQuality? = nil) {
            self.init(snapshot: ["__typename": "Query", "getAirQuality": getAirQuality.flatMap { $0.snapshot }])
        }

        public var getAirQuality: GetAirQuality? {
            get {
                return (snapshot["getAirQuality"] as? Snapshot).flatMap { GetAirQuality(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "getAirQuality")
            }
        }

        public struct GetAirQuality: GraphQLSelectionSet {
            public static let possibleTypes = ["AirQuality"]

            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
                GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
                GraphQLField("current", type: .object(Current.selections)),
                GraphQLField("forecast", type: .list(.nonNull(.object(Forecast.selections)))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }

            public init(latitude: Double, longitude: Double, current: Current? = nil, forecast: [Forecast]? = nil) {
                self.init(snapshot: ["__typename": "AirQuality", "latitude": latitude, "longitude": longitude, "current": current.flatMap { $0.snapshot }, "forecast": forecast.flatMap { $0.map { $0.snapshot } }])
            }

            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }

            public var latitude: Double {
                get {
                    return snapshot["latitude"]! as! Double
                }
                set {
                    snapshot.updateValue(newValue, forKey: "latitude")
                }
            }

            public var longitude: Double {
                get {
                    return snapshot["longitude"]! as! Double
                }
                set {
                    snapshot.updateValue(newValue, forKey: "longitude")
                }
            }

            public var current: Current? {
                get {
                    return (snapshot["current"] as? Snapshot).flatMap { Current(snapshot: $0) }
                }
                set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "current")
                }
            }

            public var forecast: [Forecast]? {
                get {
                    return (snapshot["forecast"] as? [Snapshot]).flatMap { $0.map { Forecast(snapshot: $0) } }
                }
                set {
                    snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "forecast")
                }
            }

            public struct Current: GraphQLSelectionSet {
                public static let possibleTypes = ["CurrentAirQuality"]

                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("time", type: .nonNull(.scalar(String.self))),
                    GraphQLField("usAqi", type: .scalar(Int.self)),
                    GraphQLField("pm10", type: .scalar(Double.self)),
                    GraphQLField("pm25", type: .scalar(Double.self)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }

                public init(time: String, usAqi: Int? = nil, pm10: Double? = nil, pm25: Double? = nil) {
                    self.init(snapshot: ["__typename": "CurrentAirQuality", "time": time, "usAqi": usAqi, "pm10": pm10, "pm25": pm25])
                }

                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }

                public var time: String {
                    get {
                        return snapshot["time"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "time")
                    }
                }

                public var usAqi: Int? {
                    get {
                        return snapshot["usAqi"] as? Int
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "usAqi")
                    }
                }

                public var pm10: Double? {
                    get {
                        return snapshot["pm10"] as? Double
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "pm10")
                    }
                }

                public var pm25: Double? {
                    get {
                        return snapshot["pm25"] as? Double
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "pm25")
                    }
                }
            }

            public struct Forecast: GraphQLSelectionSet {
                public static let possibleTypes = ["DailyAirQualityForecast"]

                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("date", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pm25High", type: .scalar(Double.self)),
                    GraphQLField("pm25Low", type: .scalar(Double.self)),
                    GraphQLField("pm10High", type: .scalar(Double.self)),
                    GraphQLField("pm10Low", type: .scalar(Double.self)),
                    GraphQLField("usAqiHigh", type: .scalar(Int.self)),
                    GraphQLField("usAqiLow", type: .scalar(Int.self)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }

                public init(date: String, pm25High: Double? = nil, pm25Low: Double? = nil, pm10High: Double? = nil, pm10Low: Double? = nil, usAqiHigh: Int? = nil, usAqiLow: Int? = nil) {
                    self.init(snapshot: ["__typename": "DailyAirQualityForecast", "date": date, "pm25High": pm25High, "pm25Low": pm25Low, "pm10High": pm10High, "pm10Low": pm10Low, "usAqiHigh": usAqiHigh, "usAqiLow": usAqiLow])
                }

                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }

                public var date: String {
                    get {
                        return snapshot["date"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "date")
                    }
                }

                public var pm25High: Double? {
                    get {
                        return snapshot["pm25High"] as? Double
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "pm25High")
                    }
                }

                public var pm25Low: Double? {
                    get {
                        return snapshot["pm25Low"] as? Double
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "pm25Low")
                    }
                }

                public var pm10High: Double? {
                    get {
                        return snapshot["pm10High"] as? Double
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "pm10High")
                    }
                }

                public var pm10Low: Double? {
                    get {
                        return snapshot["pm10Low"] as? Double
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "pm10Low")
                    }
                }

                public var usAqiHigh: Int? {
                    get {
                        return snapshot["usAqiHigh"] as? Int
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "usAqiHigh")
                    }
                }

                public var usAqiLow: Int? {
                    get {
                        return snapshot["usAqiLow"] as? Int
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "usAqiLow")
                    }
                }
            }
        }
    }
}
