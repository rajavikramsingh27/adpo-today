//
//  ObratniyZvonokViewController.swift
//  ADPO
//
//  Created by Sam on 30.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ObratniyZvonokViewController: UIViewController {
    
    @IBOutlet weak var voprosView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let activityIndicator = UIActivityIndicatorView()
    
    let hoursArray = ["9-12 час","12-15 час","15-18 час"]
    
    var obratnayaSvyazDataManager = ObratnayaSvyazDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.layer.cornerRadius = 5
        topView.alpha = 0.5
        
        nameTextField.layer.cornerRadius = 8 //Rounding the textField
        nameTextField.layer.borderWidth = 1 //Setting border
        nameTextField.layer.borderColor = UIColor.clear.cgColor  // Having clear color borders borders
        
        phoneTextField.layer.cornerRadius = 8 //Rounding the textField
        phoneTextField.layer.borderWidth = 1 //Setting border
        phoneTextField.layer.borderColor = UIColor.clear.cgColor  // Having clear color borders borders
        
        obratnayaSvyazDataManager.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        nameTextField.delegate = self
        phoneTextField.delegate = self
        questionTextField.delegate = self
        
        button.layer.cornerRadius = 8
        
        voprosView.layer.borderColor = #colorLiteral(red: 0.8521580696, green: 0.8522811532, blue: 0.8521311879, alpha: 1)
        voprosView.layer.borderWidth = 1
        voprosView.layer.cornerRadius = 5
        
    }
    
    //MARK: - Actions
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        
        nameTextField.endEditing(true)
        phoneTextField.endEditing(true)
        questionTextField.endEditing(true)
        
        nameTextField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
        phoneTextField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
        voprosView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        
        if nameTextField.text != "" , phoneTextField.text != "" , questionTextField.text != "" {
            
            if NetworkManager().internetIsReachable(){
                
                showActivityIndicator()
                
                let index = pickerView.selectedRow(inComponent: 0)
                let selectedTime = hoursArray[index]
                
                let urlString =  "https://sdo.adpo.edu.ru/local/api/mobile.php"
                
                let params = ["salt" : "HGDGJHSJSJJSJ7777ssd" ,
                              "method" : "sendcall" ,
                              "fio" : nameTextField.text! ,
                              "phone" : phoneTextField.text! ,
                              "text" : questionTextField.text! ,
                              "times" : selectedTime]
                
                obratnayaSvyazDataManager.getAnswer(urlString: urlString, params: params)
                
                print(urlString)
                
            }else{
                self.showNoInternet()
            }
        }
        
        // print(questionArray[questionsPickerView.selectedRow(inComponent: 0)])
        
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

extension ObratniyZvonokViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.restorationIdentifier == "nameTextField"{
            
            nameTextField.layer.borderColor = #colorLiteral(red: 0.1548413038, green: 0.4597142339, blue: 0.7358804345, alpha: 1)
        }else if textField.restorationIdentifier == "phoneTextField" {
            phoneTextField.layer.borderColor = #colorLiteral(red: 0.1548413038, green: 0.4597142339, blue: 0.7358804345, alpha: 1)
        }else{
            voprosView.layer.borderColor = #colorLiteral(red: 0.1548413038, green: 0.4597142339, blue: 0.7358804345, alpha: 1)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
        voprosView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}

//MARK: - UIPickerView

extension ObratniyZvonokViewController : UIPickerViewDataSource , UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return hoursArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    //Setting custom view as a row
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "", size: 17)
            pickerLabel?.textAlignment = .center
            pickerLabel?.text = hoursArray[row]
        }
        
        return pickerLabel!
        
    }
    
}

//MARK: - ObratnayaSvyazDataManagerDelegate

extension ObratniyZvonokViewController : ObratnayaSvyazDataManagerDelegate{
    
    func didFailObratnayaSvyazWithError(error: String) {
        
        hideActivityIndicator()
        print(error)
        
    }
    
    
    func didGetAnswer(answer: ObratnayaSvyazData) {
        
        DispatchQueue.main.async {
            
            print("I GOT AN ASNWER")
            
            self.hideActivityIndicator()
            
            //Showing the result
            
            if answer.code != 200 {
                
                let alertController = UIAlertController(title: answer.errorText, message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                }
                
                alertController.addAction(action)
                
                self.present(alertController , animated: true , completion: nil)
                
                return
            }
            
            let alertController = UIAlertController(title: answer.answer, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            alertController.addAction(action)
            
            self.present(alertController , animated: true , completion: nil)
            
        }
        
    }
    
}

