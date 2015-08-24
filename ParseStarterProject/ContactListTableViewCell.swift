//
//  ContactListTableViewCell.swift
//  ParseStarterProject
//
//  Created by Richard Fong on 8/22/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var personName: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
