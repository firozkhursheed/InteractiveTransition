//
//  HomeViewController.swift
//  Transition
//
//  Created by Firoz Khursheed on 22/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class HomeViewController: BaseViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var shadowTopView: UIView!
  
  var currentIndexPath: IndexPath!
  var items = [Item]()
  let swipePercentDrivenInteractiveTransition = SwipePercentDrivenInteractiveTransition()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupItems()
    setupGradientShadow()
    setupCollectionView()
    setupNavigationBar()
  }

  override func snapshotViewForTransition() -> UIView {
    if let cell = collectionView.cellForItem(at: currentIndexPath) as? HomeCollectionViewCell {
      let snapShotView = cell.snapshot()
      let leftUpperPoint = cell.imageView.convert(CGPoint.zero, to: view)
      snapShotView.frame.origin = leftUpperPoint
      return snapShotView
    }
    
    return UIView()
  }
  
  override func snapshotViewInitialFrame() -> CGRect {
    if let cell = collectionView.cellForItem(at: currentIndexPath) as? HomeCollectionViewCell {
      let cellOrigin = cell.imageView.convert(CGPoint.zero, to: view)
      return CGRect(origin: cellOrigin, size: cell.imageView.frame.size)
    }
    
    return .zero
  }

  func setupItems() {
    items.append(Item(image: #imageLiteral(resourceName: "Apesposter"), title: "War for the planet of the apes", genre: "Science Fiction"))
    items.append(Item(image: #imageLiteral(resourceName: "Dangal"), title: "Dangal", genre: "Biographical"))
    items.append(Item(image: #imageLiteral(resourceName: "Despicable-me-3"), title: "Despicable me 3", genre: "Animation"))
    items.append(Item(image: #imageLiteral(resourceName: "Doctor-strange"), title: "Doctor strange", genre: "Adventure"))
    items.append(Item(image: #imageLiteral(resourceName: "Jagga-jasoos"), title: "Jagga jasoos", genre: "Adventure"))
    items.append(Item(image: #imageLiteral(resourceName: "La-la-land"), title: "La la land", genre: "Romance"))
    items.append(Item(image: #imageLiteral(resourceName: "Me-before-you"), title: "Me before you", genre: "Romance"))
    items.append(Item(image: #imageLiteral(resourceName: "Moana"), title: "Moana", genre: "Animation"))
    items.append(Item(image: #imageLiteral(resourceName: "Now-you-see-me-2"), title: "Now you see me 2", genre: "Adventure"))
    items.append(Item(image: #imageLiteral(resourceName: "Spider-man-homecoming"), title: "Spiderman: Homecoming", genre: "Adventure"))
  }

  private func setupGradientShadow() {
    let gradient = CAGradientLayer()
    gradient.frame = shadowTopView.bounds
    gradient.colors = [UIColor.gray.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
    shadowTopView.layer.addSublayer(gradient)
  }
  
  private func setupNavigationBar() {
    let navBar = navigationController?.navigationBar

    navBar?.tintColor = .white
    navBar?.setBackgroundImage(UIImage(), for: .default)
    navBar?.shadowImage = UIImage()
    navBar?.isTranslucent = true
  }

  func setupCollectionView() {
    let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")

    let collectionViewLayout = CHTCollectionViewWaterfallLayout()
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    collectionView.collectionViewLayout = collectionViewLayout
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == "homeToItemDetailSegue" {
      navigationController?.delegate = self
      let itemDetailViewController = segue.destination as! ItemDetailViewController
      itemDetailViewController.item = sender as! Item
      swipePercentDrivenInteractiveTransition.wireTo(viewController: itemDetailViewController)
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
    currentIndexPath = indexPath
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
    return CGSize(width: (collectionCellSize / 2), height: height)
  }
}

extension HomeViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if fromVC is ItemDetailViewController || toVC is ItemDetailViewController {
      let homeToItemDetailTransitionAnimator = HomeToItemDetailTransitionAnimator()
      homeToItemDetailTransitionAnimator.isPresenting = operation == .push
      swipePercentDrivenInteractiveTransition.homeToItemDetailTransitionAnimator = homeToItemDetailTransitionAnimator
      if swipePercentDrivenInteractiveTransition.isInteractionInProgress { homeToItemDetailTransitionAnimator.isInteractiveTransition = true }

      return homeToItemDetailTransitionAnimator
    }

    return nil
  }

  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return swipePercentDrivenInteractiveTransition.isInteractionInProgress ? swipePercentDrivenInteractiveTransition : nil
  }
}
