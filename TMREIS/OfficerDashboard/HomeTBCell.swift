//
//  HomeTBCell.swift
//  TMREIS
//
//  Created by naresh banavath on 20/05/21.
//

import UIKit

class HomeTBCell: UITableViewCell {

  @IBOutlet weak var empNameLb: UILabel!
  @IBOutlet weak var designation: UILabel!
  @IBOutlet weak var usrInitialLetterLb: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
