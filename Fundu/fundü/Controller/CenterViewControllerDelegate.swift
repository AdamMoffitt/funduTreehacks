//
//  CenterViewControllerDelegate.swift
//  fundü
//
//  Created by Jordan Coppert on 12/3/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol CenterViewControllerDelegate{
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}
