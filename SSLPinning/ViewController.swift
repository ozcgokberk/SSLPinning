//
//  ViewController.swift
//  SSLPinning
//
//  Created by Gokberk Ozcan on 15.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doApiCallUsingSSLPinning()
    }
    private func doApiCallUsingSSLPinning(){
        guard let requestURL = URL(string: "secretUrl")else {return}
        var request = URLRequest(url: requestURL)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        ServiceManager.shared.callAPI(withUrl: request){(str) in
            
            print(str)
         
        }
    }

}


