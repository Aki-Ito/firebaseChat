//
//  GroupTaskView.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/03/11.
//

import UIKit

class GroupTaskView: UIView {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            loadNib()
        }
    
    func loadNib() {
            if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
                view.frame = self.bounds
                self.addSubview(view)
            }
        }
    
    @IBAction func deleteTask(_ sender: Any) {
    }
    
}
