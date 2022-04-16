//
//  myTaskViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/01/29.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class myTaskViewController: UIViewController {
    
    @IBOutlet weak var OuterCollectionView: UICollectionView!
    @IBOutlet weak var button: UIButton!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var timeArray = [String]()
    var todoArray: [[String : Any]] = []
    var completeArray: [[String : Any]] = []
    var addresses: [[String: Any]] = []
    var date = String()
    
    var viewWidth: CGFloat = 0.0
    
    var isComplete: Bool = true
    
    var startingFrame : CGRect!
    var endingFrame : CGRect!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) && self.button.isHidden {
            self.button.isHidden = false
            self.button.frame = startingFrame
            UIView.animate(withDuration: 1.0) {
                self.button.frame = self.endingFrame
            }
        }
    }
    func configureSizes() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        startingFrame = CGRect(x: 0, y: screenHeight+100, width: screenWidth, height: 100)
        endingFrame = CGRect(x: 0, y: screenHeight-100, width: screenWidth, height: 100)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 32
        button.layer.shadowOpacity = 0.25 //影の濃さ
        button.layer.shadowColor = UIColor.black.cgColor //影の色
        button.layer.shadowOffset = CGSize(width: 2, height: 3) //影の方向
        button.layer.masksToBounds = false
        print("---画面B:\(#function)")
        self.OuterCollectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
        
        print("---画面B:\(#function)")
        // Do any additional setup after loading the view.
        viewWidth = view.frame.width
        OuterCollectionView.delegate = self
        OuterCollectionView.dataSource = self
        
        OuterCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCell")
        OuterCollectionView.allowsSelection = true
        OuterCollectionView.isUserInteractionEnabled = true
        
        guard let user = user else {return}
        
        db.collection("users")
            .document(user.uid)
            .collection("tasks")
            .order(by: "time", descending: false)
            .addSnapshotListener{QuerySnapshot, Error in
                guard let querySnapshot = QuerySnapshot else {return}
                
                self.todoArray.removeAll()
                self.addresses.removeAll()
                self.completeArray.removeAll()
                
                
                for doc in querySnapshot.documents{
                    let timeStamp = doc.data()["time"] as! Timestamp
                    let date = doc.data()["date"] as! String
                    let content = doc.data()["content"] as! String
                    let rgbRed = doc.data()["red"] as! CGFloat
                    let rgbBlue = doc.data()["blue"] as! CGFloat
                    let rgbGreen = doc.data()["green"] as! CGFloat
                    let alpha = doc.data()["alpha"] as! CGFloat
                    let isComplete = doc.data()["isComplete"] as! Bool
                    
                    let time: Date = timeStamp.dateValue()
                    
                    
                    
                    self.addresses.append(
                        ["date": date,
                         "time": time,
                         "content": content,
                         "red": rgbRed,
                         "blue": rgbBlue,
                         "green": rgbGreen,
                         "alpha": alpha,
                         "documentID": doc.documentID,
                         "isComplete": isComplete]
                    )
                    
                    switch isComplete{
                    case true:
                        self.completeArray.append(
                            ["date": date,
                             "time": time,
                             "content": content,
                             "red": rgbRed,
                             "blue": rgbBlue,
                             "green": rgbGreen,
                             "alpha": alpha,
                             "documentID": doc.documentID,
                             "isComplete": isComplete]
                        )
                        
                        self.configureTimeArray()
                        
                    case false:
                        self.todoArray.append(
                            ["date": date,
                             "time": time,
                             "content": content,
                             "red": rgbRed,
                             "blue": rgbBlue,
                             "green": rgbGreen,
                             "alpha": alpha,
                             "documentID": doc.documentID,
                             "isComplete": isComplete]
                        )
                       
                        self.configureTimeArray()
                        
                    }
                    
                }
                
                self.OuterCollectionView.reloadData()
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("---画面B:\(#function)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("---画面B:\(#function)")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("---画面B:\(#function)")
    }
    
    func configureTimeArray(){
        timeArray.removeAll()
        switch isComplete{
        case true:
            for content in completeArray{
                let contentTime = content["date"] as! String
                timeArray.append(contentTime)
                let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
                self.timeArray = orderedSet.array as! [String]
            }
        case false:
            for content in todoArray{
                let contentTime = content["date"] as! String
                timeArray.append(contentTime)
                let orderedSet: NSOrderedSet = NSOrderedSet(array: self.timeArray)
                self.timeArray = orderedSet.array as! [String]
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDailyTasks"{
            let vc = segue.destination as! DailyTasksViewController
            vc.addresses = self.addresses
//            vc.completeArray = self.completeArray
//            vc.taskArray = self.todoArray
            vc.date = self.date
            vc.isComplete = self.isComplete
        }
    }
    
    
    @IBAction func tappedAddButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toMakeTask", sender: nil)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toMenu", sender: nil)
    }
    
    
}

extension myTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("---画面B cellForItemAt:\(#function)")
        
        let cell = OuterCollectionView.dequeueReusableCell(withReuseIdentifier: "OuterCell", for: indexPath) as! OuterCollectionViewCell
        cell.delegate = self
        cell.layer.cornerRadius = 12 //角丸
        cell.layer.shadowOpacity = 0.25 //影の濃さ
        cell.layer.shadowColor = UIColor.black.cgColor //影の色
        cell.layer.shadowOffset = CGSize(width: 2, height: 3) //影の方向
        cell.layer.masksToBounds = false
        
        cell.dateLabel.text = timeArray[indexPath.row]
        switch isComplete{
        case true:
            cell.configureCell(contentArray: completeArray, date: timeArray[indexPath.row])
            self.OuterCollectionView.reloadData()
        case false:
            cell.configureCell(contentArray: todoArray, date: timeArray[indexPath.row])
            self.OuterCollectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("---画面B:\(#function)")
        return timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("---画面B:\(#function)")
        let space: CGFloat = 36
        let cellWidth: CGFloat = viewWidth - space
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
        date = timeArray[indexPath.row]
        self.performSegue(withIdentifier: "toDailyTasks", sender: nil)
    }
}

extension myTaskViewController: OuterCollectionViewCellDelegate{
    func tappedCell(date: String) {
        self.date = date
        print("date: \(self.date)")
        self.performSegue(withIdentifier: "toDailyTasks", sender: nil)
    }
}
