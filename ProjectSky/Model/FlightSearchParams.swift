import Foundation
import UIKit
class FlightSearchParams {

    let originplace: String
    let destinationplace: String
    let cabinClass: String
    let country: String
    let currency: String
    let locale: String
    let locationSchema: String
    let outBoundDate: String
    let inboundDate: String
    let adults: String
    let children: String
    let infants: String
    let groupPricing: String
    let apiKey: String

    init(originplace: String = "EDI",
         destinationplace: String = "LHR",
         cabinClass: String = "Economy",
         country: String = "UK",
         currency: String = "GBP",
         locale: String = "en-GB",
         locationSchema: String = "sky",
         outBoundDate: String = FlightSearchParams.getOutBoundDate(),
         inboundDate: String = FlightSearchParams.getInBoundDate(),
         adults: String = "1",
         children: String = "0",
         infants: String = "0",
         groupPricing: String = "true",
         apiKey: String = FlightSearchParams.apiKey()) {
        self.originplace = originplace
        self.destinationplace = destinationplace
        self.cabinClass = cabinClass
        self.country = country
        self.currency = currency
        self.locale = locale
        self.locationSchema = locationSchema
        self.outBoundDate = outBoundDate
        self.inboundDate = inboundDate
        self.adults = adults
        self.children = children
        self.infants = infants
        self.groupPricing = groupPricing
        self.apiKey = apiKey
    }
    
    private static func getOutBoundDate() -> String {
        let outBoundDate = Calendar.current.date(byAdding: .day, value: 6, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let outBoundDateString = dateFormatter.string(from: outBoundDate!)
        return outBoundDateString
    }
    
    private static func getInBoundDate() -> String {
        let inBoundDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let inBoundDateString = dateFormatter.string(from: inBoundDate!)
        return inBoundDateString
    }
    
    private static func apiKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
    }
}
