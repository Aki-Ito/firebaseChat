//
//  approveUserViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/18.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI

class approveUserViewController: UIViewController {

    let storageRef = Storage.storage().reference(forURL: "gs://fir-chat-f0685.appspot.com")
    
    let auth = Auth.auth()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        signInUser(emailText: userNameTextField.text!, passwordText: passwordTextField.text!)
    }
    
    func signInUser(emailText: String, passwordText: String){
        auth.signIn(withEmail: emailText, password: passwordText) { AuthDataResult, Error in
            if let err = Error{
                print("error:\(err) ")
            }
            
            self.transition()
        }
    }
    
    func transition(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabView = storyboard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
        tabView.selectedIndex = 0
        tabView.modalPresentationStyle = .fullScreen
        self.present(tabView, animated: true, completion: nil)
    }
    
//    let user = Auth.auth().currentUser
    
//    guard let user = user else {
//        return
//    }
//
//    print(user.uid)
//
//    let reference = self.storageRef.child("userProfile").child("\(user.uid).jpg")
//
//    imageView.sd_setImage(with: reference)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
