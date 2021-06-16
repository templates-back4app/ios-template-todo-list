//
//  ItemCell.swift
//  Todo_List_Back4app
//
//  Created by Lucas Fraga Schuler on 6/16/21.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var delete_btn: UIButton!
    
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
