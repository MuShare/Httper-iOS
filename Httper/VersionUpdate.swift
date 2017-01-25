//
//  VersionUpdate.swift
//  Httper
//
//  Created by lidaye on 25/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation

func version_1_3() {
    let dao = DaoManager.sharedInstance
    for request in dao.requestDao.findAll() {
        print(request.url)
    }
}
