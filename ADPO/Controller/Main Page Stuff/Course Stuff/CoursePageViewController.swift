//
//  CoursePageViewController.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 18.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import SDWebImage

class CoursePageViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    @IBOutlet weak var sectionsCollectionView: UICollectionView!
    @IBOutlet weak var nonSectionCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    var teacherImageURLString = String()
    var teacherName = String()
    var courseName = String()
    var courseId = String()
    var avatarImageUrlString = String()
    
    let token = UserDefaults.standard.string(forKey: "token")! //Getting token from User Defaults
    
    var activityIndicator = UIActivityIndicatorView()
    
    var courseModulesDataManager = CourseModulesDataManager()
    
    var sectionModules : [CourseModule] = []
    var nonSectionModules : [CourseModule] = []
    var selectedSectionModules : [CourseModule] = []
    var sectionNames : Array<String> = []
    
    
    var selectedModuleId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseModulesDataManager.delegate = self //Setting delegate
        
        courseNameLabel.text = courseName //Setting the courseNameLabel's value to the one we got from Main Page VC
        teacherNameLabel.text = teacherName //Setting the eacherNameLabel's value to the one we got from Main Page VC
        
        if let url = URL(string: avatarImageUrlString){
            avatarImage.sd_setImage(with: url, placeholderImage:nil) //Setting avatar image from url we got from main page vc
        }
        
        if let url = URL(string: teacherImageURLString){
            teacherImageView.sd_setImage(with:url, placeholderImage:nil) //Setting teacher image from url we got from main page vc
        }
        
        //Rounding edges
        teacherImageView.layer.cornerRadius = teacherImageView.bounds.size.width / 2
        teacherImageView.clipsToBounds = true
        
        
        //Setting up table view
        //        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UINib(nibName: "ExpandableCourseModulesListTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandableCourseModulesCell")
        
        //Getting modules
        courseModulesDataManager.getCourseModules(courseId: courseId, token: token) //Get modules from web
        
        showActivityIndicator()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavBar() //Setting naviagtion var and it's items
        
    }
    
    //MARK: - NavBar Stuff
    
    func setUpNavBar(){
        
        //Setting title view
        let titleView = UIImageView(image: UIImage(named: "smallLogoNotFull"))
        
        titleView.contentMode = .scaleAspectFit
        
        titleView.clipsToBounds = true
        
        titleView.frame = .init(x: 0, y: 0, width: 95, height: 30)
        
        navigationItem.titleView = titleView
        
        //Some updates to avatar image
        avatarImage.layer.cornerRadius = avatarImage.bounds.size.width / 2
        avatarImage.clipsToBounds = true
        
        avatarImage.backgroundColor = .lightGray
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        //Custom trasnsition
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: true) //Dismissing CoursePageVC
        
    }
    
    
    //MARK: - Activity Indicator Stuff
    
    func showActivityIndicator (shouldNotEnableUserInteraction : Bool = true) {
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        shouldNotEnableUserInteraction ? UIApplication.shared.beginIgnoringInteractionEvents() : nil
        
    }
    
    func hideActivityIndicator(){
        
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        
    }
    
    //MARK: - Section Data Functions
    
    func loadSelectedSectionItems(index : Int){
        
        selectedSectionModules.removeAll()
        
        for module in sectionModules{
            
            if module.section_name == sectionNames[index]{ //Checking to see if the section name of the module matches the selected one (Selected scrolling that blue collection view)
                
                selectedSectionModules.append(module)
                
            }
            
        }
        
        print(sectionNames[index])
        
        tableView.reloadData() //Reloading table view
        
    }
    
    
}
//MARK: - UICollectionView Stuff

extension CoursePageViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.restorationIdentifier != "nonSectionsCollectionView"{
            loadSelectedSectionItems(index: indexPath.row)
        }else{
            
            let module = nonSectionModules[indexPath.row] //Getting our current module
            
            let urlString = "https://sdo.adpo.edu.ru\(module.module_url)" //Url for module
            
            if let url = URL(string: urlString) {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let webVC = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
                
                self.present(webVC, animated: true ){ //Presenting webViewVC
                    
                    webVC.showActivityIndicator(shouldNotEnableUserInteraction: false) //Loading....
                    webVC.webView.load(URLRequest(url: url))//Loading module link to webView
                    
                }
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.restorationIdentifier != "nonSectionsCollectionView"{
            return sectionNames.count
        }
        
        return nonSectionModules.count //This is for that small collection view above
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.restorationIdentifier != "nonSectionsCollectionView"{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            //Just creating a cell from the one in storyboard that I have created and that has "cell" identifier
            
            if let label = cell.viewWithTag(10) as? UILabel {
                label.text = sectionNames[indexPath.row]
            }
            
            if let viewBG = cell.viewWithTag(100) {
                viewBG.layer.cornerRadius = 8 //Rounding our cell's edges )
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
        //Just creating a cell from the one in storyboard that I have created and that has "cell" identifier
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = nonSectionModules[indexPath.row].module_name
        }
        
        if let viewBG = cell.viewWithTag(100) {
            viewBG.layer.cornerRadius = 8 //Rounding our cell's edges )
        }
        
        if let imgView = cell.viewWithTag(1000) as? UIImageView{
            
            let urlString = "\(nonSectionModules[indexPath.row].module_icon)" //Get url for module icon
            
            if let url = URL(string: urlString ){
                
                imgView.sd_setImage(with: url, placeholderImage: nil)
                //imgView.load(url: url)
                
            }else{
                print("Error with imgView url for that little collection view")
            }
        }else{
            print("Error with imgView url for that little collection view")
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size //Getting our collection view's sizes
        
        if collectionView.restorationIdentifier != "nonSectionsCollectionView"{
            
            return CGSize(width: self.view.frame.size.width, height: size.height - 15) // Giving size to a cell
        }
        
        return CGSize(width: 30, height: 60) // Giving size to a cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        
        if collectionView.restorationIdentifier != "nonSectionsCollectionView"{
            
            if indexPath.row == 0 {
                collectionViewCountLabel.text = "1 из \(sectionNames.count)"
                loadSelectedSectionItems(index: 0)
                return
            }
            
            if indexPath.row == nonSectionModules.count - 1 {
                collectionViewCountLabel.text = "\(sectionNames.count) из \(sectionNames.count)"
                loadSelectedSectionItems(index: sectionNames.count - 1)
                return
            }
            
            collectionViewCountLabel.text = "\(indexPath.row + 1) из \(sectionNames.count)"
            loadSelectedSectionItems(index: indexPath.row)
        }
    }
    
}

//MARK: - CourseModulesDataManager Stuff

extension CoursePageViewController : CourseModulesDataManagerDelegate{
    
    func didGetCourseModulesData(data: CourseModulesData) {
        
        DispatchQueue.main.async {
            
            self.hideActivityIndicator()
            
            if data.code != 200{
                
                let alertController = UIAlertController(title: "Ошибка", message: data.errorText, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ок", style: .default) { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                }
                
                alertController.addAction(action)
                
                self.present(alertController,animated: true)
                
                return
            }
            
            self.courseNameLabel.text = data.answer[0].course_shortname
            
            let modules = data.answer[0].modules
            
            //            print("\(modules) MODULES")
            
            for module in modules{
                
                if module.section_name != "" {
                    
                    //Checking if the section name is already in the array , if not , we add it
                    if !self.sectionNames.contains(module.section_name){
                        self.sectionNames.append(module.section_name)
                    }
                    
                    self.sectionModules.append(module)
                    
                }else{
                    
                    self.nonSectionModules.append(module)
                    
                }
                
            }
            
            print("\(self.sectionModules) SECTION MODULES")
            print("\(self.sectionNames) SECTION NAMES")
            
            self.sectionsCollectionView.reloadData()
            self.tableView.reloadData()
            self.nonSectionCollectionView.reloadData()
            
            
        }
        
        
    }
    
    func didFailWithErrorCourseModulesData(error: String) {
        print("\(error) ERROR WITH CourseModulesData")
        hideActivityIndicator()
        fatalError()
    }
    
    
}


//MARK: - TableView Stuff
extension CoursePageViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSectionModules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCourseModulesCell", for: indexPath) as! ExpandableCourseModulesListTableViewCell
        
        cell.label.text = selectedSectionModules[indexPath.row].module_name
        
        let url = URL(string: selectedSectionModules[indexPath.row].module_icon)
        
        cell.iconImageView.sd_setImage(with: url!, placeholderImage: UIImage(systemName: "person"))
        //  cell.imageView!.load(url: url!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let module = selectedSectionModules[indexPath.row]
        
        if module.module_type == "gbooks"{
            
            selectedModuleId = module.module_id
            
            performSegue(withIdentifier: "goToBooks", sender: self)
            
            return
        }
        
        let urlString = "https://sdo.adpo.edu.ru\(module.module_url)"
        
        if let url = URL(string: urlString) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let webVC = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
            
            self.present(webVC, animated: true ){ //Presenting webViewVC
                
                webVC.showActivityIndicator(shouldNotEnableUserInteraction: false) //Loading....
                webVC.webView.load(URLRequest(url: url))//Loading module link to webView
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToBooks"{
            
            let destinationVC = segue.destination as! BookViewController
            
            if let safeSelectedModuleId = selectedModuleId{
                
                destinationVC.moduleCmid = safeSelectedModuleId
            }
        }
        
    }
    
}
