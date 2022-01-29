//
//  myTaskViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/01/29.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class myTaskViewController: UIViewController {
    
    @IBOutlet weak var OuterCollectionView: UICollectionView!

    var addresses = [String]()
    var timeArray = [String]()
    let userDefaults = UserDefaults.standard
    
    var viewWidth: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewWidth = view.frame.width
        OuterCollectionView.delegate = self
        OuterCollectionView.dataSource = self
        
        OuterCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefaults.object(forKey: "time") != nil{
            timeArray = userDefaults.object(forKey: "time") as! [String]
            print(timeArray)
        }
        
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
        cell.configureCell(collectionName: timeArray[indexPath.row])
        
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
