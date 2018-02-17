//
//  LeaguesTableViewCell.swift
//  fundü
//
//  Created by Adam Moffitt on 2/7/18.
//  Copyright © 2018 fundü. All rights reserved.
//

import UIKit

class LeaguesTableViewCell: UITableViewCell {

    var titleLabel : UILabel!
    var stockLabel : UILabel!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let gap : CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = 100
        let lineGap : CGFloat = 5
        let label2Y : CGFloat = gap + labelHeight + lineGap
        let imageSize : CGFloat = 30
        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: gap, y: gap, width: labelWidth, height: labelHeight)
        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)
        
        stockLabel = UILabel()
        stockLabel.frame = CGRect(x: 160, y: 10, width: 50, height: labelHeight)
        stockLabel.textColor = UIColor.black
        contentView.addSubview(stockLabel)
    }
}
