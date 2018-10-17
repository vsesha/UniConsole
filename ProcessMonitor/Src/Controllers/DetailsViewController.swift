//
//  DetailsViewController.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 10/1/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import UIKit


class DetailsViewController:UIViewController{

    struct dataFromPrev{
        var question:String
        var answer:String
        var additionalParams:String
    }
    override func viewDidLoad() {
        
    }


    @IBAction func closeButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
