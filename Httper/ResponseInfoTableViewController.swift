//
//  ResponseInfoTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 09/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire

class ResponseInfoTableViewController: UITableViewController {
    
    var response: HTTPURLResponse!
    var headerKeys = Array<String>(), headerValues = Array<String>()
    
    var selectedKey: String!, selectedValue: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        for (key, value) in response.allHeaderFields {
            headerKeys.append(key.description)
            headerValues.append(value as! String)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "responseHeaderSegue" {
            segue.destination.setValue(selectedKey, forKey: "headerKey")
            segue.destination.setValue(selectedValue, forKey: "headerValue")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return headerKeys.count
        case 0:
            fallthrough
        case 1:
            fallthrough
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
            view.backgroundColor = UIColor(red: 48.0 / 255, green: 54.0 / 255, blue: 59.0 / 255, alpha: 1.0)
            return view
        }()
        
        //Set name
        let nameLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.bounds.size.width - headerView.bounds.size.height, height: headerView.bounds.size.height))
            label.textColor = UIColor.white
            if section == 0 {
                label.text = NSLocalizedString("request_url", comment: "")
            } else if section == 1 {
                label.text = NSLocalizedString("status", comment: "")
            } else if section == 2 {
                label.text = NSLocalizedString("response_headers", comment: "")
            }
            return label
        }()
        
        //Set line
        let lineView: UIView = {
            let view = UILabel(frame: CGRect(x: 15, y: 28, width: headerView.bounds.size.width - 15, height: 1))
            view.backgroundColor = UIColor.lightGray
            return view
        }()
        
        headerView.addSubview(nameLabel)
        headerView.addSubview(lineView)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "urlIdentifier", for: indexPath)
            let scrollView: UIScrollView = cell.viewWithTag(1) as! UIScrollView
            let urlLabel: UILabel = {
                let label = UILabel()
                label.text = response.url?.description
                label.textColor = UIColor.lightGray
                label.font = UIFont(descriptor: UIFontDescriptor.init(), size: 15)
                return label
            }()
            let height = scrollView.frame.size.height
            let size = urlLabel.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height))
            urlLabel.frame = CGRect.init(x: 15, y: 0, width: size.width, height: height)
            scrollView.contentSize = CGSize.init(width: size.width + 20, height: height)
            scrollView.addSubview(urlLabel)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerIdentifier", for: indexPath)
            let keyLabel: UILabel = cell.viewWithTag(1) as! UILabel
            let valueLabel: UILabel = cell.viewWithTag(2) as! UILabel
            if indexPath.section == 1 {
                keyLabel.text = NSLocalizedString("status_code", comment: "")
                valueLabel.text = response.statusCode.description
            } else if indexPath.section == 2 {
                keyLabel.text = headerKeys[indexPath.row]
                valueLabel.text = headerValues[indexPath.row]
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            selectedKey = headerKeys[indexPath.row]
            selectedValue = headerValues[indexPath.row]
            self.performSegue(withIdentifier: "responseHeaderSegue", sender: self);
        }
    }

}
