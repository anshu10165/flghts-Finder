import UIKit
import CoreLocation

class FlightSearchResultsViewController: UIViewController {

    private let cellReusableIdentifier: String = "cellIdentifier"
    private let viewModel: FlightSearchResultsViewModel
    private let homeTabController = UITabBarController()
    private let loadingSpinner = UIActivityIndicatorView(style: .gray)

    private lazy var listAndButtonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var flightList: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 230.0
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()

    private lazy var sortAndFilterButtonContainer: UIView = {
        let sortAndFilterButtonContainer = UIView()
        sortAndFilterButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        sortAndFilterButtonContainer.backgroundColor = UIColor.white
        sortAndFilterButtonContainer.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        return sortAndFilterButtonContainer
    }()
    
    private lazy var navigationBarTitleView: UIStackView = {
        let navigationBarTitleView = UIStackView()
        navigationBarTitleView.axis = .vertical
        navigationBarTitleView.distribution = .fill
        navigationBarTitleView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarTitleView.addArrangedSubview(navigationBarTitle)
        navigationBarTitleView.addArrangedSubview(navigationBarSubTitle)
        return navigationBarTitleView
    }()

    private lazy var navigationBarTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        navigationTitle.textColor = UIColor.black
        navigationTitle.translatesAutoresizingMaskIntoConstraints = false
        navigationTitle.text = viewModel.navigationBarTitle
        return navigationTitle
    }()
    
    private lazy var navigationBarSubTitle: UILabel = {
        let navigationSubtitle = UILabel()
        navigationSubtitle.font = UIFont.systemFont(ofSize: 13.0)
        navigationSubtitle.textColor = UIColor.darkGray
        navigationSubtitle.text = viewModel.getNavigationBarDate()
        navigationSubtitle.textAlignment = .center
        navigationSubtitle.translatesAutoresizingMaskIntoConstraints = false
        return navigationSubtitle
    }()
    
    private lazy var navigationBarBackButton: UIBarButtonItem = {
        let image = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(FlightSearchResultsViewController.popToPreviousViewController))
        return backButton
    }()
    
    private lazy var navigationBarShareButton: UIBarButtonItem = {
        let image = UIImage(named: "shareIcon")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(FlightSearchResultsViewController.shareButtonTapped))
        return backButton
    }()
    
    private lazy var resultsCountAndButtonContainer: UIStackView = {
        let resultsCountAndButtonContainer = UIStackView()
        resultsCountAndButtonContainer.axis = .horizontal
        resultsCountAndButtonContainer.distribution = .fillProportionally
        resultsCountAndButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        resultsCountAndButtonContainer.addArrangedSubview(totalFlightCount)
        resultsCountAndButtonContainer.addArrangedSubview(sortButtonLabel)
        resultsCountAndButtonContainer.addArrangedSubview(filterButtonLabel)
        return resultsCountAndButtonContainer
    }()
    
    private lazy var totalFlightCount: UILabel = {
        let totalFlightCount = UILabel()
        totalFlightCount.font = UIFont.systemFont(ofSize: 13.0)
        totalFlightCount.textColor = UIColor.gray
        totalFlightCount.translatesAutoresizingMaskIntoConstraints = false
        totalFlightCount.text = viewModel.title
        return totalFlightCount
    }()
    
    private lazy var sortButtonLabel: UILabel = {
        let sortButtonLabel = UILabel()
        sortButtonLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        sortButtonLabel.textColor = UIColor(red: 115/255, green: 196/255, blue: 230/255, alpha: 1.0)
        sortButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        sortButtonLabel.text = "Sort"
        return sortButtonLabel
    }()
    
    private lazy var filterButtonLabel: UILabel = {
        let filterButtonLabel = UILabel()
        filterButtonLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        filterButtonLabel.textColor = UIColor(red: 115/255, green: 196/255, blue: 230/255, alpha: 1.0)
        filterButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        filterButtonLabel.text = "Filter"
        filterButtonLabel.textAlignment = .right
        return filterButtonLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        animateSpinner()
        setUpHomeTabBar()
        flightList.register(FlightCell.self, forCellReuseIdentifier: cellReusableIdentifier)
        viewModel.delegate = self
        view.addSubview(loadingSpinner)
        viewModel.fetchFlightSearchResponseFromAPI()
    }
    
    init(viewModel: FlightSearchResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animateSpinner() {
        loadingSpinner.center = view.center
        loadingSpinner.startAnimating()
    }
    
    private func setUpHomeTabBar() {

        homeTabController.tabBar.tintColor = UIColor(red: 115/255, green: 196/255, blue: 230/255, alpha: 1.0)
        let tripsViewController = UIViewController()
        let tripImage = UIImage(named: "trips-tab")
        tripsViewController.tabBarItem = UITabBarItem(title: "Trips",
                                                      image: tripImage,
                                                      tag: 0)
        
        let exploreViewController = UIViewController()
        let exploreImage = UIImage(named: "shop-tab")
        exploreViewController.tabBarItem = UITabBarItem(title: "Explore",
                                                        image: exploreImage,
                                                        tag: 1)
        
        let profileViewController = UIViewController()
        let profileImage = UIImage(named: "account-tab")
        profileViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                        image: profileImage,
                                                        tag: 2)
        homeTabController.viewControllers = [exploreViewController,
                                             profileViewController,
                                             tripsViewController]
        self.view.addSubview(homeTabController.view)
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.titleView = navigationBarTitleView
        self.navigationItem.leftBarButtonItem = navigationBarBackButton
        self.navigationItem.rightBarButtonItem = navigationBarShareButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(resultsCountAndButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0))
        constraints.append(resultsCountAndButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0))
        constraints.append(listAndButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(listAndButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(listAndButtonContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(listAndButtonContainer.bottomAnchor.constraint(equalTo:                 view.safeAreaLayoutGuide.bottomAnchor, constant: -48.0))
        constraints.append(flightList.widthAnchor.constraint(equalTo: listAndButtonContainer.widthAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

extension FlightSearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var flightCell: FlightCell
        flightCell = tableView.dequeueReusableCell(withIdentifier: cellReusableIdentifier, for: indexPath) as! FlightCell
        let flightCellViewModel = viewModel.getCellViewModelForIndexPath(index: indexPath.row)
        flightCell = FlightCell(style: .default, reuseIdentifier: cellReusableIdentifier)
        flightCell.updateWithViewModel(flightCellViewModel: flightCellViewModel)
        return flightCell
    }
    
    @objc private func popToPreviousViewController() {
        // TO - DO
    }
    
    @objc private func shareButtonTapped() {
        // TO - DO
    }
}

extension FlightSearchResultsViewController: UpdateFlightSearchresultsDelegate {
    func updateFlightSearchResults() {
        DispatchQueue.main.async {
            self.loadingSpinner.stopAnimating()
            self.sortAndFilterButtonContainer.addSubview(self.resultsCountAndButtonContainer)
            self.listAndButtonContainer.addArrangedSubview(self.sortAndFilterButtonContainer)
            self.listAndButtonContainer.addArrangedSubview(self.flightList)
            self.view.addSubview(self.listAndButtonContainer)
            self.setUpConstraints()
        }
    }
}
