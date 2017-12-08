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
  @IBOutlet weak var genreLabel: UILabel!
  
  var item: Item! {
    didSet {
      imageView.image = item.image
      titleLabel.text = item.title
      genreLabel.text = item.genre
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    layer.shadowColor = UIColor.pictonBlue.cgColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 3.0
    layer.shadowOffset = CGSize(width: 0.0, height: 0.6)
    layer.cornerRadius = 4
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 4
  }

  func snapshot() -> UIView {
    return imageView.snapshotView(afterScreenUpdates: true) ?? imageView
  }
}
