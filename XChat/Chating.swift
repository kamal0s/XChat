//
//  Chating.swift
//  XChat
//
//  Created by Kamal on 1/22/1398 AP.
//  Copyright © 1398 Kamal. All rights reserved.
//

import UIKit
import Firebase



class Chating: UIViewController , UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    
    struct chatmessege {
        let text : String
        let senderIS : Bool
        let SenderName : String
        let Uid : Any
    }
    var UserID = Auth.auth().currentUser?.uid
    var Array = [chatmessege]()
    
    //MARK:- Set THE OUTLET FROM main.store
    
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    @IBOutlet weak var ChatTyping: UITextField!
    @IBOutlet weak var TableView: UITableView!
    
    /////////////////////////////////////////////
    
    
    //TODO: Go To ViewDidLoad Main Method
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        TableView.delegate = self
        TableView.dataSource = self
        ChatTyping.delegate = self
        TableView.separatorStyle = .none
        TableView.register(UINib(nibName: "TVCell", bundle: nil), forCellReuseIdentifier: "CellClass")
        TableView.register(UINib(nibName: "TVCellSender", bundle: nil), forCellReuseIdentifier: "SenderCell")
        
        // Do any additional setup after loading the view.
        
        let tapGuster = UITapGestureRecognizer(target: self, action: #selector(tapguster))
        TableView.addGestureRecognizer(tapGuster)
        GetMessegeFromDB()
        
    }
    
    //////////////////////////////////////////////////////////
    
    //TODO: Conigure keyborad to Height with TextFeild
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    ///////////////////////////////////////////////////////
    
    //MARK:- Setup TapGuster
    
    @objc func tapguster(){
        ChatTyping.endEditing(true)
    }
    
    ///////////////////////////////////////////////////////
    
    //MARK:- Configure TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            if Auth.auth().currentUser?.email == Array[indexPath.row].SenderName{
                let idOfUser = Array[indexPath.row].Uid as! String
                
                let Refrance = Database.database().reference().child("Messaging")
                
                Refrance.child(idOfUser).removeValue { (Error, DatabaseReference
                    ) in
                    if Error != nil{
                        print(Error)
                    }
                    else{
                        self.Array.remove(at: indexPath.row)
                        self.TableView.reloadData()
                        
                    }
                }
                self.TableView.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatmessege = Array[indexPath.row]
        let cell0 = TableView.dequeueReusableCell(withIdentifier: "CellClass", for: indexPath) as! TVCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! TVCellSender
        TableView.separatorStyle = .none
        
        var SenderNameSet = chatmessege.SenderName.split(separator: "@")
        if chatmessege.senderIS == false {
            let cell = cell0
            cell.MessegingLabel.text = chatmessege.text
            cell.UsernameLabel.text = "\(SenderNameSet[0])"
            cell.AvatarImage.image = UIImage(named: "125")
            cell.MessegingLabel.numberOfLines = 0
            cell.ChatBackground.translatesAutoresizingMaskIntoConstraints = false
            cell.ChatBackground.layer.cornerRadius = 12
            cell.ChatBackground.sizeToFit()
            
            return cell
        }
        else {
            cell1.senderMessege.text = chatmessege.text
            cell1.imageAvatarRight.image = UIImage(named: "124")
            cell1.SenderName.text = "\(SenderNameSet[0])"
            cell1.senderMessege.numberOfLines = 0
            cell1.senderView.translatesAutoresizingMaskIntoConstraints = false
            cell1.senderView.layer.cornerRadius = 12
            cell1.senderView.sizeToFit()
            
            return cell1
        }
    }
    
    ////////////////////////////////////////////////////////
    
    //Mark:- Scroll To Bottom
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.Array.count-1, section: 0)
            self.TableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    //MARK:- Send Button When Pressed
    
    @IBAction func SendPressed(_ sender: Any) {
        // ChatTyping.isEnabled = false
        ChatTyping.autocorrectionType = .no
        // SendButton.isEnabled = false
        ChatTyping.inputAccessoryView = nil
        
        //MARK:- Send
        
        let messege = Database.database().reference().child("Messaging")
        let msg = messege.childByAutoId()
        let MsgID = msg.key
        let senderInfo = ["Sender":Auth.auth().currentUser?.email,"message":ChatTyping.text!,"MessageID":MsgID]
        
        msg.setValue(senderInfo) {
            (error,value) in
            if error != nil {
                print(error!)
            }else{
                print("Succesful ")
                //  self.ChatTyping.isEnabled = true
                //  self.SendButton.isEnabled = true
                self.ChatTyping.text = ""
            }
        }
    }
    
    func GetMessegeFromDB(){
        
        let messageDb = Database.database().reference().child("Messaging")
        
        messageDb.observe(.childAdded) {
            (snapshot) in
            let messege = snapshot.value as! [String:String]
            let text = messege["message"]!
            let SenderID = messege["Sender"]!
            let MsgUid = messege["MessageID"]!
            if Auth.auth().currentUser?.email == SenderID {
                self.Array.append(chatmessege(text: text, senderIS: true, SenderName: SenderID, Uid: MsgUid))
                self.TableView.reloadData()
                self.scrollToBottom()
            }
            else {
                self.Array.append(chatmessege(text: text, senderIS: false, SenderName: SenderID, Uid:MsgUid))
                self.TableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
}
