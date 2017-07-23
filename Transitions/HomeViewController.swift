//
//  HomeViewController.swift
//  Transition
//
//  Created by Firoz Khursheed on 22/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class HomeViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!

  var items = [Item]()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupItems()
    setupCollectionView()
  }

  func setupItems() {
    let item1 = Item(image: #imageLiteral(resourceName: "Apesposter"), title: "War for the planet of the apes")
    let item2 = Item(image: #imageLiteral(resourceName: "Dangal"), title: "Dangal")
    let item3 = Item(image: #imageLiteral(resourceName: "Despicable-me-3"), title: "Despicable me 3")
    let item4 = Item(image: #imageLiteral(resourceName: "Doctor-strange"), title: "Doctor strange")
    let item5 = Item(image: #imageLiteral(resourceName: "Jagga-jasoos"), title: "Jagga jasoos")
    let item6 = Item(image: #imageLiteral(resourceName: "La-la-land"), title: "La la land")
    let item7 = Item(image: #imageLiteral(resourceName: "Me-before-you"), title: "Me before you")
    let item8 = Item(image: #imageLiteral(resourceName: "Moana"), title: "Moana")
    let item9 = Item(image: #imageLiteral(resourceName: "Now-you-see-me-2"), title: "Now you see me 2")
    let item10 = Item(image: #imageLiteral(resourceName: "Spider-man-homecoming"), title: "Spiderman: Homecoming")


    items.append(item1)
    items.append(item2)
    items.append(item3)
    items.append(item4)
    items.append(item5)
    items.append(item6)
    items.append(item7)
    items.append(item8)
    items.append(item9)
    items.append(item10)
  }

  func setupCollectionView() {
//    collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
    let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")

    let collectionViewLayout = CHTCollectionViewWaterfallLayout()
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    collectionView.collectionViewLayout = collectionViewLayout
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "homeToItemDetailSegue" {
      let itemDetailViewController = segue.destination as! ItemDetailViewController
      itemDetailViewController.item = sender as! Item
    }
  }
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
    cell.item = items[indexPath.row]
    return cell
  }
}

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedItem = items[indexPath.row]
    performSegue(withIdentifier: "homeToItemDetailSegue", sender: selectedItem)
  }
}

extension HomeViewController: CHTCollectionViewDelegateWaterfallLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let padding: CGFloat = 25
    let collectionCellSize = collectionView.frame.size.width - padding

    let item = items[indexPath.row]
    let height = item.image.height(for: collectionCellSize/2) + HomeCollectionViewCell.bottomPadding + HomeCollectionViewCell.labelHeight
    return CGSize(width: collectionCellSize / 2, height: height)
  }
}
