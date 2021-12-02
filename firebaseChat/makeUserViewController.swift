//
//  makeUserViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/18.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class makeUserViewController: UIViewController {

    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedProfileButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedSignUpButton(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil{
            createUser(emailText: emailTextField.text!, passwordText: passwordTextField.text!)
        }
    }
    
    
    @IBAction func toLoginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    func createUser(emailText: String, passwordText: String){
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { FIRAuthDataResult, Error in
            //nilチェック
            guard let authResult = FIRAuthDataResult else {
                print("error: SignUp")
                return
            }
            
            let addData = [
                "userName": self.userNameTextField.text!
            ]
            
            let db = Firebase.Firestore.firestore()
            db.collection("users")
                .document(authResult.user.uid)
                .setData(addData)
        }
        
    }
}

extension makeUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //サイズなどを変えた際に受け取るイメージ
        if let image = info[.editedImage] as? UIImage{
            userProfileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            //大きさが何も変わっていない
        }else if let originalImage = info[.originalImage] as? UIImage{
            userProfileButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        userProfileButton.setTitle("", for: .normal)
        userProfileButton.imageView?.contentMode = .scaleAspectFill
        userProfileButton.contentHorizontalAlignment = .fill
        userProfileButton.contentVerticalAlignment = .fill
        userProfileButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
