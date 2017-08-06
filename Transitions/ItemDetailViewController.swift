//
//  ItemDetailViewController.swift
//  Transitions
//
//  Created by Firoz Khursheed on 23/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var itemTitle: UILabel!

  @IBOutlet weak var itemImageViewHeightLayoutConstraint: NSLayoutConstraint!

  var item: Item!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }

  func setupUI() {
    itemImageView.image = item.image
    itemTitle.text = item.title

    itemImageViewHeightLayoutConstraint.constant = item.image.height(for: view.frame.size.width)
  }
}
