//
//  Alert.swift
//  School Bus Track-2
//
//  Created by ios thinkers on 5/2/19.
//  Copyright © 2019 Islam Gaber. All rights reserved.
//

import Foundation
import UIKit
//import EMAlertController
//import Lottie

extension UIViewController {
    
    func alert(title: String, message: String, img: String?, confirm:String, cancel:String?) {
//        let alert = EMAlertController(title: title, message: message)
//        let confirm = EMAlertAction(title: confirm, style: .cancel)
//        
//        alert.cornerRadius = 40
//        alert.iconImage = UIImage(named: img!)
//        alert.addAction(confirm)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))

        self.present(alert, animated: true, completion: nil)
    }
//    
//    func alertCallBack(title: String, message: String, img: String?, confirm:String, cancel:String?, completion: @escaping (_ okPressed:String?) -> ()) {
//        
//        let alert = EMAlertController(title: title, message: message)
//        
//        let okPressed = EMAlertAction(title: confirm, style: .normal) {
//            completion("OK Pressed")
//        }
//        if cancel != nil {
//            let cancelPressed = EMAlertAction(title: cancel!, style: .cancel)
//            alert.addAction(cancelPressed)
//
//        }
//        alert.cornerRadius = 22
//        alert.iconImage = UIImage(named: img!)
//        alert.addAction(okPressed)
//        self.present(alert, animated: true, completion: nil)
//    }
    
//    func alertCallBackOneBtn(title: String, message: String, img: String?, confirm:String, completion: @escaping (_ okPressed:String?) -> ()) {
//        
//        let alert = EMAlertController(title: title, message: message)
//        
//        let okPressed = EMAlertAction(title: confirm, style: .normal) {
//            completion("OK Pressed")
//        }
//
//        alert.cornerRadius = 15.0
//        alert.iconImage = UIImage(named: img!)
//        alert.addAction(okPressed)
//        self.present(alert, animated: true, completion: nil)
//    }
    
//    func alert2(title: String, message: String, img: String?, confirm:String, cancel:String? ) -> Bool {
//        let alert = EMAlertController(title: title, message: message)
//        let confirm = EMAlertAction(title: confirm, style: .cancel) {
//            print("Za3bolla")
//            return false
//        }
//
//        alert.cornerRadius = 15.0
//        alert.iconImage = UIImage(named: img!)
//        alert.addAction(confirm)
//        self.present(alert, animated: true, completion: nil)
//        return false
//    }
    
    func networkFailureResponse(error: CustomError) {
        print("Error Status Code: ", error.statusCode)
        var alertTitle = ""
        var alertImg = ""
        
        switch error.statusCode {
        case 0:
            alertTitle = AlertServerErrorTitle
            alertImg = "serverError"
        case 1:
            alertTitle = AlertNetworkErrorTitle
            alertImg = "networkError"
        case 401:
            alertTitle = AlertExpireTitle
            alertImg = "serverError"

        default:
            alertTitle = AlertServerResponseTitle
            alertImg = "serverError"
        }
        self.alert(title: alertTitle, message: "\(error.somethingBadHappened)", img: alertImg, confirm: "OK", cancel: "")

    }

}

