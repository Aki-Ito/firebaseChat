//
//  displayGroupsViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/13.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI
import FirebaseAuth

class displayGroupsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firebase.Firestore.firestore()
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference(forURL: "gs://fir-chat-f0685.appspot.com")
    var groupId: String = ""
    var addresses: [[String : Any]] = []
    
    var viewWidth: CGFloat! //viewの横幅
    var viewHeight: CGFloat! //viewの縦幅
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        viewWidth = view.frame.width
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "groupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        db.collection("groups")
            .addSnapshotListener{ (querySnapshot, err) in
                guard let snapshot = querySnapshot else{
                    print(err!)
                    return
                }
                
                self.addresses.removeAll()
                
                for doc in snapshot.documents{
                    
                    let roomName = doc.data()["roomName"] as! String
                    let roomNumber = doc.data()["roomNumber"] as! String
                    let registeredUser = doc.data()["registeredUser"] as! [String]
                    let docID = doc.documentID
                    self.addresses.append(["roomName": roomName,
                                           "roomNumber": roomNumber,
                                           "registeredUser": registeredUser,
                                           "docID": docID])
                    
                    self.collectionView.reloadData()
                }
            }
        print("addresses: \(addresses)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat"{
            let vc = segue.destination as! chatViewController
            vc.sentGroupId = self.groupId
            print("groupId: \(groupId)")
        }
    }
    
    func showAlert(indexPath: IndexPath){
        var idTextField = UITextField()
        let ac = UIAlertController(title: "IDを入力", message: "", preferredStyle: .alert)
        let aa = UIAlertAction(title: "ok", style: .default) { action in
            let selectedGroupId = self.addresses[indexPath.row]["roomNumber"] as? String
            if idTextField.text == selectedGroupId{
                self.groupId = self.addresses[indexPath.row]["docID"] as! String
                
                guard let user = self.user else {return}
                var addressedUser: [String] = self.addresses[indexPath.row]["registeredUser"] as! [String]
                addressedUser.append(user.uid)
                let addData: [String:Any] = ["registeredUser": addressedUser]
                self.db.collection("groups")
                    .document(self.groupId)
                    .setData(addData, merge: true)
                self.performSegue(withIdentifier: "toChat", sender: nil)
            }
        }
        
        ac.addTextField { textField in
            textField.keyboardType = UIKeyboardType.numberPad
            textField.placeholder = "idを入力"
            idTextField = textField
        }
        
        ac.addAction(aa)
        present(ac, animated: true, completion: nil)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "makeUser")
            nextVC?.modalPresentationStyle = .fullScreen
            self.present(nextVC!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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

extension displayGroupsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addresses.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! groupCollectionViewCell
        
        cell.layer.cornerRadius = 12 //角丸
        cell.layer.shadowOpacity = 0.25 //影の濃さ
        cell.layer.shadowColor = UIColor.black.cgColor //影の色
        cell.layer.shadowOffset = CGSize(width: 2, height: 3) //影の方向
        cell.layer.masksToBounds = false
        cell.groupLabel.text = addresses[indexPath.row]["roomName"] as? String
        
        let groupName: String = addresses[indexPath.row]["roomName"] as! String
        let reference = storageRef.child("groupProfile").child("\(groupName).jpg")
        cell.groupImageView.sd_setImage(with: reference)
        
        print("groupId: \(groupId)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space: CGFloat = 36
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let registeredUserArray: [String] = self.addresses[indexPath.row]["registeredUser"] as! [String]
        guard let user = self.user else {return}
        
        if registeredUserArray.contains(user.uid){
            self.groupId = self.addresses[indexPath.row]["docID"] as! String
            self.performSegue(withIdentifier: "toChat", sender: nil)
        } else {
            self.showAlert(indexPath: indexPath)
        }
        
    }
    
    
    
}
