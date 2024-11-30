//
//  Store.swift
//  PasteMe
//
//  Created by cswenshuo on 2024/10/27.
//  Copyright © 2024 p0deje. All rights reserved.
//

import Foundation
import Purchases
import SwiftUI

class Store: ObservableObject {
    let productID = "PasteMe_Premium_Lifetime"
    let entitlementsID = "pro"
    @Published var recipe: Receipe?
    var offerings : Purchases.Offerings?
    static let shared = Store()
    let interval = 5
    var countdown = 5
    
    init() {
        fetchProduct()
    }
    
    func startUpFetchProduct(){
        Purchases.shared.offerings { (offerings, error) in
            self.offerings = offerings
            if let product = offerings?.current?.lifetime?.product {
                self.recipe = Receipe(product: product)
                Purchases.shared.purchaserInfo { [self] (purchaserInfo, error) in
                    if purchaserInfo?.entitlements.all[entitlementsID]?.isActive == true {
                        DispatchQueue.main.async{
                            self.recipe?.isLocked = false
                        }
                    }else{
                        DispatchQueue.main.async{
                            self.recipe?.isLocked = true
#if DEBUG
#else
                          RateSubscribeHelper.shared.check(reminderType: .subscribe)
#endif
                        }
                    }
                }
            }
        }
    }
        
    func fetchProduct(){
        Purchases.shared.offerings { (offerings, error) in
            self.offerings = offerings
            if let product = offerings?.current?.lifetime?.product {
                self.recipe = Receipe(product: product)
                self.checkProduct()
            }
        }
    }
    func fisrtSeen() -> Date{
        var s = Date()
        Purchases.shared.purchaserInfo { purchase, error in
            s = purchase?.firstSeen ?? Date()
        }
        return s
    }
    func purchaseProduct() {
        if let package = offerings?.current?.lifetime {
            Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                if purchaserInfo?.entitlements.all[self.entitlementsID]?.isActive == true {
                    DispatchQueue.main.async{
                        self.recipe?.isLocked = false
                    }
                }
            }
        }
    }
    
    func checkProduct(){
        Purchases.shared.purchaserInfo { [self] (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all[entitlementsID]?.isActive == true {
                DispatchQueue.main.async{
                    self.recipe?.isLocked = false
                }
            }else{
                DispatchQueue.main.async{
                    self.recipe?.isLocked = true
                }
            }
        }
    }
    func restoreProduct(_ restoreSuccessHandler: @escaping () -> (), restoreFailedHandler: @escaping () -> ()){
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all[self.entitlementsID]?.isActive == true {
                DispatchQueue.main.async{
                    self.recipe?.isLocked = false
                    restoreSuccessHandler()
                }
            }else{
                DispatchQueue.main.async{
                    self.recipe?.isLocked = true
                    restoreFailedHandler()
                }
            }
        }
    }
//    func checkSubscriptionReminder(){
//        print("checkSubscriptionReminder")
//        if let storedDate = UserDefaults.standard.object(forKey: "firstStartTime") as? Date {
//            if (Date().timeIntervalSince(storedDate) > 60*60*24) {
//                if countdown > 0 {
//                    countdown -= 1
//                } else{
//                    countdown = interval
//                    openPremiumWindow()
//                }
//            }
//        }
//
//    }
    

}
struct Receipe: Hashable {
    //MVVM
    let id: String
    let title: String
    let description: String
    var isLocked: Bool
    var price: String?
    let locale: Locale
    let imageName: String

    lazy var formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        return nf
    }()
    
    init(product: SKProduct, isLocked: Bool = true) {
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.description
        self.isLocked = isLocked
        self.locale = product.priceLocale
        self.imageName = product.productIdentifier
        
        if isLocked {
            self.price = formatter.string(from: product.price)
        }
    }
}
