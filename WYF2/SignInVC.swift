//
//  ViewController.swift
//  WYF2
//
//  Created by Khai Nguyen on 1/20/17.
//  Copyright © 2017 KhaizerkhaiStudios. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var passwordField: FancyField!
    @IBOutlet weak var emailField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {(result, error) in
        if error != nil {
                print("KHAI: Unable to authenticate with Facebook -\(error)")
        } else if result?.isCancelled == true {
                print("KHAI: User cancelled Facebook authentication")
        } else {
                print("KHAI: Successfully authenticated with Facebook")
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("KHAI: Unable to authenticate with Firebase - \(error)")
            } else {
                print("KHAI: Successfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion:{ (user, error) in
                if error == nil {
                    print("KHAI: Email user authenticated with Firebase")
                } else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print("KHAI: Unable to authenticate with Firebase using email")
                } else {
                    print("KHAI: Successfully authenticated with Firebase")
                }
                    
                    })
                }
            })
        }
    }
    
}

