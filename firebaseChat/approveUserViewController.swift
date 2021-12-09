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
    
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = user else {
            return
        }
        
        print(user.uid)

        let reference = self.storageRef.child("userProfile").child("\(user.uid).jpg")
        
        imageView.sd_setImage(with: reference)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
