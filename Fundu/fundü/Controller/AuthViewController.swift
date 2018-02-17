//
//  ViewController.swift
//  fundü
//
//  Created by Nicholas Kaimakis on 11/29/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView

class AuthViewController: UIViewController {
    var titleLabel: UILabel!
    var mottoLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var createAccountButton: UIButton!
    let SharedFunduModel = FunduModel.shared
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.72, alpha:1.0)
        
        self.hideKeyboardWhenTappedAround() 
        
        createTitleLabel()
        createMottoLabel()
        createLoginFields()
        createLoginButton()
        createCreateAccountButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if( userDefaults.string(forKey: "email") !=  nil ){
            let email = userDefaults.string(forKey: "email")
            let password = userDefaults.string(forKey: "password")
            print(email)
            print(password)
            logIn(email: email!, password: password!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createTitleLabel(){
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titleLabel.center = CGPoint(x: 50, y: 285)
        titleLabel.textAlignment = .center
        titleLabel.text = "fundu"
        titleLabel.textColor = UIColor.white
        titleLabel.center.x = self.view.center.x
        titleLabel.center.y = self.view.center.y * 0.4
        titleLabel.font = UIFont(name: "DidactGothic-Regular", size: 44)
        self.view.addSubview(titleLabel)
    }
    
    func createMottoLabel(){
        self.mottoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int(self.view.bounds.width), height: 40))
        mottoLabel.center = CGPoint(x: 50, y: 285)
        mottoLabel.textAlignment = .center
        mottoLabel.text = "invest with friends"
        mottoLabel.textColor = UIColor.white
        mottoLabel.center.x = self.view.center.x
        mottoLabel.center.y = self.view.center.y * 0.6
        mottoLabel.font = UIFont(name: "OpenSans-LightItalic", size: 26)
        self.view.addSubview(mottoLabel)
    }
    
    func createLoginFields(){
        self.emailTextField = getTextFieldWithPlaceholder(placeholder: "Enter email", fontSize: 14)
        emailTextField.center.y = self.view.center.y * 1
        self.view.addSubview(emailTextField)
        self.passwordTextField = getTextFieldWithPlaceholder(placeholder: "Enter password", fontSize: 14)
        passwordTextField!.isSecureTextEntry = true
        passwordTextField!.center.y = emailTextField.center.y + 50
        self.view.addSubview(passwordTextField)
    }
    
    func getTextFieldWithPlaceholder(placeholder: String, fontSize: Int) -> UITextField{
        let field: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        field.center.x = self.view.center.x
        field.placeholder = placeholder
        field.borderStyle = UITextBorderStyle.roundedRect
        field.font = UIFont(name: "DidactGothic-Regular", size: CGFloat(fontSize))
        field.keyboardType = UIKeyboardType.default
        field.returnKeyType = UIReturnKeyType.done
        field.clearButtonMode = UITextFieldViewMode.whileEditing
        field.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        field.backgroundColor = UIColor.white
        return field
    }
    
    func createLoginButton(){
        self.loginButton = UIButton(frame: CGRect(x: 50, y: 400, width: 100, height: 50))
        loginButton.backgroundColor = UIColor.gray
        loginButton.layer.cornerRadius = 5
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        loginButton.tag = 1
        self.view.addSubview(loginButton)
    }
    
    func createCreateAccountButton(){
        self.createAccountButton = UIButton(frame: CGRect(x: 200, y: 400, width: 100, height: 50))
        createAccountButton.backgroundColor = UIColor.gray
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.titleLabel?.adjustsFontSizeToFitWidth = true
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        createAccountButton.tag = 2
        self.view.addSubview(createAccountButton)
    }
    
    // This button is the size of the screen and exists so that if the user taps outside of a textfield, the keyboard will dismiss. Otherwise its hard to find buttons because keyboard blocks it
    /*
    func createBackgroundButton() {
        self.backgroundButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        backgroundButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        backgroundButton.tag = 2
        self.view.addSubview(backgroundButton)
    }
 */
    
    //define actions for various buttons
    @objc func buttonAction(sender: UIButton!) {
        let buttonTag: UIButton = sender
        if buttonTag.tag == 1 {
            //authenicate user TODO
            if (emailTextField.text != "" && passwordTextField.text != "") {
                logIn(email: emailTextField.text!, password: passwordTextField.text!)
            } else {
                SCLAlertView().showError("Please enter your email and password to sign in", subTitle: "")
            }
        }
        if buttonTag.tag == 2 {
            self.createAccountButtonPressed()
        }
    }
    
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            if(err != nil ){
                self.dismissKeyboard()
                SCLAlertView().showError("Whoops!", subTitle: err!.localizedDescription)
            }
            else{
                self.userDefaults.setValue(email, forKey: "email")
                self.userDefaults.setValue(password, forKey: "password")
                let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: AnyObject] {
                        let username = (dict["username"] as? String)!
                        let newUser = User(newUsername: username, newEmail: email, newPassword: password, newID: uid!)
                        
                        self.SharedFunduModel.setMyUser(newUser:newUser)
                    }
                    
                    self.moveToDashboardView()
                    
                }, withCancel: nil)
            }
        })
    }
    
    func moveToDashboardView() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let mainNavVC = UINavigationController()
        let mainView = DashboardViewController()
        mainView.username = emailTextField.text
        mainNavVC.viewControllers = [mainView]
        
        let drawerNavVC = UINavigationController()
        let drawerView = LeftDrawerTableViewController()
        drawerNavVC.viewControllers = [drawerView]
        
        appDel.drawerController.mainViewController = mainNavVC
        appDel.drawerController.drawerViewController = drawerNavVC
        appDel.drawerController.drawerWidth = 150
        
        appDel.window?.rootViewController = appDel.drawerController
        appDel.window?.makeKeyAndVisible()
    }
    
    func createAccountButtonPressed() {
        
        dismissKeyboard()
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let username = alert.addTextField("Username: ")
        let email = alert.addTextField("Email: ")
        if emailTextField.text != "" {
            email.text = emailTextField.text!
        }
        let password = alert.addTextField("Password: ")
        if passwordTextField.text != "" {
            password.text = passwordTextField.text!
        }
        alert.addButton("Create Account") {
            //if textfields are both not empty, create new user (in firebase and model) and segway to parties
            if(username.text != "" && password.text != "" && email.text != "") {
                Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                    if(error != nil ){
                        self.dismissKeyboard()
                        SCLAlertView().showError("Whoops!", subTitle: error!.localizedDescription)
                    }
                    else{
                        let newUser = User(newUsername: username.text!, newEmail: email.text!, newPassword: password.text!, newID: (user?.uid)!)
                        self.SharedFunduModel.addNewUser(newUser: newUser)
                        self.SharedFunduModel.setMyUser(newUser: newUser)
                        self.moveToDashboardView()
                        self.userDefaults.setValue(email.text!, forKey: "email")
                        self.userDefaults.setValue(password.text!, forKey: "password")
                    }
                }
                
            }
        }
        alert.showInfo("Create an Account", subTitle: "")
        
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

