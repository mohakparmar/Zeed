//
//  ProfileController.swift
//  Zeed
//
//  Created by Shrey Gupta on 04/03/21.
//

import UIKit

class UserProfileController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .random
    }
}
