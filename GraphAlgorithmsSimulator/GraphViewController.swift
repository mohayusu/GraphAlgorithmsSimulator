//
//  ViewController.swift
//  GraphAlgorithmsVisualizer
//
//  Created by Mohamed Mohamed (mohayusu) on 8/3/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    
    @IBOutlet weak var linesAndPointsView: LinesAndPoints!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var stepBackButton: UIBarButtonItem!
    @IBOutlet weak var stepForwardButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var numPoints: Int = 0
    
    @IBAction func graphTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: linesAndPointsView)
        
        let diameter = CGFloat(LinesAndPoints.PropertyKeys.pointDiameter)
        let button = UIButton(frame: CGRect(x: location.x - diameter / 2, y: location.y - diameter / 2,
                                            width: diameter, height: diameter))
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .blue
        linesAndPointsView.addSubview(button)
        
        numPoints += 1
        linesAndPointsView.addPoint(coordinate: location)
        
        if numPoints == 3 {
            revealToolbarButtons()
        }
      //  linesAndPointsView.updateView()
        
    }
    
    @IBAction func stepForwardButtonPressed(_ sender: UIBarButtonItem) {
        linesAndPointsView.updateView()
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
        statusLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        linesAndPointsView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        UIApplication.shared.statusBarStyle = .lightContent
        sideMenus()
        
        hideToolbarButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

