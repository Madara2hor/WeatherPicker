//
//  UIAlertController.swift
//  WearPicker
//
//  Created by Madara2hor on 19.11.2020.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class var locationPremissionAlert: UIAlertController {
        get {
            let alertController = UIAlertController(title: "Hey!", message: "Please, go to settings and turn on the permissions to get weather by current location", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                 }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            return alertController
        }
    }
    
}
