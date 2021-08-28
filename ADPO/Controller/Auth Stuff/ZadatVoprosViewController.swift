//
//  ObratniyZvonokViewController.swift
//  ADPO
//
//  Created by Sam on 30.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ZadatVoprosViewController: UIViewController {
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var FIOTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var questionsPickerView: UIPickerView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    var questionArray : [ZadatVoprosAnswerData] = []
    
    var zadatVoprosQuestionDataManager = ZadatVoprosQuestionDataManager()
    
    var obratnayaSvyazDataManager = ObratnayaSvyazDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting some style to that line above)
        topView.layer.cornerRadius = 5
        topView.alpha = 0.5
        
        FIOTextField.layer.cornerRadius = 8 //Rounding the textField
        FIOTextField.layer.borderWidth = 1 //Setting border
        FIOTextField.layer.borderColor = UIColor.clear.cgColor  // Having clear color borders borders
        
        emailTextField.layer.cornerRadius = 8 //Rounding the textField
        emailTextField.layer.borderWidth = 1 //Setting border
        emailTextField.layer.borderColor = UIColor.clear.cgColor  // Having clear color borders borders
        
        //Setting delegates
        zadatVoprosQuestionDataManager.delegate = self
        FIOTextField.delegate = self
        emailTextField.delegate = self
        textTextField.delegate = self
        questionsPickerView.delegate = self
        questionsPickerView.dataSource = self
        obratnayaSvyazDataManager.delegate = self
        
        //Rounding our button
        button.layer.cornerRadius = 8
        
        //Styling the view around text textfield)
        
        textView.layer.borderColor = #colorLiteral(red: 0.8521580696, green: 0.8522811532, blue: 0.8521311879, alpha: 1)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        
        zadatVoprosQuestionDataManager.getQuestions() //Getting questions
        showActivityIndicator() //Loading...
    }
    
    
    //MARK: - Actions
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil) //Going back to login vc
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        
        //Dismissing keyboard
        FIOTextField.endEditing(true)
        emailTextField.endEditing(true)
        textTextField.endEditing(true)
        
        
        FIOTextField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
        emailTextField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
        textView.layer.borderColor = UIColor.lightGray.cgColor //Getting back to gray
    }
    
    //This is the main button , the blue one
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if FIOTextField.text != "" , emailTextField.text != "" , textTextField.text != "" {
            
            if NetworkManager().internetIsReachable(){
                
                showActivityIndicator()
                
                let index = questionsPickerView.selectedRow(inComponent: 0)
                let selectedQuestionId = questionArray[index].id
                
                let urlString =  "https://sdo.adpo.edu.ru/local/api/mobile.php"
                
                let params = ["salt" : "HGDGJHSJSJJSJ7777ssd" ,
                              "method" : "sendquestion" ,
                              "fio" : FIOTextField.text! ,
                              "email" : emailTextField.text! ,
                              "text" : textTextField.text! ,
                              "who" : "\(selectedQuestionId)"]
                
                obratnayaSvyazDataManager.getAnswer(urlString: urlString, params: params)
                
                print(selectedQuestionId)
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
    
    
} //End of view controller


//MARK: - UITextFieldDelegate

extension ZadatVoprosViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Here just changing color to show that the place you've selected is actually selected
        
        if textField.restorationIdentifier == "nameTextField"{
            FIOTextField.layer.borderColor = #colorLiteral(red: 0.1548413038, green: 0.4597142339, blue: 0.7358804345, alpha: 1)
        }else if textField.restorationIdentifier == "phoneTextField" {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.1548413038, green: 0.4597142339, blue: 0.7358804345, alpha: 1)
        }else{
            textView.layer.borderColor = #colorLiteral(red: 0.1548413038, green: 0.4597142339, blue: 0.7358804345, alpha: 1)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor // Clearing textField's borders
        textView.layer.borderColor = UIColor.lightGray.cgColor //Getting back to gray borders
    }
    
}

//MARK: - ZadatVoprosQuestionDataManagerDelegate

extension ZadatVoprosViewController : ZadatVoprosQuestionDataManagerDelegate{
    
    func didFailWithError(error: String) {
        hideActivityIndicator()
        print(error)
    }
    
    
    func didGetQuestions(data: ZadatVoprosQuestionData) {
        DispatchQueue.main.async {
            self.questionArray = data.answer //Saving question to the array
            self.hideActivityIndicator() //Not "loding..." anymore
            self.questionsPickerView.reloadAllComponents() //Reloading our picker view
        }
    }
    
}

//MARK: - UIPickerView Stuff

extension ZadatVoprosViewController : UIPickerViewDataSource , UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return questionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Something here should happen when selecting rows
        
    }
    
    //Setting custom view as a row
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "", size: 17)
            pickerLabel?.textAlignment = .center
            pickerLabel?.text = questionArray[row].name
        }
        
        return pickerLabel!
        
    }
    
}

//MARK: - ObratnayaSvyazDataManagerDelegate

extension ZadatVoprosViewController : ObratnayaSvyazDataManagerDelegate{
    
    func didFailObratnayaSvyazWithError(error: String) {
        
        hideActivityIndicator()
        print(error)
        
    }
    
    
    func didGetAnswer(answer: ObratnayaSvyazData) {
        
        DispatchQueue.main.async {
            
            print("I GOT AN ASNWER")
            
            self.hideActivityIndicator()
            
            if answer.code != 200 {
                
                let alertController = UIAlertController(title: answer.errorText, message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                }
                
                alertController.addAction(action)
                
                self.present(alertController , animated: true , completion: nil)
                
                return
            }
            
            
            
            //Showing the result
            
            let alertController = UIAlertController(title: answer.answer, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            alertController.addAction(action)
            
            self.present(alertController , animated: true , completion: nil)
            
        }
        
    }
    
}
