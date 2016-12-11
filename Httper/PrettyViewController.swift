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

class PrettyViewController: UIViewController {
    
    var text: String!
    var headers: [AnyHashable : Any]!
    
    let prettyLabel = M80AttributedLabel()
    
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
        if contentType == nil  {
//            let attributedText = NSMutableAttributedString(string: text)
//            attributedText.m80_setTextColor(RGB(PrettyColor.normal.rawValue))
//            attributedText.m80_setFont(UIFont(name: "Menlo", size: 12)!)
//            self.prettyLabel.appendAttributedText(attributedText)
            
            formatHTML()
        } else if contentType!.contains("text/html") {
            formatHTML()
        } else if contentType!.contains("application/json") {
            formatJSON()
        }

        //Set pretty scroll view
        
        let prettySize = prettyLabel.sizeThatFits(CGSize.init(width: width - 10, height: CGFloat.greatestFiniteMagnitude))
        prettyLabel.frame = CGRect.init(x: 5, y: 5, width: prettySize.width, height: prettySize.height)
        prettyLabel.backgroundColor = UIColor.clear
        
        let prettyScrollView: UIScrollView = {
            let view = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            view.contentSize = CGSize.init(width: width, height: prettySize.height + 70)
            view.addSubview(prettyLabel)
            return view
        }()

        self.view.addSubview(prettyScrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: Style.pretty.rawValue)
    }
    
    //MARK: - Service
    func formatJSON() {
        var space = String()
        var color = RGB(PrettyColor.normal.rawValue)
        for char in text.characters {
            let text: String
            switch char {
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
                text = ""
            default:
                text = "\(char)"
            }
            
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.m80_setTextColor(symbols.contains("\(char)") ? RGB(PrettyColor.normal.rawValue) : color)
            attributedText.m80_setFont(UIFont(name: "Menlo", size: 12)!)
            self.prettyLabel.appendAttributedText(attributedText)
        }
    }
    
    func formatHTML() {

    }
}
