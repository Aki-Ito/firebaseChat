//
//  ProfileViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/04/04.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userNameTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference(forURL: "gs://fir-chat-f0685.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        userNameTextView.isEditable = false
        emailTextView.isEditable = false
        profileImageButton.layer.masksToBounds = true
    }
    
    func fetchData(){
        guard let user = user else { return }
        db.collection("users")
            .document(user.uid)
            .getDocument { DocumentSnapshot, Error in
                guard let data = DocumentSnapshot?.data() else {
                    //                    print("error:\(Error)")
                    return
                }
                
                let userName = data["userName"] as! String
                self.userNameTextView.text = userName
            }
        
        emailTextView.text = user.email
        
        let reference = self.storageRef.child("userProfile").child("\(user.uid).jpg")
        
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            
            guard let data = data else {
                return
            }
            
            let image = UIImage(data: data)
            self.profileImageButton.setTitle("", for: .normal)
            self.profileImageButton.setImage(image, for: .normal)

        }
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
