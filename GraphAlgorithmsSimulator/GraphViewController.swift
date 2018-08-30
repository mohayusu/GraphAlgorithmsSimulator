//
//  ViewController.swift
//  GraphAlgorithmsVisualizer
//
//  Created by Mohamed Mohamed (mohayusu) on 8/3/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, LinesAndPointsDelegate, MenuTableDelegate {
    struct PropertyKeys {
        static let clear = "Clear"
        static let simulate = "Simulate"
        static let begin = "Begin"
        static let start = "Start"
        static let minPointsToBegin = 2
        static let connectPoints = "Make a connected graph by tapping points"
    }
    
    @IBOutlet weak var algorithmName: UINavigationItem!
    @IBOutlet weak var simulateBeginShowBtn: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var stepForwardButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var linesAndPointsView: LinesAndPoints!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var isCompleteGraph: Bool!
    var numPointsTapped: Int!
    var tempLocation: CGPoint?
    var selectedButton: UIButton?
    
    @IBAction func graphTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: linesAndPointsView)
        
        if !isCompleteGraph && simulateBeginShowBtn.currentTitle == PropertyKeys.connectPoints ||
            !isCompleteGraph && simulateBeginShowBtn.currentTitle == PropertyKeys.start {
            var minDistance: Double = Double.infinity
            var minButton: UIButton?
            for i in linesAndPointsView.allPoints {
                let tempDistance = Algorithms.calculateDistance(p1: location, p2: i.center)
                if tempDistance < minDistance {
                    minDistance = tempDistance
                    minButton = i
                }
            }
            numPointsTapped = numPointsTapped + 1
            if numPointsTapped % 2 == 0 {
                linesAndPointsView.connectPointsUndirected(p1: selectedButton!, p2: minButton!)
                let algorithm = Algorithms()
                if algorithm.isConnected(connections: linesAndPointsView.connectingPointsCollection,
                                         numPoints: linesAndPointsView.numPoints) {
                    simulateBeginShowBtn.setTitle(PropertyKeys.start, for: .normal)
                }
                tempLocation = minButton?.center
                selectedButton?.setTitleColor(.white, for: .normal)
                selectedButton?.backgroundColor = .blue
            } else {
                minButton?.backgroundColor = .yellow
                minButton?.setTitleColor(.black, for: .normal)
                selectedButton = minButton
                tempLocation = minButton?.center
            }
            
        } else {
        
            let diameter = CGFloat(LinesAndPoints.PropertyKeys.pointDiameter)
            let button = UIButton(frame: CGRect(x: location.x - diameter / 2, y: location.y - diameter / 2,
                                            width: diameter, height: diameter))
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.backgroundColor = .blue
            button.setTitle("\(linesAndPointsView.numPoints + 1)", for: .normal)
            linesAndPointsView.addSubview(button)
            button.addTarget(self, action: #selector(pointTapped), for: .touchUpInside)
    
            linesAndPointsView.addPoint(button: button)
        
            if linesAndPointsView.numPoints >= PropertyKeys.minPointsToBegin {
                simulateBeginShowBtn.isEnabled = true
            }
            
            if isCompleteGraph {
                linesAndPointsView.addConnectionToCompleteGraph(num: linesAndPointsView.numPoints)
            }
        }
    }
    
    @objc func pointTapped(sender: UIButton!) {
        if !isCompleteGraph && simulateBeginShowBtn.currentTitle == PropertyKeys.connectPoints ||
           !isCompleteGraph && simulateBeginShowBtn.currentTitle == PropertyKeys.start {
            if simulateBeginShowBtn.currentTitle != PropertyKeys.begin {
                numPointsTapped = numPointsTapped + 1
                if numPointsTapped % 2 == 0 {
                    linesAndPointsView.connectPointsUndirected(p1: selectedButton!, p2: sender)
                    let algorithm = Algorithms()
                    if algorithm.isConnected(connections: linesAndPointsView.connectingPointsCollection,
                                             numPoints: linesAndPointsView.numPoints) {
                        simulateBeginShowBtn.setTitle(PropertyKeys.start, for: .normal)
                    }
                    tempLocation = sender.center
                    selectedButton?.backgroundColor = .blue
                    selectedButton?.setTitleColor(.white, for: .normal)
                } else {
                    tempLocation = sender.center
                    sender.backgroundColor = .yellow
                    sender.titleLabel?.textColor = .black
                    sender.setTitleColor(.black, for: .normal)
                    selectedButton = sender
                }
            }
        }
    }


    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        hideToolbarButtons()
        linesAndPointsView.clearScreen()
        numPointsTapped = 0
        tempLocation = nil
    }
    
    @IBAction func simulateBeginShowBtnTapped(_ sender: UIButton) {
        if simulateBeginShowBtn.currentTitle == PropertyKeys.begin {
            if isCompleteGraph {
                linesAndPointsView.performAlgorithm(chosenAlgorithm: algorithmName.title!)
                revealToolbarButtons()
            } else {
                simulateBeginShowBtn.setTitle(PropertyKeys.connectPoints, for: .normal)
            }
        }  else if simulateBeginShowBtn.currentTitle == PropertyKeys.start {
            linesAndPointsView.performAlgorithm(chosenAlgorithm: algorithmName.title!)
            revealToolbarButtons()
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        linesAndPointsView.updateView(isFinal: true)
    }
    
    @IBAction func stepForwardButtonTapped(_ sender: UIButton) {
        linesAndPointsView.updateViewSteps()
    }
    
    func sideMenus() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 250
            let menu = revealViewController().rearViewController as! MenuTableViewController
            menu.delegate = self
            
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
    
    func showFinalWeightValue(str: String) { // LinesAndPoints delegate
        hideToolbarButtons()
        tapGesture.isEnabled = false
        simulateBeginShowBtn.isEnabled = true
        simulateBeginShowBtn.setTitle("Total weight: \(str) points", for: .normal)
    }
    
    func canChangeCompleteGraphStatus() -> Bool {
        if linesAndPointsView.numPoints > 0 {
            return false
        } else {
            return true
        }
    }

    func changeAlgorithmNameTo(algorithm: String) {
        algorithmName.title = algorithm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        linesAndPointsView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        UIApplication.shared.statusBarStyle = .lightContent
        sideMenus()
        
        hideToolbarButtons()
        linesAndPointsView.delegate = self
        numPointsTapped = 0
        isCompleteGraph = true
    }
    
    @IBAction func unwindToGraph(segue: UIStoryboardSegue) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

