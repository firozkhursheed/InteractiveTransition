//
//  HomeToItemDetailTransitionAnimator.swift
//  Transitions
//
//  Created by Firoz Khursheed on 23/07/17.
//  Copyright © 2017 Firoz Khursheed. All rights reserved.
//

import UIKit

enum TransitionState {
  case start
  case end
}

class HomeToItemDetailTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let animationDuration = 0.6
  var isPresenting = false
  var isInteractiveTransition = false

  var dismissMediaView: UIView?
  var dismissContainerView: UIView?
  var dismissInitialLocationOffset = CGPoint.zero
  var dismissMediaViewFinalFrame: CGRect?
  var scaleValue: CGFloat?
  
  // MARK: - UIViewControllerAnimatedTransitioning
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    isPresenting ? animatePresentingTransition(using: transitionContext) : animateDismissingTransition(using: transitionContext)
  }
  
  func animatePresentingTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromViewController = transitionContext.viewController(forKey: .from)
    let fromView = transitionContext.view(forKey: .from)
    let toView = transitionContext.view(forKey: .to)
    let containerView = transitionContext.containerView
    let topOffset = CGFloat(64)

    var snapShotView: UIView!
    var leftUpperPoint: CGPoint!
    if let homeViewController = fromViewController as? HomeViewController {
      if let cell = homeViewController.collectionView.cellForItem(at: homeViewController.currentIndexPath) as? HomeCollectionViewCell {
        leftUpperPoint = cell.imageView.convert(CGPoint.zero, to: containerView)
        snapShotView = cell.imageView.snapshotView(afterScreenUpdates: true) ?? UIView()
        snapShotView.frame.origin = leftUpperPoint
      }
    }

    containerView.backgroundColor = UIColor.white
    containerView.addSubview(toView!)
    containerView.addSubview(snapShotView)

    toView?.alpha = 0
    toView?.frame = CGRect(x: toView!.frame.origin.x, y: topOffset, width: toView!.frame.width, height: containerView.frame.height - topOffset)

    let transformValue = UIScreen.main.bounds.size.width / snapShotView.frame.width
    
    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
      snapShotView.transform = CGAffineTransform(scaleX: transformValue, y: transformValue)
      snapShotView.frame = CGRect(x: 0, y: topOffset, width:  snapShotView.frame.width, height: snapShotView.frame.height)
      
      fromView?.transform = CGAffineTransform(scaleX: transformValue, y: transformValue)
      fromView?.frame = CGRect(x: -(leftUpperPoint.x) * transformValue,
                                             y: -(leftUpperPoint.y - topOffset) * transformValue + topOffset,
                                             width: fromView!.frame.size.width,
                                             height: fromView!.frame.size.height)
      fromView?.alpha = 0
    }) { (_) in
      fromView?.alpha = 1.0
      toView?.alpha = 1.0
      snapShotView.removeFromSuperview()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  func animateDismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromViewController = transitionContext.viewController(forKey: .from)
    let fromView = transitionContext.view(forKey: .from)
    let fromViewInitialFrame = fromView?.frame
    let toViewController = transitionContext.viewController(forKey: .to)
    let toView = transitionContext.view(forKey: .to)
    let containerView = transitionContext.containerView
    let topOffset = CGFloat(64)
    
    var snapShotView: UIView!
    if let itemDetailViewController = fromViewController as? ItemDetailViewController {
      snapShotView = itemDetailViewController.itemImageView.snapshotView(afterScreenUpdates: true) ?? UIView()
      snapShotView.frame.origin.y += topOffset
    }

    var finalFrame = CGRect.zero
    if let homeViewController = toViewController as? HomeViewController {
      if let cell = homeViewController.collectionView.cellForItem(at: homeViewController.currentIndexPath) as? HomeCollectionViewCell {
        finalFrame.origin = cell.convert(CGPoint.zero, to: toView)
        finalFrame.size = cell.imageView.frame.size
        finalFrame.origin.y += topOffset
        dismissMediaViewFinalFrame = finalFrame
      } else {
        return
      }
    }

    // Setup InteractiveGestureTransition
    dismissMediaView = snapShotView
    dismissContainerView = containerView
    
    containerView.insertSubview(toView!, belowSubview: fromView!)
    containerView.addSubview(snapShotView)
    toView?.alpha = 0.0

    prepareForTransition(state: .start, homeVC: toViewController as! HomeViewController, itemDetailVC: fromViewController as! ItemDetailViewController)
    scaleValue = finalFrame.width / UIScreen.main.bounds.size.width
    let scaledSize = CGSize(width: fromView!.frame.size.width * scaleValue!, height: fromView!.frame.size.height * scaleValue!)

    UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
        fromView?.alpha = 0.0
      }

      let relativeDuration = self.isInteractiveTransition ? 0.5 : 1
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: relativeDuration, animations: {
        toView?.transform = CGAffineTransform.identity
        toView?.frame = CGRect(x: 0, y: topOffset, width: containerView.frame.width, height: containerView.frame.height - topOffset)
      })

      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
        fromView?.transform = CGAffineTransform(scaleX: self.scaleValue!, y: self.scaleValue!)
        fromView?.frame = CGRect(origin: finalFrame.origin, size: scaledSize)
        
        if !self.isInteractiveTransition {
          snapShotView.transform = CGAffineTransform(scaleX: self.scaleValue!, y: self.scaleValue!)
          snapShotView.frame = finalFrame
        }
        
        toView?.alpha = self.isInteractiveTransition ? 0.8 : 1.0
      }
    }) { (_) in
      self.prepareForTransition(state: .end, homeVC: toViewController as! HomeViewController, itemDetailVC: fromViewController as! ItemDetailViewController)
      snapShotView.removeFromSuperview()
      fromView?.frame = fromViewInitialFrame!
      fromView?.alpha = 1.0
      toView?.alpha = 1.0
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }

  func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer, progress: CGFloat) {
    let location = gestureRecognizer.location(in: dismissContainerView)
    if dismissMediaView != nil && dismissInitialLocationOffset == CGPoint.zero {
      dismissInitialLocationOffset.x = location.x - dismissMediaView!.center.x
      dismissInitialLocationOffset.y = location.y - dismissMediaView!.center.y
    }
    
    if dismissMediaView != nil {
      switch gestureRecognizer.state {
      case .changed:
        var expectedLocation = CGPoint.zero
        expectedLocation.x = location.x - dismissInitialLocationOffset.x
        expectedLocation.y = location.y - dismissInitialLocationOffset.y
        dismissMediaView?.center = expectedLocation
        let transformFactor: CGFloat = -0.6
        let localTransform = (transformFactor * progress) + 1
        self.dismissMediaView?.transform = CGAffineTransform(scaleX: localTransform, y: localTransform)
      case .ended:
        UIView.animate(withDuration: animationDuration / 2, animations: {
          self.dismissMediaView?.transform = CGAffineTransform(scaleX: self.scaleValue!, y: self.scaleValue!)
          self.dismissMediaView?.frame = self.dismissMediaViewFinalFrame!
        }, completion: nil)
      default:
        break
      }
    }
  }

  private func prepareForTransition(state: TransitionState, homeVC: HomeViewController, itemDetailVC: ItemDetailViewController) {
    var shouldHide: Bool!
    switch state {
    case .start:
      shouldHide = true
    case .end:
      shouldHide = false
    }

    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
      self.getCell(from: homeVC).imageView.isHidden = shouldHide
      itemDetailVC.itemImageView.isHidden = shouldHide
    })
  }

  private func getCell(from homeVC: HomeViewController) -> HomeCollectionViewCell {
    return homeVC.collectionView.cellForItem(at: homeVC.currentIndexPath) as! HomeCollectionViewCell
  }
}
