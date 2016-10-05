//
//  ViewController.swift
//  inC
//
//  Created by Russell DuBrock on 10/2/16.
//  Copyright © 2016 Russell DuBrock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    let sampler = Sampler()

    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playButtonPressed(sender: UIButton) {
        sampler.play()
        print("Button pressed!")
    }

}

