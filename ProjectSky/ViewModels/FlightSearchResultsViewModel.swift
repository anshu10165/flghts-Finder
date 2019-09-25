import Foundation
import UIKit

protocol UpdateFlightSearchresultsDelegate: class {
    func updateFlightSearchResults()
}

class FlightSearchResultsViewModel {
    
    private var flightSearchRequest: FlightSearchRequest?
    private var flightSearchResponse: FlightSearchResponse?
    private var inBoundFlightCellViewModel = [FlightDataProvider]()
    private var outBoundFlightCellViewModel = [FlightDataProvider]()
    private let searchParams: FlightSearchParams
    weak var delegate: UpdateFlightSearchresultsDelegate?
    
    init(searchParams: FlightSearchParams) {
        self.searchParams = searchParams
    }
    
    func fetchFlightSearchResponseFromAPI() {
        flightSearchRequest = FlightSearchRequest(flightSearchParams: searchParams)
        flightSearchRequest?.createSession() { response in
            self.flightSearchResponse = response
            self.delegate?.updateFlightSearchResults()
        }
    }
    
    private lazy var flightCellViewModel: ([FlightDataProvider], [FlightDataProvider]) = {

        guard let response = flightSearchResponse else { return ([], []) }
        for itinerary in response.Itineraries {
            let finalPrice = priceFrom(option: itinerary.PricingOptions)
            for leg in response.Legs {
                if (itinerary.OutboundLegId == leg.Id) {
                    let departureText = outBoundSearchCriteria()
                    let outBoundFlightDataProvider = getDataProvider(leg: leg,
                                                                     price: finalPrice,
                                                                     searchCriteria: departureText)
                    outBoundFlightCellViewModel.append(outBoundFlightDataProvider)
                } else if (itinerary.InboundLegId == leg.Id) {
                    let returnText = inBoundSearchCriteria()
                    let inboundFlightDataProvider = getDataProvider(leg: leg,
                                                                    price: finalPrice,
                                                                    searchCriteria: returnText)
                    inBoundFlightCellViewModel.append(inboundFlightDataProvider)
                }
            }
        }
        return (outBoundFlightCellViewModel.sorted { $0.price < $1.price },
                inBoundFlightCellViewModel.sorted { $0.price < $1.price })
    }()
    
    private func getDataProvider(leg: FlightLeg, price: Int, searchCriteria: String) -> FlightDataProvider {
        let carrier = getCarrierNameAndImageUrl(leg: leg).0
        let imageUrl = getCarrierNameAndImageUrl(leg: leg).1
        let departureTimeInbound = timeRange(departure: leg.Departure, arrival: leg.Arrival)
        let duration = durationInHrsAndMins(durationInMins: leg.Duration)
        let stops = stopsString(stops: leg.Stops)
        let elapsedDay = elapsedDays(duration: leg.Duration)
        let locationAndAirlineText = "\(searchCriteria), \(carrier)"
        let dataProvider = FlightDataProvider(timeRange: departureTimeInbound,
                                              locationAndAirline: locationAndAirlineText,
                                              duration: duration,
                                              price: price,
                                              imageUrl: imageUrl,
                                              stops: stops,
                                              elaspedDays: elapsedDay,
                                              currencyCode: currencyCode())
        return dataProvider
    }
    
    var title: String? {
        guard let response = flightSearchResponse else { return nil }
        let count = response.Itineraries.count
        return "\(count) of \(count) results shown sorted by price"
    }
    
    func getCellViewModelForIndexPath(index: Int) -> FlightCellViewModel? {
        guard index >= 0 else { return nil }
        let outBoundDataProvider = outBoundViewModelAtIndex(index: index)
        let inboundDataProvider = inBoundViewModelAtIndex(index: index)
        let isPriceEqual = outBoundViewModelAtIndex(index: 0).price == outBoundViewModelAtIndex(index: index).price
        let alertViewModel = outBoundDataProvider.alertingViewModel(title: isPriceEqual ? "cheapest": "")
        let outflightInfoContainerViewModel = outBoundDataProvider.flightInfoContainerViewModel()
        let inflightInfoContainerViewModel = inboundDataProvider.flightInfoContainerViewModel()
        let priceAndRatingViewmodel = outBoundDataProvider.priceAndRatingViewModel()
        let cellViewModel = FlightCellViewModel(outBoundInfoContainerViewModel: outflightInfoContainerViewModel,
                                                inBoundInfoContainerViewModel: inflightInfoContainerViewModel,
                                                priceAndRatingContainerViewModel: priceAndRatingViewmodel,
                                                alertingViewModel: alertViewModel)
        return cellViewModel
    }
    
    func resultsCount() -> Int {
        guard let response = flightSearchResponse else { return 0 }
        return response.Itineraries.count
    }
    
    func getNavigationBarDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateOutFormat = dateFormatter.date(from: searchParams.outBoundDate)
        let dateInFormat = dateFormatter.date(from: searchParams.inboundDate)
        dateFormatter.dateFormat = "dd MMM"
        guard let outBoundDate = dateOutFormat, let inboundDate = dateInFormat else { return nil }
        let outBoundDateString = dateFormatter.string(from: outBoundDate)
        let inBoundDateString = dateFormatter.string(from: inboundDate)
        return "\(outBoundDateString) - \(inBoundDateString)"
    }
    
    var navigationBarTitle: String {
        return "Edingburg to London"
    }
    
    // MARK :- Private functions
    
    private func outBoundViewModelAtIndex(index: Int) -> FlightDataProvider {
        return flightCellViewModel.0[index]
    }
    
    private func inBoundViewModelAtIndex(index: Int) -> FlightDataProvider {
        return flightCellViewModel.1[index]
    }
    
    private func getCarrierNameAndImageUrl(leg: FlightLeg) -> (String, String) {
        guard let response = flightSearchResponse else { return ("", "") }
        var carrierString: String = ""
        var imageUrl: String = ""
        for carrier in response.Carriers {
            if (leg.Carriers[0] == carrier.Id) {
                carrierString = carrier.Name
                imageUrl = carrier.ImageUrl
            }
        }
        return (carrierString, imageUrl)
    }
    
    private func priceFrom(option: [PriceOption]) -> Int {
        if !option.isEmpty {
            return Int(option[0].Price.rounded())
        }
        return 0
    }
    
    private func currencyCode() -> String {
        var currencySymbol: String = ""
        guard let response = flightSearchResponse else { return "" }
        if !response.Currencies.isEmpty {
            currencySymbol = response.Currencies[0].Symbol
        }
        return currencySymbol
    }

    private func timeRange(departure: String, arrival: String) -> String {
        var convertedDepartureTime = ""
        var convertedArrivalTime = ""
        let departureTime = departure.components(separatedBy: "T")
        let arrivalTime = arrival.components(separatedBy: "T")
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH-mm-ss"
        let newtimeFormatter = DateFormatter()
        newtimeFormatter.dateFormat = "h:mm a"
        
        if let departureTime = timeFormatter.date(from: departureTime[1]) {
            convertedDepartureTime = newtimeFormatter.string(from: departureTime)
        }
        
        if let arrivalTime = timeFormatter.date(from: arrivalTime[1]) {
            convertedArrivalTime = newtimeFormatter.string(from: arrivalTime)
        }
        return "\(convertedDepartureTime) - \(convertedArrivalTime)"
    }
    
    private func durationInHrsAndMins(durationInMins: Int) -> String {
        var duration = ""
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.dropAll]
        if let formattedString = formatter.string(from: TimeInterval(durationInMins * 60)) {
            duration = formattedString
        }
        return duration
    }
    
    private func stopsString(stops: [Int]) -> String {
        var stopsString: String = ""
        if stops.isEmpty {
            stopsString = "Direct"
        } else if stops.count == 1 {
            stopsString = "1 Stop"
        } else {
            stopsString = "2+ Stops"
        }
        return stopsString
    }
    
    private func elapsedDays(duration: Int) -> String? {
        var elapsedDay: String?
        if (duration/60) > 12 {
            elapsedDay = " +1"
        }
        return elapsedDay
    }
    
    private func outBoundSearchCriteria() -> String {
        let originPlace = searchParams.originplace
        let destinationPlace = searchParams.destinationplace
        let searchCriteria = originPlace + " - " + destinationPlace
        return searchCriteria
    }
    
    private func inBoundSearchCriteria() -> String {
        let originPlace = searchParams.destinationplace
        let destinationPlace = searchParams.originplace
        let searchCriteria = originPlace + " - " + destinationPlace
        return searchCriteria
    }
}
