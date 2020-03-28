//
//  IPAddressMapTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2019/06/28.
//  Copyright © 2019 limeng. All rights reserved.
//

import MapKit
import RxDataSourcesSingleSection
import UIKit

private struct Const {
    struct map {
        static let margin = 10
    }
}

class IPAddressMapTableViewCell: UITableViewCell {
    
    private lazy var mapView = MKMapView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(mapView)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        mapView.snp.makeConstraints {
            $0.height.equalTo(mapView.snp.width)
            $0.left.top.equalToSuperview().offset(Const.map.margin)
            $0.right.bottom.equalToSuperview().offset(-Const.map.margin)
        }
    }
}

extension IPAddressMapTableViewCell: Configurable {
    
    typealias Model = CLLocation
    
    func configure(_ center: CLLocation) {
        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center.coordinate
        mapView.addAnnotation(annotation)
    }
}
