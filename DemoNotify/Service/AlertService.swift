//
//  AlertService.swift
//  DemoNotify
//
//  Created by Tân Nguyễn on 01/04/2023.
//

import Foundation
import UIKit

class AlertService {
    private init() {}
    static func actionSheets(in vc: UIViewController, title: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
