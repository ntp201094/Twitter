//
//  LoginViewController.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInViewBottomConstraint: NSLayoutConstraint!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        registerObserversForKeyboards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signIn()
    }
    
    // MARK: - Helpers
    
    private func registerObserversForKeyboards() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func setupLayout() {
        formView.smoothRoundCorners(to: 8)
        signInView.smoothRoundCorners(to: signInView.bounds.height / 2)
        nameTextField.tintColor = .primary
        nameTextField.addTarget(self, action: #selector(didNameTextFieldActionTriggered), for: .primaryActionTriggered)
    }
    
    private func signIn() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showMissingNameAlert()
            return
        }
        
        nameTextField.resignFirstResponder()
        
        AppSettings.displayName = name
        Auth.auth().signInAnonymously(completion: nil)
    }
    
    private func showMissingNameAlert() {
        let ac = UIAlertController(title: "Display Name Required", message: "Please enter a display name.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.nameTextField.becomeFirstResponder()
            }
        }))
        present(ac, animated: true, completion: nil)
    }

}

// MARK: - Storyboard instance
extension LoginViewController {
    static func storyboardInstance() -> LoginViewController? {
        
        let storyboard = AppStoryboards.main.instance
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? LoginViewController
        
    }
}

// MARK: - Event Hanlders
extension LoginViewController {
    @objc func didNameTextFieldActionTriggered() {
        signIn()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return
        }
        
        let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
        signInViewBottomConstraint.constant = keyboardHeight + 20
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return
        }
        
        let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
        signInViewBottomConstraint.constant = 20
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
