import Foundation
import UIKit

class FlightCell: UITableViewCell {
    
    private var flightCellViewModel: FlightCellViewModel?
    
    private let flightCell: UIView = {
        let flightInfoContainer = UIView()
        flightInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        flightInfoContainer.layer.cornerRadius = 2.0
        flightInfoContainer.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        flightInfoContainer.layer.borderWidth = 0.1
        flightInfoContainer.backgroundColor = UIColor.white
        return flightInfoContainer
    }()
    
    private lazy var dataContainerView: UIStackView = {
        let dataContainerView = UIStackView()
        dataContainerView.axis = .vertical
        dataContainerView.spacing = 24.0
        dataContainerView.translatesAutoresizingMaskIntoConstraints = false
        dataContainerView.addArrangedSubview(outBoundImageAndInfoContainer)
        dataContainerView.addArrangedSubview(inBoundImageAndInfoContainer)
        dataContainerView.addArrangedSubview(priceAndRatingContainer)
        return dataContainerView
    }()
    
    private lazy var outBoundImageAndInfoContainer: ImageAndInformationContainer = {
        let outBoundImageAndInfoContainer = ImageAndInformationContainer()
        outBoundImageAndInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        return outBoundImageAndInfoContainer
    }()
    
    private lazy var inBoundImageAndInfoContainer: ImageAndInformationContainer = {
        let inBoundImageAndInfoContainer = ImageAndInformationContainer()
        inBoundImageAndInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        return inBoundImageAndInfoContainer
    }()

    private lazy var priceAndRatingContainer: UIStackView = {
        let priceAndRatingContainer = UIStackView()
        priceAndRatingContainer.axis = .vertical
        priceAndRatingContainer.spacing = 4.0
        priceAndRatingContainer.translatesAutoresizingMaskIntoConstraints = false
        priceAndRatingContainer.addArrangedSubview(priceAndRatingView)
        priceAndRatingContainer.addArrangedSubview(cheapestAndAlertingView)
        return priceAndRatingContainer
    }()

    private lazy var priceAndRatingView: TitleAndSubtitleView = {
        let priceAndRatingView = TitleAndSubtitleView()
        priceAndRatingView.translatesAutoresizingMaskIntoConstraints = false
        return priceAndRatingView
    }()

    private lazy var cheapestAndAlertingView: TitleAndSubtitleView = {
        let cheapestAndAlertingView = TitleAndSubtitleView()
        cheapestAndAlertingView.translatesAutoresizingMaskIntoConstraints = false
        return cheapestAndAlertingView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setUpView()
        setUpConstraints()
    }
    
    private func setUpView() {
        flightCell.addSubview(dataContainerView)
        contentView.addSubview(flightCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithViewModel(flightCellViewModel: FlightCellViewModel?) {
        self.flightCellViewModel = flightCellViewModel
        guard let cellViewModel = self.flightCellViewModel else { return }
        outBoundImageAndInfoContainer.viewModel = cellViewModel.outBoundInfoContainerViewModel
        inBoundImageAndInfoContainer.viewModel = cellViewModel.inBoundInfoContainerViewModel
        priceAndRatingView.viewModel = cellViewModel.priceAndRatingContainerViewModel
        cheapestAndAlertingView.viewModel = cellViewModel.alertingViewModel
    }
    
    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(flightCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0))
        constraints.append(flightCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(flightCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        constraints.append(flightCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0))
        constraints.append(dataContainerView.topAnchor.constraint(equalTo: flightCell.topAnchor, constant: 16.0))
        constraints.append(dataContainerView.leadingAnchor.constraint(equalTo: flightCell.leadingAnchor, constant: 16.0))
        constraints.append(dataContainerView.trailingAnchor.constraint(equalTo: flightCell.trailingAnchor, constant: -16.0))
        NSLayoutConstraint.activate(constraints)
    }
}
