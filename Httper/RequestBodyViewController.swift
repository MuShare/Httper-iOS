//
//  RequestBodyViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 12/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

let bodyKeyboardCharacters = [":", "\"", ",", "{", "}", "[", "]"]

class RequestBodyViewController: UIViewController {

    var body: String!
    
    @IBOutlet weak var rawBodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rawBodyTextView.text = body
//        self.setKeyboardAccessoryForSender(sender: rawBodyTextView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        rawBodyTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bodyChanged"), object: rawBodyTextView.text)
    }

    // MARK: - Action
    @IBAction func cleatRequestBody(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("tip_name", comment: ""),
                                                message: NSLocalizedString("clear_request_body", comment: ""),
                                                preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel_name", comment: ""),
                                                style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("yes_name", comment: ""),
                                                style: .destructive) { action in
            self.rawBodyTextView.text = ""
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Service
//    func setKeyboardAccessoryForSender(sender: UITextView) {
//        let topView: UIToolbar = {
//            let view = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35))
//            view.barStyle = .black;
//            let spaceButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//            var items = [spaceButtonItem]
//            for character in bodyKeyboardCharacters {
//                items.append(createCharacterBarButtonItem(character: character,
//                                                          target: self,
//                                                          action: #selector(addCharacter(_:)),
//                                                          width: 26))
//            }
//
//            let tabButtonItem = createCharacterBarButtonItem(character: NSLocalizedString("tab_name", comment: ""),
//                                                             target: self,
//                                                             action: #selector(addTab),
//                                                             width: 40)
//
//            tabButtonItem.tintColor = UIColor.white
//            items.append(tabButtonItem)
//            items.append(spaceButtonItem)
//            
//            view.setItems(items, animated: false)
//            return view
//        }()
//        
//        sender.inputAccessoryView = topView
//    }
//    
//    func createCharacterBarButtonItem(character: String, target: UIViewController, action: Selector, width: CGFloat) -> UIBarButtonItem {
//        let characterButton: UIButton = {
//            let button = UIButton(frame: CGRect(x: 2, y: 2, width: width, height: 26))
//            button.layer.cornerRadius = 5
//            button.layer.borderWidth = 1
//            button.layer.borderColor = UIColor.white.cgColor
//            button.setTitle(character, for: .normal)
//            button.tintColor = UIColor.white
//            button.backgroundColor = RGB(DesignColor.nagivation.rawValue)
//            button.addTarget(target, action: action, for: .touchUpInside)
//            return button
//        }()
//        let characterButtonItem = UIBarButtonItem(customView: characterButton)
//        return characterButtonItem
//    }
//    
//    func addCharacter(_ sender: UIButton) {
//        if rawBodyTextView.isFirstResponder {
//            rawBodyTextView.text = rawBodyTextView.text! + (sender.titleLabel?.text)!
//        }
//    }

    func addTab() {
        if rawBodyTextView.isFirstResponder {
            rawBodyTextView.text = rawBodyTextView.text! + "  "
        }
    }
}
