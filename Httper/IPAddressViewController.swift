//
//  IPAddressViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 27/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit


class IPAddressViewController: UIViewController {

    var pingService: STDPingServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(InternetTool.deviceIPAdress())
        
        let routeInfo = InternetTool.getRouterInfo()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
