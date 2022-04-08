//
//  OuterCollectionViewCell.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/01/29.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol OuterCollectionViewCellDelegate: AnyObject{
    func tappedCell(date: String)
}

class OuterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var InnerCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var taskArray: [[String : Any]] = []
    var date: String = ""
    weak var delegate : OuterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 横スクロール
        InnerCollectionView.collectionViewLayout = layout
        InnerCollectionView.delegate = self
        InnerCollectionView.dataSource = self
        InnerCollectionView.layer.cornerRadius = 12.0
//        InnerCollectionView.layer.masksToBounds = false
//        InnerCollectionView.isUserInteractionEnabled = false
//        InnerCollectionView.isScrollEnabled = true
        InnerCollectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
        
    }
    
    func configureCell(contentArray: [[String : Any]], date: String){
        
        taskArray.removeAll()
        self.date = date
        for content in contentArray{
            let contentDate = content["date"] as! String
            if contentDate == date{
                taskArray.append(content)
                print(taskArray)
            }
        }
        self.InnerCollectionView.reloadData()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches{
            if touch.view?.tag == 1{
                delegate?.tappedCell(date: self.date)
            }
        }
    }
    
    
}

extension OuterCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = InnerCollectionView.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! InnerCollectionViewCell
        
        let rgbRed = taskArray[indexPath.row]["red"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["blue"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["green"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.contentLabel.text = taskArray[indexPath.row]["content"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 12, bottom: 8, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
        delegate?.tappedCell(date: self.date)
    }
    
}
