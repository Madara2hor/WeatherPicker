//
//  UIView.swift
//  WearPicker
//
//  Created by Madara2hor on 17.11.2020.
//

import Foundation
import UIKit

extension UIView {
    func setBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        self.addSubview(blurredEffectView)
    }
    
    func makeCircle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeTransparent(color: UIColor?) {
        guard color != nil else {
            self.backgroundColor?.withAlphaComponent(0.5)
            return
        }
        self.backgroundColor = color!.withAlphaComponent(0.5)
    }
}
