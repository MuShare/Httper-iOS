//
//  RowViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import M80AttributedLabel

class RawViewController: UIViewController {
    
    var text: String!

    init?(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.frame.size.width
        let height = self.view.frame.size.height

        //Set row text view
        let rowLabel: M80AttributedLabel = {
            let label = M80AttributedLabel()
            label.text = text
            label.backgroundColor = UIColor.clear
            label.font = UIFont(name: "Menlo", size: 12)
            label.textColor = UIColor(hex: PrettyColor.normal.rawValue)
            return label
        }()
        let rowSize = rowLabel.sizeThatFits(CGSize(width: width - 10, height: CGFloat.greatestFiniteMagnitude))
        rowLabel.frame = CGRect.init(x: 5, y: 5, width: rowSize.width, height: rowSize.height)
        
        let rowScrollView: UIScrollView = {
            let view = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: height - 50))
            view.backgroundColor = UIColor.clear
            view.contentSize = CGSize.init(width: width, height: rowSize.height + 70)
            view.addSubview(rowLabel)
            return view
        }()
        
        self.view.addSubview(rowScrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: Style.raw.rawValue)
    }
    
}
