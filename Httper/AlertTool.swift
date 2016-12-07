//
//  AlertTool.swift
//  Httper
//
//  Created by 李大爷的电脑 on 07/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class AlertTool: NSObject {

    static func showAlert(title: NSString, content: NSString, controller: UIViewController) {
        let alertController = UIAlertController(title: title as String,
                                                message: content as String,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: NSLocalizedString("cancel_name", comment: ""), style: .cancel, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
}
