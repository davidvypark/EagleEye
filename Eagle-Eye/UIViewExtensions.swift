//
//  UIViewExtensions.swift
//  Eagle-Eye
//
//  Created by David Park on 7/14/16.
//  Copyright © 2016 David Park. All rights reserved.
//

import Foundation
import UIKit
import SimpleAnimation

extension UIView {
    
    func customFadeIn() {
        UIView.animateWithDuration(1.0, animations: {self.alpha = 1.0})
    }
    
    func customFadeOut() {
        UIView.animateWithDuration(1.0, animations: {self.alpha = 0.0})
    }
    
    func moveCenterTo(target: CGPoint, returnPoint: CGPoint) {
        
        UIView.animateWithDuration(1.0, animations: {self.alpha = 1.0}, completion:{(finished:Bool) in UIView.animateWithDuration(0.0, animations: {self.center = returnPoint})
            UIView.animateWithDuration(0.5, animations: {self.center = target}, completion:
                {(finished:Bool) in
                    UIView.animateWithDuration(1.0, animations: {self.alpha = 0.0}, completion:
                        {(finished:Bool) in
                            UIView.animateWithDuration(0.0, animations: {self.center = returnPoint})
                })
            })
        })
    }


}