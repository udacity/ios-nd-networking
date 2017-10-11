//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/26/15.
//  Copyright © 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var loginButton: BorderedButton!
        
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIEnabled(true)
    }

    // MARK: Actions
    
    @IBAction func login(_ sender: AnyObject) {
        setUIEnabled(false)
        
        TMDB.shared.loginWithHostViewController(self, completion: {
            self.completeLogin()
        }, error: { (errorString) in
            self.alertError(errorString) { alert in
                self.setUIEnabled(true)
            }
        })
    }
    
    // MARK: Login
    
    private func completeLogin() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as? UINavigationController {
            present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
     private func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        loginButton.alpha = enabled ? 1.0 : 0.5
    }

    private func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
}
