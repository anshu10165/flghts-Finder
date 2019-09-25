
import UIKit
import Foundation

class TitleAndSubtitleViewModel {
    
    let title: String
    let subtitle: String
    let titleFont: UIFont
    let subtitleFont: UIFont
    let subtitleColor: UIColor
    let titleColor: UIColor
    
    init(title: String, subtitle: String, titlefont: UIFont, subtitleFont: UIFont, titlecolor: UIColor, subtitleColor: UIColor) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleFont = subtitleFont
        self.titleFont = titlefont
        self.titleColor = titlecolor
        self.subtitleColor = subtitleColor
    }
}
