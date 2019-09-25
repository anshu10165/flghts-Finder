import UIKit

class FlightDataProvider {
    
    private let timeRange: String
    private let locationAndAirline: String
    private let duration: String
    private let stops: String
    private let elapsedDay: String?
    private let currencyCode: String
    private let imageUrl: String
    let price: Int

    init(timeRange: String,
         locationAndAirline: String,
         duration: String,
         price: Int,
         imageUrl: String,
         stops: String,
         elaspedDays: String? = nil,
         currencyCode: String) {
        self.timeRange = timeRange
        self.locationAndAirline = locationAndAirline
        self.duration = duration
        self.price = price
        self.imageUrl = imageUrl
        self.stops = stops
        self.elapsedDay = elaspedDays
        self.currencyCode = currencyCode
    }
    
    private func departureAndStopsViewModel() -> TitleAndSubtitleViewModel {
        var departureAndArrivalTimeRange = timeRange
        if let dayElapsed = elapsedDay {
            departureAndArrivalTimeRange = "\(departureAndArrivalTimeRange)\(dayElapsed)"
        }
        return TitleAndSubtitleViewModel(title: departureAndArrivalTimeRange,
                                         subtitle: stops,
                                         titlefont: UIFont.systemFont(ofSize: 16.0),
                                         subtitleFont: UIFont.systemFont(ofSize: 16.0),
                                         titlecolor: UIColor.black,
                                         subtitleColor: UIColor.black)
    }
    
    private func carrierAndDurationViewModel() -> TitleAndSubtitleViewModel {
        return TitleAndSubtitleViewModel(title: locationAndAirline,
                                         subtitle: duration,
                                         titlefont: UIFont.systemFont(ofSize: 13.0),
                                         subtitleFont: UIFont.systemFont(ofSize: 13.0),
                                         titlecolor: UIColor.gray,
                                         subtitleColor: UIColor.gray)
    }
    
    func priceAndRatingViewModel() -> TitleAndSubtitleViewModel {
        //Hardcode rating for assignment as we dnt get this from API
        return TitleAndSubtitleViewModel(title: "Rated 10.0",
                                         subtitle: "\(currencyCode)\(price)",
                                         titlefont: UIFont.systemFont(ofSize: 13.0),
                                         subtitleFont: UIFont.boldSystemFont(ofSize: 18.0),
                                         titlecolor: UIColor.darkGray,
                                         subtitleColor: UIColor.black)
    }
    
    func alertingViewModel(title: String) -> TitleAndSubtitleViewModel {
        return TitleAndSubtitleViewModel(title: title,
                                         subtitle: "",
                                         titlefont: UIFont.systemFont(ofSize: 13.0),
                                         subtitleFont: UIFont.systemFont(ofSize: 13.0),
                                         titlecolor: UIColor.green,
                                         subtitleColor: UIColor.gray)
    }
    
    func flightInfoContainerViewModel() -> ImageAndInfoContainerViewModel {
        return ImageAndInfoContainerViewModel(imageUrl: imageUrl,
                                              departureAndStopsViewModel: departureAndStopsViewModel(),
                                              carrierAndDurationViewModel: carrierAndDurationViewModel())
    }
}
