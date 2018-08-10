//
//  ViewController.swift
//  GraphAlgorithmsVisualizer
//
//  Created by Mohamed Mohamed (mohayusu) on 8/3/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    struct PropertyKeys {
        static let clear = "Clear"
        static let simulate = "Simulate"
        static let begin = "Begin"
        static let minPointsToBegin = 2
    }
    
    @IBOutlet weak var simulateAndClearBtn: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var stepForwardButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var beginButton: UIBarButtonItem!
    @IBOutlet weak var linesAndPointsView: LinesAndPoints!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func graphTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: linesAndPointsView)
        
        let diameter = CGFloat(LinesAndPoints.PropertyKeys.pointDiameter)
        let button = UIButton(frame: CGRect(x: location.x - diameter / 2, y: location.y - diameter / 2,
                                            width: diameter, height: diameter))
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .blue
        linesAndPointsView.addSubview(button)
        
        linesAndPointsView.addPoint(coordinate: location)
        
        if linesAndPointsView.numPoints > PropertyKeys.minPointsToBegin {
            beginButton.isEnabled = true
        }
    }

    @IBAction func simulateAndClearBtnTapped(_ sender: UIButton) {
        if simulateAndClearBtn.currentTitle == PropertyKeys.clear {
            beginButton.title = PropertyKeys.begin
            beginButton.isEnabled = false
            linesAndPointsView.clearScreen()
        }
    }
    
    @IBAction func beginButtonTapped(_ sender: Any) {
        if beginButton.title == PropertyKeys.clear {
            beginButton.title = PropertyKeys.begin
            beginButton.isEnabled = false
            tapGesture.isEnabled = true
            hideToolbarButtons()
            linesAndPointsView.clearScreen()
        } else {
            beginButton.title = PropertyKeys.clear
            tapGesture.isEnabled = false
            revealToolbarButtons()
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
        skipButton.isHidden = true
        stepForwardButton.isHidden = true
        
        simulateAndClearBtn.setTitle(PropertyKeys.clear, for: .normal)
    }
    
    func revealToolbarButtons() {
        skipButton.isHidden = false
        stepForwardButton.isHidden = false
        
        simulateAndClearBtn.setTitle(PropertyKeys.simulate, for: .normal)
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

