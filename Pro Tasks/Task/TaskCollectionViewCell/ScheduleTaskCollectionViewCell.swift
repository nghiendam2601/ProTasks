

import UIKit

class ScheduleTaskCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet var MainViewCell: UIView!
    @IBOutlet var WeekLabel: UILabel!
    @IBOutlet var DayLabel: UILabel!
    @IBOutlet var YearLabel: UILabel!
    @IBOutlet var viewCircle: UIView!
    
    //MARK: - NIB setup
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCircle.layer.cornerRadius = 28
        viewCircle.clipsToBounds = true
        viewCircle.layer.borderWidth = 2
        viewCircle.layer.borderColor = UIColor(named: "Color")?.cgColor
        MainViewCell.clipsToBounds = true
        MainViewCell.layer.cornerRadius = 15

        
    }

}
