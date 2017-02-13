//
//  ViewController.swift
//  EnvironmentControl
//
//  Created by Mike Pesate on 10/02/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var environmentLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        environmentLabel.text = EnvironmentControl.shared.currentEnvironment.description()
        
        NotificationCenter.default.addObserver(self, selector: #selector(environmentChanged), name: EnvironmentDidChangeNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func environmentChanged() {
        
        environmentLabel.text = EnvironmentControl.shared.currentEnvironment.description()
        
    }
    


}

