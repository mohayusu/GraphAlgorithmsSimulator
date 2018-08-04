//
//  ViewController.swift
//  GraphAlgorithmsVisualizer
//
//  Created by Mohamed Mohamed (mohayusu) on 8/3/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    @IBOutlet weak var graphViewOutlet: Graph!
    
    @IBOutlet weak var linesView: UIView!
    
    @IBAction func graphTapped(_ sender: UITapGestureRecognizer) {
        var location = sender.location(in: view)
        let button = UIButton(frame: CGRect(x: location.x, y: location.y, width: 15, height: 15))
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .blue
        print(location)
        location.x = graphViewOutlet.bounds.width / 2
        location.y = graphViewOutlet.bounds.height / 2
        print(location)
        self.view.addSubview(button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .lightContent
        linesView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

