//
//  messageInputAccesoryView.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2021/11/25.
//

import Foundation
import UIKit

protocol messageInputAccesoryViewDelegate: AnyObject {
    func tappedButton(text: String)
}


class messageInputAccesoryView: UIView{
    
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    weak var delegate: messageInputAccesoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instantiateNib()
        updateUI()
    }
    
    func instantiateNib(){
        let nib = UINib(nibName: "inputAccesoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    func updateUI(){
        messageTextView.layer.cornerRadius = 15
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.isScrollEnabled = false
        messageTextView.delegate = self
        
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.imageView?.contentMode = .scaleAspectFill
        sendMessageButton.contentVerticalAlignment = .fill
        sendMessageButton.contentHorizontalAlignment = .fill
        sendMessageButton.isEnabled = false
        sendMessageButton.setTitle("", for: .normal)
        
        autoresizingMask = .flexibleHeight
    }
    
    func removeText(){
        messageTextView.text = ""
        sendMessageButton.isEnabled = false
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tappedSendMessageButton(_ sender: Any) {
        guard let text = messageTextView.text else { return }
        
        delegate?.tappedButton(text: text)
        
    }
    
    
}

extension messageInputAccesoryView: UITextViewDelegate{
    //textViewの内容が変更された時に発動
    func textViewDidChange(_ textView: UITextView) {
        //空だったらボタンが使えないようにする
        if textView.text.isEmpty == true{
            sendMessageButton.isEnabled = false
        } else {
            sendMessageButton.isEnabled = true
        }
    }
}
