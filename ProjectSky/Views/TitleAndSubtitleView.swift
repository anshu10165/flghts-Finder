
import Foundation
import UIKit

class TitleAndSubtitleView : UIStackView {
    
    var viewModel: TitleAndSubtitleViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            self.title.text = viewModel.title
            self.title.font = viewModel.titleFont
            self.title.textColor = viewModel.titleColor
            self.subtitle.text = viewModel.subtitle
            self.subtitle.font = viewModel.subtitleFont
            self.subtitle.textColor = viewModel.subtitleColor
        }
    }
    
    private lazy var title: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.textAlignment = .right
        return subtitle
    }()
    
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        setUpViews()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private func setUpViews() {
        addArrangedSubview(title)
        addArrangedSubview(subtitle)
    }
}
