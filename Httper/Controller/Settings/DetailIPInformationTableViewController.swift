//
//  DetailIPInformationTableViewController.swift
//  Httper
//
//  Created by Meng Li on 30/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class DetailIPInformationTableViewController: UITableViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var coutryLabel: UILabel!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    
    var ipInfo: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()

        if ipInfo == nil {
            return
        }
        
        //Set detail IP information.
        self.title = ipInfo["ip"].stringValue
        
        cityLabel.text = ipInfo["city"].stringValue
        regionLabel.text = ipInfo["region"].stringValue
        coutryLabel.text = ipInfo["country"].stringValue
        postCodeLabel.text = ipInfo["postal"].stringValue
        timeZoneLabel.text = ipInfo["timezone"].stringValue
        latitudeLabel.text = ipInfo["latitude"].stringValue
        longitudeLabel.text = ipInfo["longitude"].stringValue
        
        //Set map
        let center = CLLocation(latitude: ipInfo["latitude"].doubleValue, longitude: ipInfo["longitude"].doubleValue)
        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        locationMapView.setRegion(currentRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center.coordinate
        locationMapView.addAnnotation(annotation)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}
