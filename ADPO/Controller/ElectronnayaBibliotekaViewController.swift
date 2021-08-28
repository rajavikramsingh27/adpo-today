//
//  ElectronnayaBibliotekaViewController.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 24.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import SDWebImage

class ElectronnayaBibliotekaViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var poiskTextField: UITextField!
    
    @IBOutlet weak var webinarsTableView: UITableView!
    
    var electronnayaBibliotekaDataManager = ElectronnayaBibliotekaDataManager()
    
    var webinars : [ElectronnayaBibliotekaDataAnswerWebinar] = []
    
    let token = UserDefaults.standard.string(forKey: "token")
    
    var avatarImageUrl = String()
    var selectedWebinarId = String()
    
    var userDataManager = UserDataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        electronnayaBibliotekaDataManager.delegate = self
        userDataManager.delegate = self
        
        electronnayaBibliotekaDataManager.getElectronnayaBibliotekaAnswer(token: token!)
        
        userDataManager.getUserData(token: token!)
        
        poiskTextField.delegate = self
        
        searchView.layer.cornerRadius = 12
        
        webinarsTableView.delegate = self
        webinarsTableView.dataSource = self
        
        //webinarsTableView.allowsSelection = false
        webinarsTableView.separatorStyle = .none
        webinarsTableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setUpNavBar()
    }
    
    //    MARK: - NavBar Stuff
    
    func setUpNavBar(){
        
        //Setting title
        let titleView = UIImageView(image: UIImage(named: "smallLogoNotFull"))
        
        titleView.contentMode = .scaleAspectFit
        
        titleView.clipsToBounds = true
        
        titleView.frame = .init(x: 0, y: 0, width: 95, height: 30)
        
        navigationItem.titleView = titleView
        
        //Rounding Avatar Image
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2
        avatarImageView.clipsToBounds = true
        
        avatarImageView.backgroundColor = .lightGray
        
        //Setting back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    //MARK: - Seague Stuff
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destionationVC = segue.destination as! WebinarViewController
        
        destionationVC.webinarId = selectedWebinarId
        destionationVC.avatarImageUrl = avatarImageUrl
    }
    
    //MARK: - Menu stuff
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    let transition = SlideInTransition()
    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuTableViewController
        
        menuViewController.didTapMenuType = { menuType in
            
            switch menuType {
                
            case .uchebniyPlan:
                self.dismiss(animated: false, completion: nil)
                
            case .electronnayaBiblioteka:
                
                break
                
            default:
                break
            }
            
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        
        menuViewController.transitioningDelegate = self
        
        present(menuViewController, animated: true)
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
    
}

//MARK: - UITextFieldDelegate Stuff

extension ElectronnayaBibliotekaViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Search here
        
        return true
        
    }
    
}

//MARK: - ElectronnayaBibliotekaDataManagerDelegate Methods

extension ElectronnayaBibliotekaViewController : ElectronnayaBibliotekaDataManagerDelegate{
    
    func didGetElectronnayaBibliotekaData(data: ElectronnayaBibliotekaData) {
        
        if data.code != 200 {
            
            let alertController = UIAlertController(title: "Ошибка", message: data.errorText, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ок", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(action)
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        DispatchQueue.main.async {
            
            self.webinars = data.answer[0].list // Getting webinars from answer from web
            
            self.webinarsTableView.reloadData() // Reloading collection view
            
        }
        
        
    }
    
    func didFailGettingElectronnayaBibliotekaDataWithError(error: String) {
        
        print(error)
        
    }
}

//MARK: - UITableView Methods

extension ElectronnayaBibliotekaViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return webinars.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "webinarCell", for: indexPath)
        
        if let label = cell.viewWithTag(1) as? UILabel{
            
            label.text = webinars[indexPath.row].title
            
        }
        
        if let imageView = cell.viewWithTag(10) as? UIImageView{
            
            
            if let safePoster = webinars[indexPath.row].poster{
                
                if let url = URL(string: safePoster){ //Url for this webinar
                    
                    imageView.sd_setImage(with: url, placeholderImage: nil) //Putting the image from web to this image view
                    
                    
                }
            }
        }
        
        
        
        if let bgView = cell.viewWithTag(1000){
            
            bgView.clipsToBounds = true // This is for the image view to not go out of borders of the view
            
            bgView.layer.cornerRadius = 12 //Rounding cells edges
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedWebinarId = webinars[indexPath.row].id
        
        self.performSegue(withIdentifier: "goToWebinar", sender: self)
        
    }
    
    
}



//MARK: - UserDataManagerDelegate

extension ElectronnayaBibliotekaViewController : UserDataManagerDelegate{
    
    func didFailWithError(error: String) {
        print(error)
        
        print("ERROR WITH GETTING USER DATA")
    }
    
    
    func didGetUserData(data: UserData) {
        
        //hideActivityIndicator()
        
        avatarImageUrl = data.answer.avatar
        
        if let url = URL(string: avatarImageUrl){
            
            avatarImageView.sd_setImage(with: url, placeholderImage:nil)
            
        }
    }
    
}
