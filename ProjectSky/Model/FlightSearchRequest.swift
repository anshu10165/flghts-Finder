import Foundation
import CoreLocation
class FlightSearchRequest {
    
    private var urlRequest: URLRequest
    private let flightSearchParams: FlightSearchParams
    private let session = URLSession.shared
    private let baseUrl = URL(string: "http://partners.api.skyscanner.net/apiservices/pricing/v1.0")!
    
    init(flightSearchParams: FlightSearchParams = FlightSearchParams()) {
        self.flightSearchParams = flightSearchParams
        urlRequest = URLRequest(url: baseUrl, cachePolicy: .useProtocolCachePolicy)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = httpHeaders()
        urlRequest.httpBody = getPostData() as Data
    }
    
    private func httpHeaders() -> Dictionary<String, String> {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache"
        ]
        return headers
    }
    
    private func getPostData() -> NSMutableData {
        let postData = NSMutableData(data: "cabinclass=\(flightSearchParams.cabinClass)".data(using: String.Encoding.utf8)!)
        postData.append("&country=\(flightSearchParams.country)".data(using: String.Encoding.utf8)!)
        postData.append("&currency=\(flightSearchParams.currency)".data(using: String.Encoding.utf8)!)
        postData.append("&locale=en-GB\(flightSearchParams.locale)".data(using: String.Encoding.utf8)!)
        postData.append("&locationSchema=\(flightSearchParams.locationSchema)".data(using: String.Encoding.utf8)!)
        postData.append("&originplace=\(flightSearchParams.originplace)".data(using: String.Encoding.utf8)!)
        postData.append("&destinationplace=\(flightSearchParams.destinationplace)".data(using: String.Encoding.utf8)!)
        postData.append("&outbounddate=\(flightSearchParams.outBoundDate)".data(using: String.Encoding.utf8)!)
        postData.append("&inbounddate=\(flightSearchParams.inboundDate)".data(using: String.Encoding.utf8)!)
        postData.append("&adults=\(flightSearchParams.adults)".data(using: String.Encoding.utf8)!)
        postData.append("&children=\(flightSearchParams.children)".data(using: String.Encoding.utf8)!)
        postData.append("&infants=\(flightSearchParams.infants)".data(using: String.Encoding.utf8)!)
        postData.append("&apikey=\(flightSearchParams.apiKey)".data(using: String.Encoding.utf8)!)
        postData.append("&groupPricing=\(flightSearchParams.groupPricing)".data(using: String.Encoding.utf8)!)
        return postData
    }
    
    func createSession(handler: @escaping (_ response: FlightSearchResponse) -> Void) {
        let dataTask = session.dataTask(with: urlRequest as URLRequest,
                                        completionHandler: { (data, response, error) -> Void in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                return
            }
            if let headerFields = httpResponse.allHeaderFields as? [String: String],
                let locationheaderValue = headerFields["Location"] {
                let urlPath = "\(locationheaderValue)?apikey=\(self.flightSearchParams.apiKey)"
                var newurlRequest = URLRequest(url: URL(string: urlPath)!,
                                               cachePolicy: .useProtocolCachePolicy)
                newurlRequest.httpMethod = "GET"
                self.fetchFlightSearchResults(urlRequest: newurlRequest, handler: handler)
            }
        })
        dataTask.resume()
    }
    
    private func fetchFlightSearchResults(urlRequest: URLRequest, handler: @escaping (_ response: FlightSearchResponse) -> Void) {
        session.dataTask(with: urlRequest  as URLRequest) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let flightSearchResponse = try decoder.decode(FlightSearchResponse.self, from: dataResponse)
                handler(flightSearchResponse)
            } catch let parsingError {
                print("Error", parsingError)
            }
        }.resume()
    }
}
