//
//  UIColorExtension.swift
//  Transitions
//
//  Created by Firoz Khursheed on 07/12/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    let newRed = CGFloat(Double(red) / 255.0)
    let newGreen = CGFloat(Double(green) / 255.0)
    let newBlue = CGFloat(Double(blue) / 255.0)
    
    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(1.0))
  }

  class var curiousBlue: UIColor {
    return UIColor(red: 32, green: 150, blue: 200)
  }

  class var pictonBlue: UIColor {
    return UIColor(red: 40, green: 190, blue: 240)
  }
  
  class var mercury: UIColor {
    return UIColor(red: 235, green: 235, blue: 235)
  }
}
