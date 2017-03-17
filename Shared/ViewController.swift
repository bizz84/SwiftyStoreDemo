//
//  ViewController.swift
//  SwiftyStoreDemo
//
//  Created by Andrea Bizzotto on 17/03/2017.
//  Copyright © 2017 com.musevisions. All rights reserved.
//

import UIKit
import StoreKit

public extension SKProduct {
    
    public var localizedPrice: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = self.priceLocale
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: self.price)
    }
}


class ViewController: UIViewController {

    let productIdentifier = "com.musevisions.iOS.SwiftyStoreKit.purchase1"
    
    var iapRequest: InAppProductQueryRequest?
    
    @IBAction func productInfoTapped(_ sender: Any) {
        
        iapRequest = InAppProductQueryRequest.startQuery([ productIdentifier ]) { result in
            self.iapRequest = nil
            
            let alert = self.alertForProductRetrievalInfo(result)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
}

