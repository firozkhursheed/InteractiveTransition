//
//  HomeCollectionViewCell.swift
//  Transition
//
//  Created by Firoz Khursheed on 22/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

  static let bottomPadding = CGFloat(40)
  static let labelHeight = CGFloat(21)
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!

  var item: Item! {
    didSet {
      imageView.image = item.image
      titleLabel.text = item.title
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

}
