//
//  LoginViewController.swift
//  localtiptopPlan
//
//  Created by Dan Li on 13.10.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addtargetTextField()
      
        
    }
    //MARK: -当用户已经登陆对出界面再次进入界面时的自动login方法。              
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthenticationService.automaticSingIn {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
//        if Auth.auth().currentUser != nil{
//            DispatchQueue.main.async {
//                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
//                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
//                })
//            }
//        }
    }
    
    //MARK: -让j键盘掉下去的方法。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: -👇当email和password都填满时才能显示login按钮的方法。
        func addtargetTextField(){
            loginButton.isEnabled = false
            emailTextField.addTarget(self, action: #selector(textfFieldDidChange), for: .editingChanged)
            passwordTextfield.addTarget(self, action: #selector(textfFieldDidChange), for: .editingChanged)
        }
        @objc func textfFieldDidChange(){
            let isText = emailTextField.text?.count ?? 0 > 0 && passwordTextfield.text?.count ?? 0>0
            
            if isText {
                loginButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
                loginButton.isEnabled = true
            }else{
                loginButton.backgroundColor = UIColor(white: 0.8, alpha: 0)
                loginButton.layer.cornerRadius = 5
                loginButton.isEnabled = false
            }
        }
      //👆当email和password都填满时再能显示login按钮。
    

    //MARK: -login Button auth将自动检查user名字和password
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)//当用户填完信息让键盘掉下去的方法。
         //简化前代码👇
//        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!) { (data, erro) in
//            if let err = erro{
//                print(err.localizedDescription)
//                return
//            }
//            //检查user名字和password正确后顺着loginSegue的链接进入HomeViewController。
//            self.performSegue(withIdentifier: "loginSegue",sender: nil)
//        }
        //简化前代码👆
        //简化后代吗👇//实现这段代码的功能在AuthenticationService.swift里面。
        ProgressHUD.show("Lade", interaction: false)
        AuthenticationService.signIn(eMail: emailTextField.text!, password: passwordTextfield.text!, onSuccess: {
            ProgressHUD.showSuccess("Welkommen zurück")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error) in
            ProgressHUD.showError(error!)
            print(error!)
            
        }
//        //简化后代吗👆
    }
    
  
}
