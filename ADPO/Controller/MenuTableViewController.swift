//
//  MenuTableViewController.swift
//  ADPO
//
//  Created by Sam on 17.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit


enum MenuType: Int {
    case uchebniyPlan
    case electronnayaBiblioteka
    case zachetnayaKniga
}


class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fifthView: UIView!
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The addGradient code is in Login VC
        firstView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        secondView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        thirdView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        //        fourthView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        //        fifthView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue : indexPath.row) else {return}
        self.dismiss(animated: true){[weak self] in
            self?.didTapMenuType?(menuType)
        }
    }
    
}
