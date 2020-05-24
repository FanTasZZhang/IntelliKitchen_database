//
//  WelcomeController.swift
//  UserLoginAndRegister
//
//  Created by Emily Xu on 5/7/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedTapped(_ sender: Any) {
        let profileController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileController) as? ProfilePageViewController
        print(Constants.Storyboard.profileController)
        view.window?.rootViewController = profileController
        view.window?.makeKeyAndVisible()
    }

    
    
}

