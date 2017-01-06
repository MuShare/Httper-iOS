//
//  CommonTool.swift
//  Httper
//
//  Created by lidaye on 08/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

let baseUrl = "http://httper.fczm.pw/"

func RGB(_ value : Int) -> UIColor {
    let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((value & 0x00FF00) >> 8 ) / 255.0
    let b = CGFloat((value & 0x0000FF)      ) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

func ClassByName(name : String) ->  AnyClass? {
    
    var result : AnyClass? = nil
    if let bundle = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
        let className = bundle + "." + name
        result = NSClassFromString(className)
    }
    return result
}

func showAlert(title: String, content: String, controller: UIViewController) {
    let alertController = UIAlertController(title: title,
                                            message: content,
                                            preferredStyle: .alert)
    alertController.addAction(UIAlertAction.init(title: NSLocalizedString("ok_name", comment: ""), style: .cancel, handler: nil))
    controller.present(alertController, animated: true, completion: nil)
}

func replaceBarButtonItemWithActivityIndicator(controller: UIViewController) {
    let activityIndicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    activityIndicatorView.startAnimating()
    replaceBaeButtonItemWithView(controller: controller, view: activityIndicatorView)
}

func replaceBaeButtonItemWithView(controller: UIViewController, view: UIView) {
    let barButton = UIBarButtonItem(customView: view)
    controller.navigationItem.rightBarButtonItem = barButton
}

func createCharacterBarButtonItem(character: String, target: UIViewController, action: Selector, width: CGFloat) -> UIBarButtonItem {
    let characterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 2, y: 2, width: width, height: 26))
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle(character, for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = RGB(DesignColor.nagivation.rawValue)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }()
    let characterButtonItem = UIBarButtonItem(customView: characterButton)
    return characterButtonItem
}

func createUrl(_ relative: String) -> String {
    return baseUrl + relative
}
