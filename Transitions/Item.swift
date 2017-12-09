//
//  Item.swift
//  Transition
//
//  Created by Firoz Khursheed on 23/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

class Item {
  var image: UIImage!
  var title: String!
  var genre: String!

  init(image: UIImage, title: String, genre: String) {
    self.image = image
    self.title = title
    self.genre = genre
  }
}
