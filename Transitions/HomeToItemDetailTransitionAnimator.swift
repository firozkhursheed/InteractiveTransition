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

  let animationDuration = 0.3
  var isPresenting = false
  var isInteractiveTransition = false

  var interactiveSnapshotView: UIView?
  var dismissContainerView: UIView?
  var dismissToView: UIView?
  var dismissInitialLocationOffset = CGPoint.zero
  var interactiveSnapshotViewFinalFrame: CGRect?
  var scaleDownTransformValue: CGFloat?
  
  // MARK: - UIViewControllerAnimatedTransitioning
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    isPresenting ? animatePresentingTransition(using: transitionContext) : animateDismissingTransition(using: transitionContext)
  }
  
  func animatePresentingTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from) as? BaseViewController else { return }
    guard let toViewController = transitionContext.viewController(forKey: .to) as? BaseViewController else { return }
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }

    let containerView = transitionContext.containerView
    let snapshotView = fromViewController.snapshotViewForTransition()
    let snapshotViewOrigin = snapshotView.frame.origin

    containerView.backgroundColor = UIColor.mercury
    containerView.addSubview(toView)
    containerView.addSubview(snapshotView)
    
    addNavigationGradientLayer(to: containerView, from: toViewController)
    toView.alpha = 0
    
    let toFrame = toViewController.snapshotViewInitialFrame()
    let xTransformValue = toFrame.width / snapshotView.frame.width
    let yTransformValue = toFrame.height / snapshotView.frame.height
    
    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
      snapshotView.transform = CGAffineTransform(scaleX: xTransformValue, y: yTransformValue)
      snapshotView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y, width: snapshotView.frame.width, height: snapshotView.frame.height)
      
      fromView.transform = CGAffineTransform(scaleX: xTransformValue, y: yTransformValue)
      fromView.frame = CGRect(x: -(snapshotViewOrigin.x) * xTransformValue + toFrame.origin.x,
                              y: -(snapshotViewOrigin.y) * yTransformValue + toFrame.origin.y,
                              width: fromView.frame.size.width,
                              height: fromView.frame.size.height)
      fromView.alpha = 0
    }) { (_) in
      fromView.alpha = 1.0
      toView.alpha = 1.0
      fromView.transform = .identity
      snapshotView.removeFromSuperview()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  func animateDismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from) as? BaseViewController else { return }
    guard let toViewController = transitionContext.viewController(forKey: .to) as? BaseViewController else { return }
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }
    let fromViewInitialFrame = fromView.frame
    let containerView = transitionContext.containerView

    let snapshotView = fromViewController.snapshotViewForTransition()
    let snapshotViewInitialFrame = fromViewController.snapshotViewInitialFrame()
    let snapshotViewFinalFrame = toViewController.snapshotViewInitialFrame()

    fromViewController.removeNavigationBarGradient()
    
    // Setup InteractiveGestureTransition
    interactiveSnapshotView = snapshotView
    dismissContainerView = containerView
    interactiveSnapshotViewFinalFrame = snapshotViewFinalFrame
    dismissToView = toView
    
    let scaleUpTransformValue = snapshotViewInitialFrame.width / snapshotViewFinalFrame.width
    toView.transform = CGAffineTransform(scaleX: scaleUpTransformValue, y: scaleUpTransformValue)
    toView.frame.origin = CGPoint(x: -(snapshotViewFinalFrame.origin.x) * scaleUpTransformValue + snapshotViewInitialFrame.origin.x,
                                  y: -(snapshotViewFinalFrame.origin.y) * scaleUpTransformValue + snapshotViewInitialFrame.origin.y)
    
    containerView.insertSubview(toView, belowSubview: fromView)
    containerView.addSubview(snapshotView)
    toView.alpha = 0.0

    prepareForTransition(state: .start, homeVC: toViewController as! HomeViewController, itemDetailVC: fromViewController as! ItemDetailViewController)
    scaleDownTransformValue = snapshotViewFinalFrame.width / snapshotViewInitialFrame.width
    let scaledSize = CGSize(width: fromView.frame.size.width * scaleDownTransformValue!, height: fromView.frame.size.height * scaleDownTransformValue!)

    UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
        fromView.alpha = 0.0
      }

      let relativeDuration = self.isInteractiveTransition ? 0.5 : 1
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: relativeDuration, animations: {
        toView.transform = CGAffineTransform.identity
        toView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
      })

      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
        fromView.transform = CGAffineTransform(scaleX: self.scaleDownTransformValue!, y: self.scaleDownTransformValue!)
        fromView.frame = CGRect(origin: snapshotViewFinalFrame.origin, size: scaledSize)
        
        if !self.isInteractiveTransition {
          snapshotView.transform = CGAffineTransform(scaleX: self.scaleDownTransformValue!, y: self.scaleDownTransformValue!)
          snapshotView.frame = snapshotViewFinalFrame
        }
        
        toView.alpha = self.isInteractiveTransition ? 0.8 : 1.0
      }
    }) { (_) in
      self.prepareForTransition(state: .end, homeVC: toViewController as! HomeViewController, itemDetailVC: fromViewController as! ItemDetailViewController)
      snapshotView.removeFromSuperview()
      fromView.frame = fromViewInitialFrame
      fromView.alpha = 1.0
      toView.alpha = 1.0
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }

  func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer, progress: CGFloat) {
    let location = gestureRecognizer.location(in: dismissContainerView)
    if interactiveSnapshotView != nil && dismissInitialLocationOffset == CGPoint.zero {
      dismissInitialLocationOffset.x = location.x - interactiveSnapshotView!.center.x
      dismissInitialLocationOffset.y = location.y - interactiveSnapshotView!.center.y
    }
    
    if interactiveSnapshotView != nil {
      switch gestureRecognizer.state {
      case .changed:
        var expectedLocation = CGPoint.zero
        expectedLocation.x = location.x - dismissInitialLocationOffset.x
        expectedLocation.y = location.y - dismissInitialLocationOffset.y
        interactiveSnapshotView?.center = expectedLocation
        let transformFactor: CGFloat = -0.6
        let localTransform = (transformFactor * progress) + 1
        self.interactiveSnapshotView?.transform = CGAffineTransform(scaleX: localTransform, y: localTransform)
      case .ended:
        UIView.animate(withDuration: animationDuration / 2, animations: {
          self.interactiveSnapshotView?.transform = CGAffineTransform(scaleX: self.scaleDownTransformValue!, y: self.scaleDownTransformValue!)
          self.interactiveSnapshotView?.frame = self.interactiveSnapshotViewFinalFrame!
          self.dismissToView?.alpha = 1
        }, completion: nil)
      default:
        break
      }
    }
  }

  private func addNavigationGradientLayer(to containerView: UIView, from viewController: UIViewController) {
    if let navBar = viewController.navigationController?.navigationBar {
      let gradient = GradientHelper.createNavigationBarGradient(with: CGRect(origin: .zero, size: CGSize(width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + navBar.frame.height)))
      containerView.layer.addSublayer(gradient)
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
