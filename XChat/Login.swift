//
//  Login.swift
//  XChat
//
//  Created by Kamal on 1/22/1398 AP.
//  Copyright © 1398 Kamal. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class Login: UIViewController {

    @IBOutlet weak var LaLog: UILabel!
    @IBOutlet weak var LaPassWord: UITextField!
    @IBOutlet weak var LaUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        LaUserName.resignFirstResponder()
        LaPassWord.resignFirstResponder()
    }
    

  
    @IBAction func LoginPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: LaUserName.text!, password: LaPassWord.text!) { (user, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                self.LaLog.text = "Check Your Info"
                
            }
            else{
                
                SVProgressHUD.dismiss()
                self.LaLog.text = ""
               self.performSegue(withIdentifier: "GoFromLoginToChat", sender: self)
                
            }
        }
    
    
    }
    
    

}
