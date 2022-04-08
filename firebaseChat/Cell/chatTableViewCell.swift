//
//  chatTableViewCell.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/24.
//

import UIKit

class chatTableViewCell: UITableViewCell {
    
    var classmateMessageText: String?{
        didSet{
            guard let message = classmateMessageText else {return}
            myTextView.isHidden = true
            classmateTextView.isHidden = false
            classmateImageView.isHidden = false
            let width = estimateTextViewSize(text: message).width + 20
            classmateTextViewConstraint.constant = width
            classmateTextView.text = message
        }
    }
    
    var myMessageText: String?{
        didSet{
            guard let message = myMessageText else {return}
            myTextView.isHidden = false
            classmateTextView.isHidden = true
            classmateTextView.isHidden = true
            let width = estimateTextViewSize(text: message).width + 20
            myTextViewConstraint.constant = width
            myTextView.text = message
        }
    }
    
    
    @IBOutlet weak var classmateImageView: UIImageView!
    
    @IBOutlet weak var classmateTextView: UITextView!
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var myTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var classmateTextViewConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        myTextView.isHidden = true
        // Initialization code
        updateUI()
    }
    
    func updateUI(){
        classmateImageView.layer.cornerRadius = 30
        classmateImageView.layer.masksToBounds = true
        classmateTextView.layer.cornerRadius = 16
        //textViewのtextの長さに応じてセルの高さが決まるように設定したい。
        classmateTextView.isScrollEnabled = false
        classmateTextView.isEditable = false
        classmateTextView.isSelectable = false
        
        myTextView.layer.cornerRadius = 16
        myTextView.isScrollEnabled = false
        myTextView.isEditable = false
        myTextView.isSelectable = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func estimateTextViewSize(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 500)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
}
