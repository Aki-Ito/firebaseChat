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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")

        let menuPosition = self.menuView.layer.position
        print(menuPosition)
        self.menuView.layer.position.x = -self.menuView.layer.frame.width
        print(self.menuView.layer.position.x)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {self.menuView.layer.position.x = menuPosition.x},
                       completion: nil)
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
}
