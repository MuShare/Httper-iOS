//
//  ResultViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 07/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire
import M80AttributedLabel

enum PrettyColor: Int {
    case normal = 0xEEEEEE
    case key = 0xFF9999
    case value = 0x33CCFF
}

let symbols = ["{", "}", "[", "]", ":", ","]

class ResultViewController: UIViewController {
    
    var method: String!, url: String!
    var headers: HTTPHeaders!
    var parameters: Parameters!

    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(url, method: getHTTPMethod(method: method), parameters: parameters, encoding: URLEncoding.default, headers: headers).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            
            
            let label = M80AttributedLabel()
            var space = String()
            var color = RGB(PrettyColor.normal.rawValue)
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                for char in utf8Text.characters {
                    let text: String
                    switch char {
                    case "{":
                        color = RGB(PrettyColor.key.rawValue)
                        fallthrough
                    case "[":
                        space.append("  ")
                        text = "\(char)\n\(space)"
                    case ",":
                        text = "\(char)\n\(space)"
                        color = RGB(PrettyColor.key.rawValue)
                    case "}":
                        fallthrough
                    case "]":
                        space = space.substring(to: space.index(space.endIndex, offsetBy: -2))
                        text = "\n\(space)\(char)"
                    case "\n":
                        fallthrough
                    case " ":
                        text = ""
                    case ":":
                        color = RGB(PrettyColor.value.rawValue)
                        fallthrough
                    default:
                        text = "\(char)"
                    }
                    
                    let attributedText = NSMutableAttributedString(string: text)
                    attributedText.m80_setTextColor(symbols.contains("\(char)") ? RGB(PrettyColor.normal.rawValue) : color)
                    label.appendAttributedText(attributedText)
                    
                }
            }
            
            
            label.frame = self.view.bounds.insetBy(dx: 0, dy: 65)
            label.font = UIFont(name: "Menlo", size: 12)
            label.backgroundColor = UIColor.clear
            self.view.addSubview(label)
        }
    }
    
    //MARK: -Service
    func getHTTPMethod(method: String) -> HTTPMethod {
        switch method {
        case "GET":
            return HTTPMethod.get
        case "HEAD":
            return HTTPMethod.head
        case "POST":
            return HTTPMethod.post
        case "PUT":
            return HTTPMethod.put
        case "DELETE":
            return HTTPMethod.delete
        case "CONNECT":
            return HTTPMethod.connect
        case "OPTIONS":
            return HTTPMethod.options
        case "TRACE":
            return HTTPMethod.trace
        case "PATCH":
            return HTTPMethod.patch
        default:
            return HTTPMethod.get
        }
    }
    
}
