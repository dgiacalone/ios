//
//  OtherDayCell.swift
//  lab6
//
//  Created by Delaney Giacalone on 10/26/16.
//  Copyright © 2016 Delaney Giacalone. All rights reserved.
//

import UIKit

class OtherDayCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var highLowLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
