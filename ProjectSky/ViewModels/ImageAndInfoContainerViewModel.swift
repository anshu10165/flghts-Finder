import UIKit

class ImageAndInfoContainerViewModel {
    let imageUrl: String
    let departureAndStopsViewModel: TitleAndSubtitleViewModel
    let carrierAndDurationViewModel: TitleAndSubtitleViewModel
    
    init(imageUrl: String,
         departureAndStopsViewModel: TitleAndSubtitleViewModel,
         carrierAndDurationViewModel: TitleAndSubtitleViewModel) {
        self.imageUrl = imageUrl
        self.carrierAndDurationViewModel = carrierAndDurationViewModel
        self.departureAndStopsViewModel = departureAndStopsViewModel
    }
}
