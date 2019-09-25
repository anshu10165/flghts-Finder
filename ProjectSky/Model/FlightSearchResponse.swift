struct FlightSearchResponse: Decodable {
    let SessionKey: String
    let Status: String
    let Itineraries: [Itinerary]
    let Legs: [FlightLeg]
    let Segments: [FlightSegment]
    let Carriers: [Carrier]
    let Currencies: [Currency]
}

struct Itinerary: Decodable {
    let OutboundLegId: String
    let InboundLegId: String
    let PricingOptions: [PriceOption]
}

struct PriceOption: Decodable {
    let Price: Double
}

struct FlightLeg: Decodable {
    let Id: String
    let SegmentIds: [Int]
    let Departure: String
    let Arrival: String
    let Duration: Int
    let Carriers: [Int]
    let Stops: [Int]
}

struct FlightSegment: Decodable {
    let Id: Int
    let DepartureDateTime: String
    let ArrivalDateTime: String
    let Duration: Int
}

struct Carrier: Decodable {
    let Id: Int
    let Name: String
    let ImageUrl: String
}

struct Currency: Decodable {
    let Symbol: String
}

