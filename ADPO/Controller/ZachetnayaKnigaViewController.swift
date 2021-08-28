//
//  ZachetnayaKnigaViewController.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 26.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import RealmSwift

class ZachetnayaKnigaViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var programsCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopView: UIView!
    
    @IBOutlet weak var collectionViewCountLabel: UILabel!
    
    let realm = try! Realm()
    
    var learningProgramsArray : Results<LearningProgram>?
    
    var selectedProgramGrades : List<Grade>?
    
    var grades : Results<ProgramGrade>?
    
    var zachotnayaKnigaDataManager = ZachotnayaKnigaDataManager()
    
    var userDataManager = UserDataManager()
    
    let token = UserDefaults.standard.string(forKey: "token")
    
    let activityIndicator = UIActivityIndicatorView()
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPrograms()
        
        zachotnayaKnigaDataManager.delegate = self
        
        if networkManager.internetIsReachable(){
            
            zachotnayaKnigaDataManager.getWebinarData(token: token!)
            
            userDataManager.getUserData(token: token!)
            
            showActivityIndicator()
            
        }else{
            
            
            self.showNoInternet()
            
            loadGrades()
            
            
        }
        tableView.allowsSelection = false
        
        userDataManager.delegate = self
        
        tableViewTopView.layer.cornerRadius = 12
        
        tableView.rowHeight = 85
        
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
    
    
    //MARK: - Data Manipulation Methods
    
    func loadPrograms (){
        
        let programs = realm.objects(LearningProgram.self)//Getting all LearningProgram objects that our Realm DB has
        
        learningProgramsArray = programs //Saving all that objects to learningProgramsArray
        
        programsCollectionView.reloadData() //Reloading collectionView
    }
    
    func loadGrades(){
        
        let gradesFromDB = realm.objects(ProgramGrade.self)//Getting all ProgramGrade objects that our Realm DB has
        
        if !gradesFromDB.isEmpty{
            grades = gradesFromDB //Saving all that objects to learningProgramsArray
        }
        
    }
    
    func loadGradesFor(_ programId : String){
        
        if programId == "no id"{return}
        
        if let selectedProgramGradeObjectsFromDB = grades?.filter("programId LIKE %@", programId){ //Searching for grade object for selected program
            
            selectedProgramGrades = selectedProgramGradeObjectsFromDB[0].program_grades //Passing that data to this variable
            
            tableView.reloadData()
        }
    }
    
}
//MARK: - UICollectionView Stuff

extension ZachetnayaKnigaViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadGradesFor(learningProgramsArray?[indexPath.row].id ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return learningProgramsArray?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //Just creating a cell from the one in storyboard that I have created and that has "cell" identifier
        
        if let label = cell.viewWithTag(10) as? UILabel {
            label.text = learningProgramsArray?[indexPath.row].name ?? "Нет программ"
        }
        
        if let viewBG = cell.viewWithTag(100) {
            viewBG.layer.cornerRadius = 8 //Rounding our cell's edges )
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size //Getting our collection view's sizes
        
        return CGSize(width: self.view.frame.size.width, height: size.height - 15) // Giving size to a cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if learningProgramsArray == nil {return}
        
        if indexPath.row == 0 {
            
              collectionViewCountLabel.text = "1 из \(learningProgramsArray!.count)"
            
            loadGradesFor(learningProgramsArray?[0].id ?? "no id")
            
            return
        }
        
        if indexPath.row == learningProgramsArray!.count - 1 {
              collectionViewCountLabel.text = "\(learningProgramsArray!.count) из \(learningProgramsArray!.count)"
            
            loadGradesFor(learningProgramsArray!.last?.id ?? "no id")
            
            return
        }
        
         collectionViewCountLabel.text = "\(indexPath.row + 1) из \(learningProgramsArray!.count)"
        
        loadGradesFor(learningProgramsArray?[indexPath.row].id ?? "no id")
        
    }
    
}

//MARK: - ZachotnayaKnigaDataManagerDelegate Methods

extension ZachetnayaKnigaViewController : ZachotnayaKnigaDataManagerDelegate{
    
    func didGetZachotnayaKnigaData(data: ZachotnayaKnigaData) {
        
        DispatchQueue.main.async {
            
            
            if data.code != 200 {
                
                let alertController = UIAlertController(title: "Ошибка", message: data.errorText, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ок", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(action)
                
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            if let safeGrades = self.grades{
                
                //Deleting all the grades from db
                if (!safeGrades.isEmpty){
                    
                    for grade in self.grades!{
                        
                        self.realm.delete(grade)
                        
                    }
                    
                }
            }
            
            
            for programGrade in data.answer{
                
                let newProgramGrade = ProgramGrade() // Creating new Program Grade object
                
                //Setting arguments
                newProgramGrade.programId = programGrade.program_id
                newProgramGrade.programName = programGrade.program_name
                
                for grade in programGrade.program_grades{
                    
                    let newGrade = Grade() //Creating new Grade object
                    
                    //Setting arguments
                    newGrade.course_name = grade.course_name
                    newGrade.name = grade.name
                    newGrade.ball = grade.ball
                    newGrade.litter = grade.litter
                    
                    //Appenfing new grade to current program grade object
                    newProgramGrade.program_grades.append(newGrade)
                }
                
                do{
                    
                    try self.realm.write{
                        
                        //Adding new Program Grade object to Database
                        self.realm.add(newProgramGrade)
                    }
                    
                }catch{
                    //Error...
                    print("Error saving program grades to Realm DB , \(error)")
                }
                
            }
            
            //Loading all Program Grade objects for grades not to be nil
            self.loadGrades()
            
            // Loading first learning program's grades to the table view
            self.loadGradesFor(self.learningProgramsArray![0].id)
            
            self.tableView.reloadData() //Reloading table view...
            
            self.hideActivityIndicator()
            
        }
    }
    
    func didFailGettingZachotnayaKnigaDataWithError(error: String) {
        print(error)
    }
    
}

//MARK: - UITableView Stuff

extension ZachetnayaKnigaViewController :  UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProgramGrades?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "zachetCell",for: indexPath)
        
        //Checling if indexPath.row is even or not. And changing the cell color depending on that value 
        cell.backgroundColor = indexPath.row % 2 == 0 ? .white : #colorLiteral(red: 0.8973614573, green: 0.8974906802, blue: 0.8973332047, alpha: 1)
        
        if let courseNameLabel = cell.viewWithTag(1) as? UILabel{
            courseNameLabel.text = selectedProgramGrades?[indexPath.row].course_name ?? "Нет оценок"
        }
        
        if let nameLabel = cell.viewWithTag(2) as? UILabel{
            nameLabel.text = selectedProgramGrades?[indexPath.row].name ?? ""
        }
        
        if let litterLabel = cell.viewWithTag(3) as? UILabel{
            litterLabel.text = selectedProgramGrades?[indexPath.row].litter ?? ""
        }
        
        if let ballLabel = cell.viewWithTag(4) as? UILabel{
            ballLabel.text = selectedProgramGrades != nil ? "\(selectedProgramGrades![indexPath.row].ball)" : ""
        }
        
        cell.textLabel?.font = UIFont(name: "", size: 15) //Changing font size
        
        return cell
        
    }
    
    
}

//MARK: - UserDataManagerDelegate

extension ZachetnayaKnigaViewController : UserDataManagerDelegate{
    
    func didFailWithError(error: String) {
        print(error)
        
        print("ERROR WITH GETTING USER DATA")
    }
    
    
    func didGetUserData(data: UserData) {
        
        
        let avatarImageUrl = data.answer.avatar
        
        if let url = URL(string: avatarImageUrl){
            
            avatarImageView.sd_setImage(with: url, placeholderImage:nil)
            
        }
        
    }
    
}
