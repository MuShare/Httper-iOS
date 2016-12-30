//
//  DetailIPInformationTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 30/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
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
        cityLabel.text = ipInfo["city"]! as? String
        regionLabel.text = ipInfo["region"]! as? String
        coutryLabel.text = ipInfo["country"]! as? String
        postCodeLabel.text = ipInfo["postal"]! as? String
        timeZoneLabel.text = ipInfo["timezone"]! as? String
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
