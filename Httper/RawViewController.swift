//
//  RowViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 09/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import M80AttributedLabel

enum PrettyColor: Int {
    case normal = 0xEEEEEE
    case key = 0xFF9999
    case value = 0x33CCFF
}

let symbols = ["{", "}", "[", "]", ":", ","]


class RawViewController: UIViewController {

    var text: String!
    
    var width: CGFloat!, height: CGFloat!
    var rowScrollView: UITextView!
    
    init?(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        width = self.view.frame.size.width
        height = self.view.frame.size.height

        rowScrollView = {
            let view = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            view.backgroundColor = UIColor.clear
            return view
        }()

        //Set row text view
        let rowLabel: M80AttributedLabel = {
            let label = M80AttributedLabel()
            label.text = text
            label.backgroundColor = UIColor.clear
            label.font = UIFont(name: "Menlo", size: 12)
            label.textColor = RGB(PrettyColor.normal.rawValue)
            return label
        }()
        let rowSize = rowLabel.sizeThatFits(CGSize(width: self.width - 10, height: CGFloat.greatestFiniteMagnitude))
        rowLabel.frame = CGRect.init(x: 5, y: 5, width: rowSize.width, height: rowSize.height)
        self.rowScrollView.contentSize = CGSize.init(width: self.width, height: rowSize.height + 70)
        self.rowScrollView.addSubview(rowLabel)
        
        self.view.addSubview(rowScrollView)
    }
}
