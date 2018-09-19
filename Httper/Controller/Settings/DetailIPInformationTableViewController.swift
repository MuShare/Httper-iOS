//
//  DetailIPInformationTableViewController.swift
//  Httper
//
//  Created by Meng Li on 30/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import MapKit

class DetailIPInformationTableViewController: UITableViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var coutryLabel: UILabel!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    
    var ipInfo: Dictionary<String, Any>!

    override func viewDidLoad() {
        super.viewDidLoad()

        if ipInfo == nil {
            return
        }
        
        //Set detail IP information.
        self.title = ipInfo["ip"]! as? String
        
        let city = ipInfo["city"]! as? String
        let region = ipInfo["region"]! as? String
        let country = ipInfo["country"]! as? String
        let postCode = ipInfo["postal"]! as? String
        let timezone = ipInfo["timezone"]! as? String
        
        if city != "" && city != nil {
            cityLabel.text = city
        }
        if region != "" && region != nil {
            regionLabel.text = region
        }
        if country != "" && country != nil {
            coutryLabel.text = country
        }
        if postCode != "" && postCode != nil {
            postCodeLabel.text = postCode
        }
        if timezone != "" && timezone != nil {
            timeZoneLabel.text = timezone
        }
        
        latitudeLabel.text = "\(ipInfo["latitude"]!)"
        longitudeLabel.text = "\(ipInfo["longitude"]!)"
        
        //Set map
        let center = CLLocation(latitude: (ipInfo["latitude"]! as? Double)!, longitude: (ipInfo["longitude"]! as? Double)!)
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
