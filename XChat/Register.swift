//
//  Register.swift
//  XChat
//
//  Created by Kamal on 1/22/1398 AP.
//  Copyright © 1398 Kamal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class Register: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let gender = ["Male","Female"]

    @IBOutlet weak var laPckerView: UIPickerView!
    @IBOutlet weak var LaName: UITextField!
    @IBOutlet weak var LaLog: UILabel!
    @IBOutlet weak var LaPassWord: UITextField!
    @IBOutlet weak var LaUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        laPckerView.delegate = self
        laPckerView.dataSource = self
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
                Auth.auth().signIn(withEmail: self.LaUserName.text!, password: self.LaPassWord.text!, completion: { (auth, error) in
                    if error == nil {
                        let userid = self.LaUserName.text!.split(separator: ".")
                        let iduser = userid[0]
                        let user = Database.database().reference().child("Users")
                        let DataBase1 = user.childByAutoId()
                        
                        let DataBase = DataBase1.child(String(iduser))
                       
                        let arg = ["Name":self.LaName.text!,"Uid":Auth.auth().currentUser?.uid,"UserEmail":self.LaUserName.text!]
                         DataBase.setValue(arg)
                        
                    }
                })
                do{
                    try Auth.auth().signOut()
                    
                }catch{
                    print("error in Sinout , Rigster Classs")
                }
                SVProgressHUD.dismiss()
                self.LaLog.text = ""
                self.performSegue(withIdentifier: "GoFromRegToLogin", sender: self)
                
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(gender[row])
        return gender[row]
    }
}
