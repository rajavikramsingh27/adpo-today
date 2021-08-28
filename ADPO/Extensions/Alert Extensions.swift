//
//  Alert Extensions.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 01.09.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit



extension UIViewController {
    
    func showNoInternet(){
        
        let alertController = UIAlertController(title: "Ошибка", message: "Отсутствует подключение к интернету", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ок", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}


