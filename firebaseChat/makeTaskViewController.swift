//
//  makeTaskViewController.swift
//  firebaseChat
//
//  Created by 伊藤明孝 on 2022/01/29.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

@available(iOS 13.4, *)
class makeTaskViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let userDefaults = UserDefaults.standard
    
    var timeArray = [String]()
    var rgbRed: CGFloat = 0.0
    var rgbBlue: CGFloat = 0.0
    var rgbGreen: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.timeZone = TimeZone(identifier: "Asia/Tokyo")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        
        uiImage()
        
        if userDefaults.object(forKey: "time") != nil{
            timeArray = userDefaults.object(forKey: "time") as! [String]
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func tappedColor(_ sender: Any) {
        showColorPicker()
    }
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        updateFirestore()
    }
    
    func updateFirestore(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let time = formatter.string(from: datePicker.date)
        timeArray.append(time)
        let orderedSet: NSOrderedSet = NSOrderedSet(array: timeArray)
        timeArray = orderedSet.array as! [String]
        
        userDefaults.set(timeArray, forKey: "time")
        
        guard let user = user else {return}
        
        let addData: [String: Any] = [
            "time": Timestamp(date: datePicker.date),
            "content": textView.text!,
            "red": rgbRed,
            "blue": rgbBlue,
            "green": rgbGreen,
            "alpha": alpha
        ]
        
        db.collection("users")
            .document(user.uid)
            .collection(time)
            .addDocument(data: addData)
    }
    
    func showColorPicker() {
        if #available(iOS 14.0, *) {
            let colorPicker = UIColorPickerViewController()
            
            colorPicker.selectedColor = UIColor.black
            colorPicker.delegate = self
            self.present(colorPicker, animated: true, completion: nil)
            
        } else {
            // Fallback on earlier versions
            return
        }
    }
    
    func uiImage() {
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 2, height: 3)
        textView.layer.masksToBounds = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

@available(iOS 13.4, *)
extension makeTaskViewController: UIColorPickerViewControllerDelegate{
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        print("選択した色:\(String(describing: viewController.selectedColor.redColor))")
    }
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        
        rgbRed = viewController.selectedColor.redColor!
        rgbBlue = viewController.selectedColor.blueColor!
        rgbGreen = viewController.selectedColor.greenColor!
        alpha = viewController.selectedColor.alpha
        
        print("finish picking")
    }
    
}

extension UIColor {
    var redColor: CGFloat? {
        return self.cgColor.components?[0]
    }

    var greenColor: CGFloat? {
        return self.cgColor.components?[1]
    }

    var blueColor: CGFloat? {
        return self.cgColor.components?[2]
    }

    var alpha: CGFloat {
        return self.cgColor.alpha
    }
}
