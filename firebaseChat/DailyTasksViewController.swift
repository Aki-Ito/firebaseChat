//
//  DailyTasksViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/02/12.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class DailyTasksViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var addresses: [[String : Any]] = []
    var date = String()
    var taskArray: [[String : Any]] = []
    var completeArray: [[String: Any]] = []
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCell")
        
        print("date: \(date)")
        print("taskArray: \(taskArray)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addComponent()
    }
    
    func addComponent(){
        taskArray.removeAll()
        for content in addresses{
            let contentDate = content["date"] as! String
            let isComplete = content["isComplete"] as! Bool
            if contentDate == date && isComplete == false{
                taskArray.append(content)
            }else if contentDate == date || isComplete == true{
                completeArray.append(content)
            }
        }
        collectionView.reloadData()
    }
    
    
}

extension DailyTasksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCell", for: indexPath) as! InnerCollectionViewCell
        let rgbRed = taskArray[indexPath.row]["red"] as! CGFloat
        let rgbBlue = taskArray[indexPath.row]["blue"] as! CGFloat
        let rgbGreen = taskArray[indexPath.row]["green"] as! CGFloat
        let alpha = taskArray[indexPath.row]["alpha"] as! CGFloat
        
        cell.backgroundColor = UIColor(red: rgbRed, green: rgbGreen, blue: rgbBlue, alpha: alpha)
        cell.contentLabel.text = taskArray[indexPath.row]["content"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        taskArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 12, bottom: 8, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            
            //タイトルとイメージを設定できる。
            
                let complete = UIAction(title: "Complete", image: nil, identifier: UIAction.Identifier(rawValue: "complete")) { _ in
                    // 押された際にアクションをする
                    let selectedDocID = self.taskArray[indexPath.row]["documentID"] as! String
                    self.taskArray[indexPath.row]["isComplete"] = true
                    guard let user = self.user else {return}
                    self.db.collection("users")
                        .document(user.uid)
                        .collection("tasks")
                        .document(selectedDocID)
                        .setData(self.taskArray[indexPath.row], merge: true)
                    
                    self.completeArray.append(self.taskArray[indexPath.row])
                    self.taskArray.remove(at: indexPath.row)
                
            }
            
            
            let delete = UIAction(title: "delete", image: UIImage(systemName: "trash"), identifier: UIAction.Identifier(rawValue: "delete")){ [self] _ in
                
                let selectedDocID = self.taskArray[indexPath.row]["documentID"] as! String
                guard let user = self.user else {return}
                self.db.collection("users")
                    .document(user.uid)
                    .collection("tasks")
                    .document(selectedDocID)
                    .delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                            self.taskArray.remove(at: indexPath.row)
                            self.collectionView.reloadData()
                            
                            if self.taskArray.isEmpty{
                                let preNC = self.navigationController!
                                let preVC = preNC.viewControllers[preNC.viewControllers.count - 2] as! myTaskViewController
                                
                                preVC.timeArray.removeAll(where: {$0 == self.date})
                            }
                        }
                    }
                
            }
            delete.attributes = [.destructive]
            
            return UIMenu(title: "menu", image: nil, identifier: nil, children: [complete, delete])
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil,
                                          actionProvider: actionProvider)
    }
}
