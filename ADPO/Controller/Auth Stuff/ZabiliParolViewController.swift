//
//  ZabiliParolViewController.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 11.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ZabiliParolViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var topView: UIView!
    
    let activityIndicator = UIActivityIndicatorView()
    
    var zabiliParolDataManager = ZabiliParolDataManager()
    
    var futureTextFieldText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = futureTextFieldText
        
        topView.layer.cornerRadius = 5
        topView.alpha = 0.5
        
        nameTextField.layer.cornerRadius = 8 //Rounding the textField
        nameTextField.layer.borderWidth = 1 //Setting border
        nameTextField.layer.borderColor = UIColor.clear.cgColor  // Having clear color borders borders
        
        zabiliParolDataManager.delegate = self
        
        nameTextField.delegate = self
        
        button.layer.cornerRadius = 8
        
        
    }
    
    //MARK: - Actions
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        
        nameTextField.endEditing(true)
        
        nameTextField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if nameTextField.text != ""  {
            
            if NetworkManager().internetIsReachable(){
                
                showActivityIndicator()
                
                zabiliParolDataManager.getZabiliParolAnswr(username: nameTextField.text!)
            }else{
                self.showNoInternet()
            }
        }
        
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
    
    
    
} //End of VC

//MARK: - UITextFieldDelegate

extension ZabiliParolViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        nameTextField.layer.borderColor = #colorLiteral(red: 0.1548413038, green: 0.4597142339, blue: 0.7358804345, alpha: 1)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
    }
    
}

extension ZabiliParolViewController : ZabiliParolDataManagerDelegate{
    
    func didGetZabiliParolData(data: ZabiliParolData) {
        
        
        
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            
            self.nameTextField.endEditing(true)
            
            if data.code != 200{
                
                //Showing error from the api
                let alertController = UIAlertController(title: "Ошибка", message: data.errorText, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                }
                
                alertController.addAction(action)
                
                self.present(alertController, animated: true , completion: nil)
                
                return
            }
            
            //Showing success )
            let alertController = UIAlertController(title: data.answer, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            alertController.addAction(action)
            
            self.present(alertController, animated: true , completion: nil)
            
            
        }
        
    }
    
    func didFailZabiliParolWithError(error: String) {
        
        DispatchQueue.main.async {
            self.nameTextField.endEditing(true)
            
            self.hideActivityIndicator()
            print(error)
            
            //Showing error that happened with json or http request
            let alertController = UIAlertController(title: "Ошибка", message: "Ошибка отправки запроса , повторите попытку позже" , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            alertController.addAction(action)
            
            self.present(alertController, animated: true , completion: nil)
            
        }
        
    }
    
}
