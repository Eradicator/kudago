//
//  NavigationController.swift
//  Kudago
//
//  Created by Alexander Polyakov on 23/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNavigationBarHidden(viewController.isKind(of: MainViewController.self), animated: false)
    }
}
