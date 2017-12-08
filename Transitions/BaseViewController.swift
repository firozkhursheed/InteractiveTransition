//
//  BaseViewController.swift
//  Transitions
//
//  Created by Firoz Khursheed on 08/12/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

  var navigationBarGradient: CAGradientLayer?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    addNavigationBarGradient()
  }
  
  func snapshotViewForTransition() -> UIView {
    fatalError("Must Override")
  }
  
  func snapshotViewInitialFrame() -> CGRect {
    fatalError("Must Override")
  }
  
  func addNavigationBarGradient() {
    removeNavigationBarGradient()
    navigationBarGradient = GradientHelper.createNavigationBarGradient(with: CGRect(origin: .zero, size: CGSize(width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height)))
    view.layer.addSublayer(navigationBarGradient!)
  }
  
  func removeNavigationBarGradient() {
    navigationBarGradient?.removeFromSuperlayer()
  }
}
