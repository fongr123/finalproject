//
//  ReminderTableViewCell.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class ReminderTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var reminderDueTimeLabel: UILabel!
    @IBOutlet weak var reminderDetailsLabel: UILabel!
    @IBOutlet weak var reminderNameLabel: UILabel!
    @IBOutlet weak var reminderImageView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
