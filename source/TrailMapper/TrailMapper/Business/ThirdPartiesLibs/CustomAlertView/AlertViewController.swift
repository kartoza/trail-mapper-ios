//
//  AlertViewController.swift
//  SwiftArchitecture
//
//  Created by Navnath Wagh on 7/13/17.
//  Copyright © 2017 Netwin. All rights reserved.
//

import UIKit

enum AlertAnimationType{
    case scale
    case rotate
    case bounceUp
    case bounceDown
    case fromCenter
}

enum AlertActionType{
    case normal
    case cancel
}

typealias AlertActionHandler = () -> Void


class AlertViewController: UIView {
    //MARK:- Outlets
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var posButton: UIButton!
    @IBOutlet weak var negButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    //animation variables
    var imgLogo: UIImage?
    var animateDuration: TimeInterval = 1.0
    var scaleX: CGFloat = 0.3
    var scaleY: CGFloat = 1.5
    var rotateRadian:CGFloat = 1.5 // 1 rad = 57 degrees
    var springWithDamping: CGFloat = 0.7
    var delay: TimeInterval = 0
    
    //inital values
    private var titleMessage: String = ""
    private var message: String = ""
    private var animationType: AlertAnimationType = .fromCenter
    
    private var negativeAction: AlertAction?
    private var positiveAction: AlertAction?
    
    
    //MARK:- init and draw
    override  init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_SIZE.width, height: Constants.SCREEN_SIZE.height)
    }
    
    override func draw(_ rect: CGRect) {
        
        alertView.alpha = 0
        alertView.layer.cornerRadius = 10
        alertView.clipsToBounds = true
//        if negButton == nil{
//            negButton.isHidden = true
//        }
        startAnimating(type: AlertAnimationType.fromCenter)
    }

    //MARK: - Configuration of alert
    
    class func create() -> AlertViewController{
        let alertVC = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?[0]
        return alertVC as! AlertViewController
    }
    
    func config(title: String, message: String, animationType: AlertAnimationType = .scale,CancelButton isCancel:Bool) -> AlertViewController {
        if isCancel == false {
            
            DispatchQueue.main.async(execute: {
                self.negButton.isHidden = true;
            });
        }
        
        self.titleMessage = title
        self.message = message
        self.animationType = animationType
        //self.imageView.image = imgLogo
        return self
    }
    
    func show(into view: UIView){
        view.addSubview(self)
        self.setupButton()
        self.configUI()
    }
    
    func configUI(){
        self.titleLabel.text = titleMessage
        self.messageLabel.text = message
    }
    
    private func setupButton(){
        
        if let posAction = self.positiveAction{
            self.posButton.setTitle(posAction.title, for: .normal)
        }
        if let negAction = self.negativeAction{
            self.negButton.isHidden = false
            self.negButton.setTitle(negAction.title, for: .normal)
        }
    }
    
    //change and call image from here
    func showCheckImage(_ isCheck: Bool){
        imgLogo = (isCheck) ?  UIImage.init(named: ""): UIImage.init(named: "3")
    }
    
    //MARK:- Animation
    ///change required animation
    private func startAnimating(type: AlertAnimationType){
        
        alertView.alpha = 1
        switch type {
        case .rotate:
            alertView.transform = CGAffineTransform(rotationAngle: rotateRadian)
        case .bounceUp:
            let screenHeight = UIScreen.main.bounds.height/2 + alertView.frame.height/2
            alertView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .bounceDown:
            let screenHeight = -(UIScreen.main.bounds.height/2 + alertView.frame.height/2)
            alertView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .fromCenter :
            
            let animation = CAKeyframeAnimation(keyPath: "transform")
            let scale1: CATransform3D = CATransform3DMakeScale(0.5, 0.5, 1)
            let scale2: CATransform3D = CATransform3DMakeScale(1.2, 1.2, 1)
            let scale3: CATransform3D = CATransform3DMakeScale(0.9, 0.9, 1)
            let scale4: CATransform3D = CATransform3DMakeScale(1.0, 1.0, 1)
            let frameValues: [Any] = [NSValue(caTransform3D: scale1), NSValue(caTransform3D: scale2), NSValue(caTransform3D: scale3), NSValue(caTransform3D: scale4)]
            animation.values = frameValues
            let frameTimes: [Any] = [Float(0.0), Float(0.5), Float(0.9), Float(1.0)]
            animation.keyTimes = frameTimes as? [NSNumber] ?? [NSNumber]()
            animation.fillMode = kCAGravityTop
            animation.isRemovedOnCompletion = false
            animation.duration = 0.5
            self.alertView.layer.add((animation) , forKey: "show")
            
        default:
            alertView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }
        UIView.animate(withDuration: animateDuration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.alertView.transform = .identity
        }, completion: nil)
    }
    
    private func stopAnimating(type: AlertAnimationType){
        
        alertView.alpha = 1
        switch type {
        case .rotate:
            alertView.transform = CGAffineTransform(rotationAngle: rotateRadian)
        case .bounceUp:
            let screenHeight = UIScreen.main.bounds.height/2 + alertView.frame.height/2
            alertView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .bounceDown:
            let screenHeight = +(UIScreen.main.bounds.height/2 + alertView.frame.height/2)
            alertView.transform = CGAffineTransform(translationX: screenHeight, y: UIScreen.main.bounds.height)
        case .fromCenter :
            
            let animation = CAKeyframeAnimation(keyPath: "transform")
            let scale1: CATransform3D = CATransform3DMakeScale(1.0, 1.0, 1)
            let scale2: CATransform3D = CATransform3DMakeScale(0.5, 0.5, 1)
            let scale3: CATransform3D = CATransform3DMakeScale(0.0, 0.0, 1)
            let frameValues: [Any] = [NSValue(caTransform3D: scale1), NSValue(caTransform3D: scale2), NSValue(caTransform3D: scale3)]
            animation.values = frameValues as [Any]
            let frameTimes: [Any] = [Float(0.0), Float(0.5), Float(0.9)]
            animation.keyTimes = frameTimes as? [NSNumber] ?? [NSNumber]()
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.duration = 0.1
            alertView.layer.add((animation ) , forKey: "hide")
            
            
        default:
            alertView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }
        perform(#selector(self.removeFromSuperview), with: self, afterDelay: 0.105)
        
        UIView.animate(withDuration: animateDuration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.alertView.transform = .identity
        }, completion: nil)
    }
    
    
    func addAction(_ action: AlertAction){
        switch action.type{
        case .normal:
            positiveAction = action
        case .cancel:
            negativeAction = action
        }
    }
    
    //MARK: - Action implementation
    @IBAction func tapPositiveButton(_ sender: Any) {
        self .stopAnimating(type: .fromCenter)
       //self.removeFromSuperview()
        if let posHandler = self.positiveAction?.handler{
            posHandler()
        }
    }
    
    @IBAction func tapNegativeButton(_ sender: Any) {
        self .stopAnimating(type: .fromCenter)
        if let negHandler = self.negativeAction?.handler{
            negHandler()
        }
    }
}

//class for adding handler to action
class AlertAction{
    let title: String
    let type: AlertActionType
    let handler: AlertActionHandler?
    
    init(title: String, type: AlertActionType, handler: AlertActionHandler?){
        self.title = title
        self.type = type
        self.handler = handler
    }
}

