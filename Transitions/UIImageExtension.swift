//
//  UIImageExtension.swift
//  Transitions
//
//  Created by Firoz Khursheed on 23/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

extension UIImage {
  func height(for width: CGFloat) -> CGFloat {
    let sizeRatio = size.width / size.height
    return width / sizeRatio
  }
}
