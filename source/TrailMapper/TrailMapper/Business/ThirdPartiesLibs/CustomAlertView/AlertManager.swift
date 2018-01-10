//
//  AlertManager.swift
//  SwiftArchitecture
//
//  Created by Navnath Wagh on 7/13/17.
//  Copyright © 2017 Netwin. All rights reserved.
//

import UIKit


class AlertManager: NSObject {
    
    typealias AlertActionHandler = () -> Void
    static var alertVC: AlertViewController!
    
    /// Enum for types of notifications
    enum CRNotificationType {
        case success
        case error
        case info
    }

    //show alert message with positive and naegative button. for single button pass negativetitle empty constant.
    static func showCustomAlert(Title title:String, Message message: String,PositiveTitle posBtnTitle:String,NegativeTitle negBtnTitle: String, onPositive positive: @escaping AlertActionHandler, onNegative negative: @escaping AlertActionHandler){
        
        var isCancel = true
        if(negBtnTitle.isEmpty){
           isCancel = false
        }
        
        alertVC = AlertViewController.create().config(title: title, message: message, CancelButton: isCancel)
        alertVC.addAction(AlertAction(title: posBtnTitle, type: .normal, handler: {
            positive()
        }))
        alertVC.addAction(AlertAction(title: negBtnTitle, type: .cancel, handler: {
            negative()
            
        }))
        
        self.alertVC.show(into: UIApplication.shared.keyWindow! )
    }
    
    static func showCustomInfoAlert(Title title:String, Message message: String,PositiveTitle posBtnTitle:String){
        
        alertVC = AlertViewController.create().config(title: title, message: message, CancelButton: false)
        alertVC.addAction(AlertAction(title: posBtnTitle, type: .normal, handler: {
            //positive()
        }))
        
        self.alertVC.show(into: UIApplication.shared.keyWindow! )
    }
    
    /// Shows a CRNotification toast from top for given time
    static func showNotification(type: CRNotificationType, title: String, message: String, dismissDelay: Int) {
        let view = CRNotification()
        var color = UIColor.black
        var image = UIImage(named: "success")
        
        switch type {
        case .success:
            color = UIColor.green
            image = UIImage(named: "success")
            break
        case .error:
            color = UIColor.red
            image = UIImage(named: "error")
            break
        case .info:
            color = UIColor.gray
            image = UIImage(named: "info")
            break
        }
        
        view.backgroundColor = color
        view.setImage(image: image!)
        view.setTitle(title: title)
        view.setMessage(message: message)
        view.setDismisTimer(delay: dismissDelay)
        
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(view)
    }

}
