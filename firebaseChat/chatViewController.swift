//
//  chatViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/18.
//

import UIKit

class chatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var messages: [String] = []
    
    
    lazy var chatInputAccessoryView: messageInputAccesoryView = {
        let view = messageInputAccesoryView()
        view.delegate = self
        view.frame = .init(x: 0, y: 0, width: view.frame.width , height: 100)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "chatTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        tableView.allowsSelection = false
//        tableView.backgroundColor = UIColor(red: 206/255, green: 236/255, blue: 227/255, alpha: 1)
        tableView.backgroundColor = UIColor(named: "Darkcolor")
        tableView.separatorStyle = .none
        
        //tabBarが邪魔なので非表示にする
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }


}

extension chatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! chatTableViewCell
        
        cell.messageText = messages[indexPath.row]
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
        messages.append(text)
        chatInputAccessoryView.removeText()
        tableView.reloadData()
    }
}
