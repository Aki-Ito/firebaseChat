//
//  chatViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/18.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI
import FirebaseAuth

class chatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firebase.Firestore.firestore()
    let user = Auth.auth().currentUser
    var sentGroupId: String = ""
    //    var messages: [String] = []
    var addresses: [[String : Any]] = []
    
    
    lazy var chatInputAccessoryView: messageInputAccesoryView = {
        let view = messageInputAccesoryView()
        view.delegate = self
        view.frame = .init(x: 0, y: 0, width: view.frame.width , height: 100)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("sentGroupId: \(sentGroupId)")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "chatTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor(red: 206/255, green: 236/255, blue: 227/255, alpha: 1)
        //        tableView.backgroundColor = UIColor(named: "Darkcolor")
        tableView.separatorStyle = .none
        
        //tabBarが邪魔なので非表示にする
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        
        db.collection("groups")
            .document(sentGroupId)
            .collection("messages")
            .order(by: "time", descending: true)
            .addSnapshotListener{ (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    return
                }
                
                
                snapshot.documentChanges.forEach{ diff in
                    if (diff.type == .added){
                        let message = diff.document.data()["chatContent"] as! String
                        let userUid = diff.document.data()["userUid"] as! String
                        let timeStamp = diff.document.data()["time"] as! Timestamp
                        
                        let date: Date = timeStamp.dateValue()
                        
                        
                        self.addresses.append(["chatContent": message,
                                               "userUid": userUid,
                                               "date": date])
                    }
                }
                //                self.addresses.removeAll()
                //                for doc in snapshot.documents{
                //                    let message = doc.data()["chatContent"] as! String
                //                    let userUid = doc.data()["userUid"] as! String
                //                    let timeStamp = doc.data()["time"] as! Timestamp
                //
                //                    let date: Date = timeStamp.dateValue()
                //
                //
                //                    self.addresses.append(["chatContent": message,
                //                                           "userUid": userUid,
                //                                           "date": date])
                //
                //                    print("doc: \(doc.data()["chatContent"] as! String)")
                //                }
                
                print(self.addresses)
                self.tableView.reloadData()
            }
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //    func recognizeUser(indexPath: IndexPath){
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! chatTableViewCell
    //
    //        guard let user = user else { return }
    //        let uid: String =  addresses[indexPath.row]["userUid"] as! String
    //        if uid == user.uid{
    //
    //        }
    //    }
    
    
}

extension chatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! chatTableViewCell
        
        
        let text = addresses[indexPath.row]["chatContent"] as! String
        let chatUid: String = addresses[indexPath.row]["userUid"] as! String
        let myUid: String = user!.uid
        if chatUid == myUid{
            cell.myMessageText = text
        } else {
            cell.classmateMessageText = text
        }
        print("chatUid: \(chatUid)")
        print("uid: \(myUid)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //tableViewセルの高さの最低値
        tableView.estimatedRowHeight = 24
        //textViewの文字列の長さによって高さを自動調節する
        return UITableView.automaticDimension
    }
}

extension chatViewController: messageInputAccesoryViewDelegate{
    func tappedButton(text: String) {
        
        guard let user = Auth.auth().currentUser else {return}
        
        let addData: [String: Any] = ["chatContent": text,
                                      "userUid": user.uid,
                                      "time": Timestamp(date: Date())]
        
        db.collection("groups")
            .document(sentGroupId)
            .collection("messages")
            .addDocument(data: addData)
        
        chatInputAccessoryView.removeText()
    }
}
