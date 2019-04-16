//
//  Register.swift
//  XChat
//
//  Created by Kamal on 1/22/1398 AP.
//  Copyright © 1398 Kamal. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class Register: UIViewController {

    @IBOutlet weak var LaLog: UILabel!
    @IBOutlet weak var LaPassWord: UITextField!
    @IBOutlet weak var LaUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        LaUserName.resignFirstResponder()
        LaPassWord.resignFirstResponder()
    }

    @IBAction func RegisterPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: LaUserName.text!, password: LaPassWord.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                self.LaLog.text = "Error in your Info"
                
            }else{
                SVProgressHUD.dismiss()
                self.LaLog.text = ""
                self.performSegue(withIdentifier: "GoFromRegToLogin", sender: self)
                
            }
        }
    }
    

}
