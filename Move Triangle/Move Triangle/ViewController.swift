//
//  ViewController.swift
//  Move Triangle
//
//  Created by brian jones on 11/1/15.
//  Copyright © 2015 brian jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var renderer: MetalRenderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        renderer = MetalRenderer(vc: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        renderer.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        renderer.touchesMoved(touches, withEvent: event)
    }


}

