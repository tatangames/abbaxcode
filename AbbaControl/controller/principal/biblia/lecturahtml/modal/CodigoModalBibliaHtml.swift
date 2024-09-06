//
//  CodigoModalBibliaHtml.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 18/3/24.
//
import UIKit

class CodigoModalBibliaHtml: UIPresentationController {
 
  let blurEffectView: UIVisualEffectView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
    
    
    
    var customHeight: CGFloat = 400 // Define la altura personalizada deseada

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let safeAreaFrame = containerView.bounds
        let presentedViewFrame = CGRect(x: 0,
                                        y: safeAreaFrame.height - customHeight,
                                        width: safeAreaFrame.width,
                                        height: customHeight)
        return presentedViewFrame
    }
    
   /* override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                0.6))
    }*/


  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .dark)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
  }
  

  override func presentationTransitionWillBegin() {
     /* self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0.7
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
      
      */
      
    
      
      /*guard let containerView = containerView else { return }
      let dimmingView = UIView(frame: containerView.bounds)
      dimmingView.backgroundColor = UIColor.clear // Establece el color de fondo sin transparencia
      containerView.insertSubview(dimmingView, at: 0)

      presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
          // Realiza animaciones si es necesario
      }, completion: nil)*/
      
      
      guard let containerView = containerView else { return }
              let dimmingView = UIView(frame: containerView.bounds)
              dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5) // Fondo semitransparente
              dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
              containerView.insertSubview(dimmingView, at: 0)
      
      presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                // Realiza animaciones si es necesario
            }, completion: nil)
  }
    
    @objc func dimmingViewTapped() {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
  
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
  }
  
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
    presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
  }

  @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}

