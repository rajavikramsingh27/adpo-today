//
//  ViewController.swift
//  ADPO
//
//  Created by Sam on 15.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import SafariServices
import SystemConfiguration

class LoginViewController: UIViewController , AuthManagerDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginUnderView: UIView!
    @IBOutlet weak var passwordUnderView: UIView!
    
    @IBOutlet weak var leftDownView: UIView!
    @IBOutlet var rightDownView: UIView!
    
    
    @IBOutlet weak var voytiButton: UIButton!
    
    let defaults = UserDefaults.standard
    var authManager = AuthManager()
    
    var loginTextFieldIsSelected : Bool = false
    
    var loginTextFieldValue : String = String()
    var passwordTextFieldValue : String = String()
    
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    let networkManager = NetworkManager() // An object of NetworkManager struct that I created for inet checking
    
    var deviceTokenAnswerDataManager = DeviceTokenAnswerDataManager()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making lines under login and password textFields have gradient color )
        
        loginUnderView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        passwordUnderView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        
        authManager.delegate = self //Setting self as authManager's delegate. I've crated my own protocol , it's in AuthManager.swift :) I'm just making your life easy bro ))) Брат за брата ;)
        deviceTokenAnswerDataManager.delegate = self
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        
        voytiButton.layer.cornerRadius = 8 //Rounding our button's edges :)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if defaults.string(forKey: "token") != nil {  //Checking for token in userDefaults
            performSegue(withIdentifier: "goToMainPage", sender: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - AuthManagerDelegate Methods
    
    func didGetLoginData(data: LoginData) { //This happens when JSON is decoded in AuthManager.swift
        
        hideActivityIndicator()
        
        let token = data.answer.token
        
        print(token)
        
        DispatchQueue.main.async {
            
            self.defaults.set(token , forKey: "token") //Setting token we got from AutgManager to userDefaults
            
            if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"){
                
                print("GOT DATA DEVICE TOKEN")
                self.deviceTokenAnswerDataManager.getDeviceTokenDataAnswer(deviceToken: deviceToken, token: token)
                
            }
            
            self.goToMainPage(shouldBeAnimated: true)
        }
        
    }
    
    func didFailWithError(_ error: String) {
        print(error) //Just printing the error if it happened in AuthManager XD
        
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            
            self.loginTextField.endEditing(true)
            self.passwordTextField.endEditing(true)
            
            // Usually when it's error with login or pass our program says "The data couldn’t be read because it isn’t in the correct format.". 
            if error == "The data couldn’t be read because it isn’t in the correct format." {
                
                self.hideActivityIndicator()
                
                let alertController = UIAlertController(title: "Неверный логин/пароль", message: "Не удалось войти в аккаунт", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ок", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(action)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func PereytiNaSaytPressed(_ sender: UIButton) {
        
        if networkManager.internetIsReachable() {
            
            //Creating a safari VC and showing the url
            if let url = URL(string: "https://adpo.edu.ru"){
                
                let vc = SFSafariViewController(url:url )
                
                present(vc , animated: true,completion: nil)
            }
        }else{
            
            self.showNoInternet()
            
        }
    }
    
    @IBAction func zakazatZvonokPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let zakazatZvonokVC = storyboard.instantiateViewController(withIdentifier: "zakazatZvonokVC")
        
        self.present(zakazatZvonokVC, animated: true)
        
    }
    
    
    @IBAction func zadatVoprosPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let zadatVoprosVC = storyboard.instantiateViewController(withIdentifier: "zadatVoprosVC")
        
        self.present(zadatVoprosVC, animated: true)
        
    }
    
    func goToMainPage(shouldBeAnimated : Bool) {
        
        performSegue(withIdentifier: "goToMainPage", sender: self)
        
    }
    
    @IBAction func voytiPressed(_ sender: UIButton) {
        
        if networkManager.internetIsReachable(){
            
            if loginTextField.text != "" && passwordTextField.text != "" {
                
                showActivityIndicator()
                
                authManager.getLoginData(userName: loginTextFieldValue, password: passwordTextFieldValue) //Getting login data for logging in ;)
                
                
            }
        }else{
            self.showNoInternet()
        }
        
    }
    
    @IBAction func zabiliParolPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let zabiliParolVC = storyboard.instantiateViewController(withIdentifier: "ZabiliParolVC") as! ZabiliParolViewController
        
        if loginTextField.text != "" && loginTextField.text != nil {
            
            zabiliParolVC.futureTextFieldText = loginTextField.text ?? ""
            
        }
        
        self.present(zabiliParolVC, animated: true)
        
    }
    //MARK: - TextField Actions
    
    @IBAction func viewPressed(_ sender: UITapGestureRecognizer) {
        
        loginTextField.endEditing(true)
        passwordTextField.endEditing(true)
        //Closing keyboard when view is pressed
        
    }
    
    @IBAction func loginTextFieldEditingChanged(_ sender: UITextField) {
        
        loginTextFieldValue = sender.text! // Just giving loginTextField's text to a variable )
        
    }
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: UITextField) {
        
        passwordTextFieldValue = sender.text! // Just giving  passwordTextField's text to a variable ))
        
    }
    
    
    
}  // This is the end of LoginViewController class XD


//MARK: - UITextFieldDelegate Methods
extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        let loginTextFieldIsSelected  = textField.restorationIdentifier == "loginField" ? true : false //Checking to see if it was login textField or the one for password and remembering it in this variable )
        
        //print(loginTextFieldIsSelected)
        
        textField.placeholder = "" //Just deleting placeholder because it's not beautiful when it's selected and it has a placeholder XD
        
        var gradient = CAGradientLayer() // Creating a gradient to use it below )))
        
        if loginTextFieldIsSelected {
            
            //Changing and setting gradient color for login Underline. Same code as in ViewDidLoad XD There are the explainations brooo
            
            gradient = CAGradientLayer()
            gradient.frame = loginUnderView.bounds
            gradient.type = .axial
            gradient.colors = [
                UIColor.white.cgColor,
                UIColor.systemBlue.cgColor,
                UIColor.white.cgColor
            ]
            gradient.locations = [0, 0.5, 1]
            
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            loginUnderView.layer.addSublayer(gradient)
            
        }else{
            
            //Changing and setting gradient color for password Underline. Same code as in ViewDidLoad XD There are the explainations brooo
            
            gradient = CAGradientLayer()
            gradient.frame = passwordUnderView.bounds
            gradient.type = .axial
            gradient.colors = [
                UIColor.white.cgColor,
                UIColor.systemBlue.cgColor,
                UIColor.white.cgColor
            ]
            //            gradient.locations = [0, 0.5, 1]
            
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            passwordUnderView.layer.addSublayer(gradient)
            
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        loginTextFieldIsSelected  = textField.restorationIdentifier == "loginField" ? true : false //Checking to see if it was login textField or the one for password and remembering it in this variable )≥
        
        //print("\(loginTextFieldIsSelected) in End Editing")
        
        var gradient = CAGradientLayer()
        
        if loginTextFieldIsSelected{
            
            loginTextField.placeholder = "Логин"
            
            //Setting gradient color for login line
            gradient.frame = loginUnderView.bounds // Giving the loginUnderView's size to our gradient
            gradient.type = .axial //Setting gradient type to axial (It means that it will have colors starting , middle and end , so it's like a line
            gradient.colors = [ //Giving start , middle and end colors
                UIColor.white.cgColor,
                UIColor.lightGray.cgColor,
                UIColor.white.cgColor
            ]
            gradient.locations = [0, 0.5, 1] // Setting the locations for colors we've set above
            
            gradient.startPoint = CGPoint(x: 0, y: 1) //Giving starting point for gradient
            gradient.endPoint = CGPoint(x: 1, y: 1) //Giving endpoint for gradient
            //We're using same y cordinate beacuase we want our gradient to move only from left to right or opposite , we don't need height changes
            
            loginUnderView.layer.addSublayer(gradient) //Here just adding our gradient as a layer for that little view under the textField ;)
        } else{
            
            passwordTextField.placeholder = "Пароль"
            
            
            //Setting gradient color for password line. Same code ))
            gradient = CAGradientLayer()
            gradient.frame = passwordUnderView.bounds
            gradient.type = .axial
            gradient.colors = [
                UIColor.white.cgColor,
                UIColor.lightGray.cgColor,
                UIColor.white.cgColor
            ]
            //            gradient.locations = [0, 0.5, 1]
            
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            passwordUnderView.layer.addSublayer(gradient)
        }
        
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != nil && passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != nil {
            showActivityIndicator() //Showing loading... )
            authManager.getLoginData(userName: loginTextFieldValue, password: passwordTextFieldValue) //Getting login data for logging in ;)
        }
        
        textField.endEditing(true)
        
        return true
        
    }
    
    
    //MARK: - Activity Indicator Stuff
    func showActivityIndicator () {
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func hideActivityIndicator(){
        
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        
    }
    
    
}

extension LoginViewController : DeviceTokenAnswerDataManagerDelegate{
    
    func didGetDeviceTokenDataAnswer(data: DeviceTokenAnswerData) {
        
        DispatchQueue.main.async {
            
            self.hideActivityIndicator()
            
            if data.code != 200 {
                
                
                
            }
        }
        
        
    }
    
    func didFailGettingDeviceTokenDataAnswerWithError(error : String) {
        
        hideActivityIndicator()
        
        print(error)
    }
    
}


//MARK: - Gradient Stuff
extension UIView {
    
    func addGradient(colors: [UIColor], locations: [NSNumber]) {
        addSubview(ViewWithGradient(addTo: self, colors: colors, locations: locations))
    }
}

class ViewWithGradient: UIView {
    private var gradient = CAGradientLayer()
    init(addTo parentView: UIView, colors: [UIColor], locations: [NSNumber]){
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 2))
        restorationIdentifier = "__ViewWithGradient"
        for subView in parentView.subviews {
            if let subView = subView as? ViewWithGradient {
                if subView.restorationIdentifier == restorationIdentifier {
                    subView.removeFromSuperview()
                    break
                }
            }
        }
        
        let cgColors = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        
        gradient.frame = parentView.frame
        gradient.colors = cgColors
        gradient.locations = locations
        backgroundColor = .clear
        
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.type = .axial
        
        parentView.addSubview(self)
        parentView.layer.insertSublayer(gradient, at: 0)
        parentView.backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        clipsToBounds = true
        parentView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let parentView = superview {
            gradient.frame = parentView.bounds
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        gradient.removeFromSuperlayer()
    }
}
