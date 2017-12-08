//
//  GradientHelper.swift
//  Transitions
//
//  Created by Firoz Khursheed on 07/12/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

class GradientHelper {
  class func createNavigationBarGradient(with frame: CGRect) -> CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.frame = frame
    gradient.locations = [0.0, 1.0]
    gradient.colors = [UIColor.curiousBlue.cgColor, UIColor.pictonBlue.cgColor]
    return gradient
  }
}
