//
//  ViewController.swift
//  GraphAlgorithmsVisualizer
//
//  Created by Mohamed Mohamed (mohayusu) on 8/3/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var stepBackButton: UIBarButtonItem!
    @IBOutlet weak var stepForwardButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var linesView: UIView!
    var numPoints: Int = 0
    var lines: Line = Line()
    
    @IBAction func graphTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        
        let button = UIButton(frame: CGRect(x: location.x, y: location.y, width: 15, height: 15))
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .blue
        self.view.addSubview(button)
        
        numPoints += 1
        lines.addPoint(coordinate: location)
        
        if numPoints == 3 {
            revealToolbarButtons()
        }
        
        if numPoints == 10 {
            lines.printLines()
        }
    }
    
    func sideMenus() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 250
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func hideToolbarButtons() {
        stepBackButton.tintColor = navBar.barTintColor!
        stepBackButton.isEnabled = false
        
        stepForwardButton.tintColor = navBar.barTintColor!
        stepForwardButton.isEnabled = false
        
        statusLabel.textColor = .black
    }
    
    func revealToolbarButtons() {
        stepBackButton.tintColor = .white
        stepBackButton.isEnabled = true
        
        stepForwardButton.tintColor = .white
        stepForwardButton.isEnabled = true
        
        statusLabel.textColor = navBar.barTintColor!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        linesView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        UIApplication.shared.statusBarStyle = .lightContent
        sideMenus()
        
        hideToolbarButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

