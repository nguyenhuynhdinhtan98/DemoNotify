//
//  ShadowView.swift
//  DemoNotify
//
//  Created by Tân Nguyễn on 31/03/2023.
//

import Foundation
import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        layer.shadowPath = CGPath(rect: layer.bounds, transform: nil)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
        layer.cornerRadius = 5

    }
}
