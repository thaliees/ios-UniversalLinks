//
//  AppDelegate.swift
//  UniversalLinks
//
//  Created by Thaliees on 4/15/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return false }
        
        // 2
        if components.path == "/" {
            return true
        }
        else if components.path.contains("/product/") {
            let html = components.path.split(separator: ".")
            let query = html[0].split(separator: "/")
            presentDetailViewController(String(query[1]))
            return true
        }
        
        // 3
        if let webpageUrl = URL(string: "https://universalelinks.herokuapp.com") {
            application.open(webpageUrl)
            return false
        }
      
        return false
    }
    
    func presentDetailViewController(_ id: String) {
        guard let navigation = window?.rootViewController as? UINavigationController else { return }
        
        let detail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsStoryboard") as! DetailsViewController
        detail.idItem = id
        navigation.modalPresentationStyle = .fullScreen
        navigation.pushViewController(detail, animated: true)
    }
}

