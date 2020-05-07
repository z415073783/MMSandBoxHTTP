//
//  ViewController.swift
//  MMSanBoxHTTPDemo
//
//  Created by 曾亮敏 on 2020/5/6.
//  Copyright © 2020 曾亮敏. All rights reserved.
//

import UIKit
import MMSandBoxHTTP
//import MMLibrary
class ViewController: UIViewController {
    private var server: HttpServer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SanBoxServer.server()

        // Do any additional setup after loading the view.
    }


}

