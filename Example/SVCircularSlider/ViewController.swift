//
//  ViewController.swift
//  SVCircularSlider
//
//  Created by stevalsecchi98 on 09/14/2020.
//  Copyright (c) 2020 stevalsecchi98. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let slider = SpeedSlider(frame: .init(x: 100, y: 100, width: 200, height: 200))
        self.view.addSubview(slider)
        
        slider.onProgressChanged = { progress in
            print("Progress changged: \(progress)")
        }
        
        slider.onToucEnd = {
            print("Slider onToucEnd")
        }
        
        slider.onTouchesBegan = {
            print("Slider onTouchesBegan")
        }
    }

}

