//
//  MenuTableViewController.swift
//  GraphAlgorithmsSimulator
//
//  Created by Mohamed Mohamed on 8/4/18.
//  Copyright © 2018 Mohamed Mohamed. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var completeGraphSwitch: UISwitch!
    @IBOutlet weak var kruskalButton: UIButton!
    
    var currentAlgorithmSelected: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAlgorithmSelected = kruskalButton
    }
    
    @IBAction func completeGraphStatusChanged(_ sender: UISwitch) {
        if sender.isOn {
            
        }
        else {
            
        }
    }
    
    @IBAction func algorithmChoiceTapped(_ sender: UIButton) {
        currentAlgorithmSelected.setTitleColor(.black, for: .normal)
        sender.setTitleColor(.blue, for: .normal)
        currentAlgorithmSelected = sender
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
