//
//  ToDoMenuViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/04/07.
//

import UIKit

class ToDoMenuViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
        
    @IBOutlet weak var tableView: UITableView!

    var isComplete: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let menuPos = self.menuView.layer.position
        self.menuView.layer.position.x = -self.menuView.frame.width
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options:.curveEaseOut,
                       animations: {self.menuView.layer.position.x = menuPos.x},
                       completion: {bool in})
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            if touch.view?.tag == 1{
                           UIView.animate(withDuration: 0.2,
                                          delay: 0,
                                          options: .curveEaseIn,
                                          animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                                          completion: {bool in self.dismiss(animated: true, completion: nil)})
                       }
        }
    }
    


}

extension ToDoMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        let menuArray: [String] = ["完了", "未完了"]
        cell.titleLabel.text = menuArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
        case 0: isComplete = true
        case 1: isComplete = false
        default:
          print("error")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let preNC = self.presentingViewController as! UINavigationController
                let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! myTaskViewController
        preVC.isComplete = self.isComplete
        preVC.configureTimeArray()
        print(preVC.isComplete)
                //記述することでNavigationControllerの一個前の画面に戻れる

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {self.menuView.layer.position.x = -self.menuView.frame.width},
                       completion: {bool in self.dismiss(animated: true, completion: nil)})
    }
}
