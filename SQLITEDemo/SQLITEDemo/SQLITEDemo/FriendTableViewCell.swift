//
//  FriendTableViewCell.swift
//  SQLITEDemo
//
//  Created by Esraa Hassan on 5/31/19.
//  Copyright © 2019 Esraa And Passant. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendAge: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPhone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
