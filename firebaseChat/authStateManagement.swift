//
//  authStateManagement.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/02/12.
//

import Foundation
import FirebaseAuth

final class authStateManagement{
    static let shared = authStateManagement()
    
    func manageStatus(completion: ((Bool) -> Void)? = nil){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil{
                completion?(false)
            }else{
                completion?(true)
            }
        }
    }
}

extension UIViewController{
    static func getRoot(isLogined: Bool) -> UIViewController?{
        if isLogined == false{
            let signUpVC = makeUserViewController()
            return signUpVC
        }else{
            return nil
        }
    }
}

extension UITabBarController{
    static func getRootTab(isLogined: Bool) -> UITabBarController?{
        if isLogined{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabView = storyboard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
            return tabView
        }else{
            return nil
        }
    }
}

final class router{
    static func showRoot(window: UIWindow){
        authStateManagement.shared.manageStatus { bool in
            print(bool)
            if bool == false
            {
                let rootVC = UIViewController.getRoot(isLogined: bool)
                window.rootViewController = rootVC
                window.makeKeyAndVisible()
            }else{
                let rootVC = UITabBarController.getRootTab(isLogined: bool)
                rootVC?.selectedIndex = 0
                window.rootViewController = rootVC!
                window.makeKeyAndVisible()
            }
            
            print(window.rootViewController)
        }
    }
}

