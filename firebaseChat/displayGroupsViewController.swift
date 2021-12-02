//
//  displayGroupsViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/13.
//

import UIKit
import Firebase
import FirebaseFirestore

class displayGroupsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let db = Firebase.Firestore.firestore()
    var groupId: String = ""
    var groupIdCollection: [String] = [""]
    var addresses: [[String : String]] = []
    
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
                    self.addresses.append(["roomName": roomName])
                    self.groupIdCollection.append(doc.documentID)
                    self.collectionView.reloadData()
                }
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
        cell.groupLabel.text = addresses[indexPath.row]["roomName"]
        
        groupId = groupIdCollection[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space: CGFloat = 36
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toChat", sender: nil)
    }
    
    
    
}
