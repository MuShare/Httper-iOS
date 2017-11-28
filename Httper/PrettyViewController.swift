//
//  PrettyViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 09/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import M80AttributedLabel
import Alamofire

let symbols = ["{", "}", "[", "]", ":", ","]

class PrettyViewController: UIViewController , UIGestureRecognizerDelegate {
    
    var text: String!
    var headers: [AnyHashable : Any]!
    
    let defaultFont = UIFont(name: "Menlo", size: 12)!
    let textView = UITextView()
    
    init?(text: String, headers: [AnyHashable : Any]) {
        self.text = text
        self.headers = headers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let contentType = headers["Content-Type"] as? String
        if contentType == nil {
            loadOriginal()
        } else if contentType!.contains("text/html") {
            loadOriginal()
        } else if contentType!.contains("application/json") {
            formatJSON()
        }

        self.textView.frame = CGRect(x: 0, y: 0, width: width, height: height - 110)
        self.textView.delegate = self
        self.textView.returnKeyType = .done
        self.textView.isEditable = true
        self.textView.backgroundColor =  RGB(DesignColor.background.rawValue)
        self.view.addSubview(self.textView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: Style.pretty.rawValue)
    }

    //MARK: - Service
    func loadOriginal() {
        let mutableAttribute = NSMutableAttributedString()
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: RGB(PrettyColor.normal.rawValue) , range: range)
        attributedText.addAttribute(NSFontAttributeName, value: self.defaultFont , range: range)
        mutableAttribute.append(attributedText)
        self.textView.attributedText = mutableAttribute
    }
    
    func formatJSON() {
        let mutableAttribute = NSMutableAttributedString()
        var space = String()
        var color = RGB(PrettyColor.normal.rawValue)
        var isText = false
        for char in text.characters {
            let text: String
            switch char {
            case "\"":
                isText = !isText
                text = "\(char)"
            case "{":
                color = RGB(PrettyColor.key.rawValue)
                fallthrough
            case "[":
                space.append("  ")
                text = "\(char)\n\(space)"
            case ",":
                text = "\(char)\n\(space)"
                color = RGB(PrettyColor.key.rawValue)
            case "}":
                fallthrough
            case "]":
                space = space.substring(to: space.index(space.endIndex, offsetBy: -2))
                text = "\n\(space)\(char)"
            case ":":
                color = RGB(PrettyColor.value.rawValue)
                text = "\(char) "
            case "\n":
                fallthrough
            case " ":
                text = isText ? " " : ""
            default:
                text = "\(char)"
            }
            
            let attributedText = NSMutableAttributedString(string: text)
            let range = (text as NSString).range(of: "\(char)")
            attributedText.addAttribute(NSForegroundColorAttributeName, value: symbols.contains("\(char)") ? RGB(PrettyColor.normal.rawValue) : color , range: range)
            attributedText.addAttribute(NSFontAttributeName, value: self.defaultFont , range: range)
            mutableAttribute.append(attributedText)
        }
        self.textView.attributedText = mutableAttribute
    }

}

extension PrettyViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.textView.endEditing(true)
    }
}
