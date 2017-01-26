//
//  CommonTool.swift
//  Httper
//
//  Created by lidaye on 08/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

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

// MARK: - JSON String
func JSONStringWithObject(_ object: Any) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: object, options: .init(rawValue: 0))
        return String.init(data: jsonData, encoding: .utf8)
    } catch {
        print(error.localizedDescription)
        return nil
    }
}

//Transfer JSON string to dictionary
func serializeJSON(_ string: String) -> [String: Any]? {
    if let data = string.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

// MARK: - UI Tool
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

// MARK: - Validation
func isEmailAddress(_ testStr:String) -> Bool {
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}
