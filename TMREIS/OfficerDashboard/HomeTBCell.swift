//
//  HomeTBCell.swift
//  TMREIS
//
//  Created by naresh banavath on 20/05/21.
//

import UIKit

class HomeTBCell: UITableViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var empNameLb: UILabel!
  @IBOutlet weak var designation: UILabel!
  @IBOutlet weak var usrInitialLetterLb: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    containerView.layer.cornerRadius = 5.0
//    containerView.layer.shadowColor = UIColor.gray.cgColor
//    containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//    containerView.layer.shadowRadius = 2.0
//    containerView.layer.shadowOpacity = 0.7
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
