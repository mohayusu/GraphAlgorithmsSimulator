//
//  ViewController.swift
//  GraphAlgorithmsVisualizer
//
//  Created by Mohamed Mohamed (mohayusu) on 8/3/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, LinesAndPointsDelegate {
    struct PropertyKeys {
        static let clear = "Clear"
        static let simulate = "Simulate"
        static let begin = "Begin"
        static let minPointsToBegin = 2
    }
    
    @IBOutlet weak var simulateBeginShowBtn: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var stepForwardButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var clearButton: UIBarButtonItem!
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
            simulateBeginShowBtn.isEnabled = true
        }
    }


    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        hideToolbarButtons()
        linesAndPointsView.clearScreen()
        
    }
    
    @IBAction func simulateBeginShowBtnTapped(_ sender: UIButton) {
        if simulateBeginShowBtn.currentTitle == PropertyKeys.begin {
            revealToolbarButtons()
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        linesAndPointsView.updateView()
        hideToolbarButtons()
        tapGesture.isEnabled = false
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
        simulateBeginShowBtn.isEnabled = false
        
        simulateBeginShowBtn.setTitle(PropertyKeys.begin, for: .normal)
        tapGesture.isEnabled = true
    }
    
    func revealToolbarButtons() {
        skipButton.isHidden = false
        stepForwardButton.isHidden = false
        
        simulateBeginShowBtn.setTitle(PropertyKeys.simulate, for: .normal)
        tapGesture.isEnabled = false
    }
    
    func showValue(str: String) { // LinesAndPoints delegate
        simulateBeginShowBtn.isEnabled = true
        simulateBeginShowBtn.setTitle("Total weight: \(str) points", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        linesAndPointsView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        UIApplication.shared.statusBarStyle = .lightContent
        sideMenus()
        
        hideToolbarButtons()
        linesAndPointsView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

