//
//  groupCollectionViewCell.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/13.
//

import UIKit

class groupCollectionViewCell: UICollectionViewCell {

    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        groupImageView.layer.cornerRadius = 50
        groupImageView.layer.borderWidth = 1
        groupImageView.layer.borderColor = UIColor.lightGray.cgColor
        groupImageView.layer.masksToBounds = true
    }

}
