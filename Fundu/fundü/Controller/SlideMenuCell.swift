//
//  SlideMenuCell.swift
//  fundü
//
//  Created by Jordan Coppert on 12/4/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import UIKit

class SlideMenuCell: UITableViewCell {
    var option:String!
    var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func createTitleLabel(){
        label = UILabel()
        label.text = option
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        contentView.addSubview(label)
    }
    
    func setConstraints(){
        let margins = contentView.layoutMarginsGuide
        label.leadingAnchor.constraintEqualToSystemSpacingAfter(margins.leadingAnchor, multiplier: 0.03).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
        
    
    func setupViews(text:String){
        contentView.backgroundColor = UIColor.gray
        option = text
        createTitleLabel()
        setConstraints()
    }

}
