//
//  makeRoomViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/13.
//

import UIKit
import Firebase
import FirebaseFirestore

class makeRoomViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomNumberTextField: UITextField!
    
    let db = Firebase.Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileButton.layer.cornerRadius = 76
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    

    @IBAction func tappedProfileButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedAddButton(_ sender: Any) {
        let addData = [
            "roomName": roomNameTextField.text!,
            "roomNumber": roomNumberTextField.text!
        ]
        
        db.collection("groups")
            .addDocument(data: addData){ err in
                
                if let error = err{
                    print("保存に失敗しました：\(error)")
                }
                
            }
        
        self.dismiss(animated: true, completion: nil)
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

extension makeRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //サイズなどを変えた際に受け取るイメージ
        if let image = info[.editedImage] as? UIImage{
            profileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            //大きさが何も変わっていない
        }else if let originalImage = info[.originalImage] as? UIImage{
            profileButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileButton.setTitle("", for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.contentHorizontalAlignment = .fill
        profileButton.contentVerticalAlignment = .fill
        profileButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
