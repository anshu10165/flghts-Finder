class FlightCellViewModel {
    
    let outBoundInfoContainerViewModel: ImageAndInfoContainerViewModel
    let inBoundInfoContainerViewModel: ImageAndInfoContainerViewModel
    let priceAndRatingContainerViewModel: TitleAndSubtitleViewModel
    let alertingViewModel: TitleAndSubtitleViewModel
    
    init(outBoundInfoContainerViewModel: ImageAndInfoContainerViewModel,
         inBoundInfoContainerViewModel: ImageAndInfoContainerViewModel,
         priceAndRatingContainerViewModel: TitleAndSubtitleViewModel,
         alertingViewModel: TitleAndSubtitleViewModel) {
        self.outBoundInfoContainerViewModel = outBoundInfoContainerViewModel
        self.inBoundInfoContainerViewModel = inBoundInfoContainerViewModel
        self.priceAndRatingContainerViewModel = priceAndRatingContainerViewModel
        self.alertingViewModel = alertingViewModel
    }
}
