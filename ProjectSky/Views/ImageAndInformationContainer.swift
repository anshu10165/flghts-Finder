import Foundation
import UIKit

class ImageAndInformationContainer: UIStackView {
    
    private let placeHolderImage = UIImage(named: "airlineLogoPlaceholder")
    
    var viewModel: ImageAndInfoContainerViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            self.departureAndNumberOfStops.viewModel = viewModel.departureAndStopsViewModel
            self.carrierAndDuration.viewModel = viewModel.carrierAndDurationViewModel
            if let imageUrl = URL(string: viewModel.imageUrl) {
                self.downloadImage(from: imageUrl)
            }
        }
    }
    
    private lazy var airlineImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "airlineLogoPlaceholder"))
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var timeRangeAndDurationContainer: UIStackView = {
        let infoContainer = UIStackView()
        infoContainer.axis = .vertical
        infoContainer.spacing = 4.0
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.addArrangedSubview(departureAndNumberOfStops)
        infoContainer.addArrangedSubview(carrierAndDuration)
        return infoContainer
    }()
    
    private lazy var departureAndNumberOfStops: TitleAndSubtitleView = {
        let departureAndNumberOfStops = TitleAndSubtitleView()
        departureAndNumberOfStops.translatesAutoresizingMaskIntoConstraints = false
        return departureAndNumberOfStops
    }()
    
    private lazy var carrierAndDuration: TitleAndSubtitleView = {
        let carrierAndDuration = TitleAndSubtitleView()
        carrierAndDuration.translatesAutoresizingMaskIntoConstraints = false
        return carrierAndDuration
    }()
    
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .fill
        spacing = 8.0
        addArrangedSubview(airlineImageView)
        addArrangedSubview(timeRangeAndDurationContainer)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.airlineImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}


