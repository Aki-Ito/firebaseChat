//
//  myTaskViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/01/29.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class myTaskViewController: UIViewController {
    
    @IBOutlet weak var OuterCollectionView: UICollectionView!

    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var timeArray = [String]()
    var addresses: [[String : Any]] = []
    let userDefaults = UserDefaults.standard
    
    var viewWidth: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewWidth = view.frame.width
        OuterCollectionView.delegate = self
        OuterCollectionView.dataSource = self
        
        OuterCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCell")
        
        guard let user = user else {return}
        
        db.collection("users")
            .document(user.uid)
            .collection("tasks")
            .order(by: "time", descending: false)
            .addSnapshotListener{QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {return}
                
                self.addresses.removeAll()
                for doc in querySnapshot.documents{
                    
                    let timeStamp = doc.data()["time"] as! Timestamp
                    let date = doc.data()["date"] as! String
                    let content = doc.data()["content"] as! String
                    let rgbRed = doc.data()["red"] as! CGFloat
                    let rgbBlue = doc.data()["blue"] as! CGFloat
                    let rgbGreen = doc.data()["green"] as! CGFloat
                    let alpha = doc.data()["alpha"] as! CGFloat
                    
                    let time: Date = timeStamp.dateValue()
                    
                    self.timeArray.append(date)
                    let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
                    self.timeArray = orderedSet.array as! [String]
                  
                    self.addresses.append(
                        ["date": date,
                         "time": time,
                         "content": content,
                         "red": rgbRed,
                         "blue": rgbBlue,
                         "green": rgbGreen,
                         "alpha": alpha]
                    )
                }
                
            }
        
        
        
        self.OuterCollectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if userDefaults.object(forKey: "time") != nil{
//            timeArray = userDefaults.object(forKey: "time") as! [String]
//            print(timeArray)
//        }
        
        self.OuterCollectionView.reloadData()
        
        
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

extension myTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = OuterCollectionView.dequeueReusableCell(withReuseIdentifier: "OuterCell", for: indexPath) as! OuterCollectionViewCell
        
        cell.layer.cornerRadius = 12 //角丸
        cell.layer.shadowOpacity = 0.25 //影の濃さ
        cell.layer.shadowColor = UIColor.black.cgColor //影の色
        cell.layer.shadowOffset = CGSize(width: 2, height: 3) //影の方向
        cell.layer.masksToBounds = false
        
        cell.dateLabel.text = timeArray[indexPath.row]
        cell.configureCell(contentArray: addresses, date: timeArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space: CGFloat = 36
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
