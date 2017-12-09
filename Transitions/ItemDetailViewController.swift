//
//  ItemDetailViewController.swift
//  Transitions
//
//  Created by Firoz Khursheed on 23/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

class ItemDetailViewController: BaseViewController {

  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var itemTitle: UILabel!

  @IBOutlet weak var itemImageViewHeightLayoutConstraint: NSLayoutConstraint!

  var item: Item!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  override func snapshotViewForTransition() -> UIView {
    let snapshotView = itemImageView.snapshotView(afterScreenUpdates: true) ?? UIView()
    let snapshotOrigin = itemImageView.convert(CGPoint.zero, to: view)
    snapshotView.frame.origin = snapshotOrigin
    return snapshotView
  }

  override func snapshotViewInitialFrame() -> CGRect {
    view.layoutIfNeeded()
    return itemImageView.frame
  }
  
  func setupUI() {
    itemImageView.image = item.image
    itemImageView.layer.masksToBounds = true

    itemTitle.text = item.title

    itemImageViewHeightLayoutConstraint.constant = item.image.height(for: itemImageView.frame.size.width)
  }

  
  func getItemImageViewFrame() -> CGRect {
    view.layoutIfNeeded()
    return itemImageView.frame
  }
}
