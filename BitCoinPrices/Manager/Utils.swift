//
//  Utils.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/9/21.
//

import UIKit

struct Utils {
    
    static func showAlert(title: String, message: String, viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)//localizedString: ok
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

}
