//  MainPageViewController.swift
//  ADPO
//  Created by Sam on 16.07.2020.
//  Copyright © 2020 Sam. All rights reserved.


//https://sdo.adpo.edu.ru/local/api/mobile.php?method=eduplan&salt=HGDGJHSJSJJSJ7777ssd&token=296cb3a0-8ff9-4d1d-a1af-71a9b1020add&id=0 - getting all stuff info

import UIKit
import SafariServices
import SDWebImage
import RealmSwift


class MainPageViewController: UIViewController , ProgramsListDataDelegate ,  UIViewControllerTransitioningDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var programsCollectionView: UICollectionView!
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    var mainPageDataManager = MainPageDataManager()
    var courseDataManager = CourseDataManager()
    var userDataManager = UserDataManager()
    
    var learningProgramsArray : Results<LearningProgram>!
    var coursesArray : Results<LearningCourse>?
    var selectedCoursesArray : Results<LearningCourse>!
    
    
    @IBOutlet weak var collectionViewCountLabel: UILabel!
    
    let token = UserDefaults.standard.string(forKey: "token") //Getting token from UserDefaults
    
    var avatarImageUrl = String()
    
    var arrSelect = [Bool]()
    
    let realm = try! Realm()
    
    let networkManager = NetworkManager() // An object of NetworkManager struct that I created for inet checking
    
    var courseSegueArguments : [String : String]? = [String : String]()
    
    //MARK: - View Controller's lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadPrograms()
        loadCourses()
        
        userDataManager.delegate = self
        mainPageDataManager.delegate = self
        courseDataManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //        print(token)
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UINib(nibName: "ExpnadableCourseListTableViewCell", bundle: nil), forCellReuseIdentifier: "CourseExpandableCell")
        
        collectionViewCountLabel.text = "1 из \(learningProgramsArray.count)"
        
        mainPageDataManager.getPrograms()
        userDataManager.getUserData(token: token!)
        
        showActivityIndicator()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavBar() //Setting naviagtion var and it's items
        
    }
    
    //MARK: - NavBar Stuff
    
    func setUpNavBar(){
        
        //Setting title View
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
    
    
    //MARK: - Segue Stuff
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCourse"{
            
            let destinationVC = segue.destination as! CoursePageViewController
            
            if let safeCourseSegueArguments = courseSegueArguments{
                
                
                destinationVC.teacherName = safeCourseSegueArguments["teacherName"]!
                
                destinationVC.teacherImageURLString = safeCourseSegueArguments["teacherImageURLString"]!
                
                destinationVC.courseName = safeCourseSegueArguments["courseName"]!
                
                destinationVC.courseId = safeCourseSegueArguments["courseId"]!
                
                destinationVC.avatarImageUrlString = safeCourseSegueArguments["avatarImageUrlString"]!
                
            }
        }
        
    }
    
    //MARK: - Avatar stuff
    
    
    @IBAction func avatarButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Хотите выйти?", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Да", style: .destructive) { (action) in
            
            self.dismiss(animated: true)//Dismisiing MainPageViewController
            
            UserDefaults.standard.set(nil, forKey: "token") //Setting nil for token
            
            self.deleteAllDataFromDB() //Deleting everything from Realm Data Base
            
        } //Dismissing the view and going back to login screen and deleting token (because its logout XD)
        
        let action2 = UIAlertAction(title: "Нет", style: .default) { (action) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        alertController.addAction(action)
        alertController.addAction(action2)
        
        present(alertController,animated: true,completion: nil)
    }
    
    //MARK: - Programs List Data Delegate Methods
    
    func didGetProgramsData(data: ProgramListData) {
        
        hideActivityIndicator()
        
        DispatchQueue.main.async {
            //            print(data)
            
            let programs = data.answer
            
            for program in programs{
                
                //Creating a new program from array element which we got from web
                let newProgram = LearningProgram()
                
                //Setting that new programs properties which we also get from the array element which got it's own prepoerties from web
                
                newProgram.name = program.name
                newProgram.id = program.id
                newProgram.isfacult = program.isfacult
                
                //Checking to see if that program has already been registred to DB. If yes , don't add it , but if no , we add it
                if (self.learningProgramsArray.filter("id LIKE %@", newProgram.id).count >= 1){
                    
                    self.courseDataManager.getCourses(token: self.token!)
                    
                    return
                }
                //print("\(self.learningProgramsArray.filter("id LIKE %@", newProgram.id)) FUCK FUCK ")
                do{
                    try self.realm.write{
                        self.realm.add(newProgram)
                    }
                }catch{
                    print("Error saving data to realm , \(error.localizedDescription)")
                }
            }
            
            self.programsCollectionView.reloadData()
            
            self.showActivityIndicator()
            self.courseDataManager.getCourses(token: self.token!) //Getting all courses
            
            
        }
        
        
    }
    
    func didFailWithError() {
        print("There was an error with fetching programs data")
        
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            
            if !self.networkManager.internetIsReachable(){
                self.showNoInternet()
                return
            }
            
            
            let alertController = UIAlertController(title: "Ошибка", message: "Не получается загрузить данные с сервера. Пожалуйста , вернитесь на экран авторизации", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .destructive) { (action) in
                
                UserDefaults.standard.set(nil, forKey: "token")
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(action)
            
            self.present(alertController, animated: true)
        }
        
    }
    
    
    //MARK: - Menu stuff
    let transition = SlideInTransition()
    
    func showMenu(){
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuTableViewController
        
        menuViewController.didTapMenuType = { menuType in
            
            switch menuType {
                
            case .uchebniyPlan:
                break
                
            case .electronnayaBiblioteka:
                
                self.performSegue(withIdentifier: "goToEB", sender: self)
                break
                
            case .zachetnayaKniga:
                
                self.performSegue(withIdentifier: "goToZachetka", sender: self)
                break
                
            default:
                break
            }
            
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        
        menuViewController.transitioningDelegate = self
        
        present(menuViewController, animated: true)
        
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        self.showMenu()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadPrograms (){
        
        let programs = realm.objects(LearningProgram.self)//Getting all LearningProgram object that our Realm DB has
        
        learningProgramsArray = programs //Saving all that objects to learningProgramsArray
        
        programsCollectionView.reloadData() //Reloading collectionView
    }
    
    func loadCourses (){
        
        let courses = realm.objects(LearningCourse.self)//Getting all LearningCourse object that our Realm DB has
        
        coursesArray = courses //Saving all that objects to courseArray
        
        if !learningProgramsArray.isEmpty{
            loadSelectedCourses(pid: learningProgramsArray.first!.id)
        }
    }
    
    func loadSelectedCourses(pid : String){
        //        if (self.learningProgramsArray.filter("id LIKE %@", newProgram.id).count >= 1){
        
        selectedCoursesArray = coursesArray?.filter("pid LIKE %@", pid)
        
        self.arrSelect = [Bool]()
        for _ in selectedCoursesArray {
            self.arrSelect.append(false)
        }
        
        tableView.reloadData()
        
    }
    
    func deleteAllDataFromDB(){
        
        //Deleting everything from DB
        do{
            
            try realm.write{
                realm.deleteAll()
            }
            
        }catch{
            print("Error with deleting all data from Realm , \(error) ERROR DELETING REALM")
        }
        
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
    
    
} //End of VC

//MARK: - UserDataManagerDelegate

extension MainPageViewController : UserDataManagerDelegate{
    
    func didGetUserData(data: UserData) {
        
        hideActivityIndicator()
        
        avatarImageUrl = data.answer.avatar
        
        if let url = URL(string: avatarImageUrl){
            
            avatarImageView.sd_setImage(with: url, placeholderImage:nil)
        }
    }
    
}

//MARK: - CourseListDataManagerDelegate Methods
extension MainPageViewController : CourseListDataDelegate {
    func didGetCourseData(data: CourseData) {
        
        DispatchQueue.main.async {
            
            self.hideActivityIndicator()
            
            let courses = data.answer
            
            for course in courses {
                
                let newCourse = LearningCourse()
                
                newCourse.available = course.available
                newCourse.courseid = course.courseid
                newCourse.iscompleted = course.iscompleted
                newCourse.name = course.name
                newCourse.pid = course.pid
                newCourse.url = course.url
                
                for teacher in course.teachers{
                    
                    let newTeacher = Teacher()
                    
                    newTeacher.firstname = teacher.firstname
                    newTeacher.lastname = teacher.lastname
                    newTeacher.id = teacher.id
                    newTeacher.pictureurl = teacher.pictureurl
                    
                    newCourse.teachers.append(newTeacher)
                    
                }
                
                for ifer in course.ifer{
                    
                    let newIfer = Ifer()
                    
                    newIfer.access = ifer.access
                    newIfer.name = ifer.name
                    
                    newCourse.ifer.append(newIfer)
                    
                }
                
                //Checking to see if that program has already been registred to DB. If yes , don't add it , but if no , we add it
                if let safeCoursesArray = self.coursesArray{
                    if (safeCoursesArray.filter("courseid LIKE %@", newCourse.courseid).count >= 1){
                        return
                    }
                    //print("\(self.learningProgramsArray.filter("id LIKE %@", newProgram.id)) FUCK FUCK ")
                    do{
                        try self.realm.write{
                            self.realm.add(newCourse)
                        }
                    }catch{
                        print("Error saving data to realm , \(error.localizedDescription)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.loadCourses()
                }
                
            }
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
}

//MARK: - UICollectionView Stuff

extension MainPageViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if token != nil {
            
            //showActivityIndicator()
            
            loadSelectedCourses(pid: learningProgramsArray[indexPath.row].id)
            // print("Collection View Cell pressed")
        }
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return learningProgramsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        //Just creating a cell from the one in storyboard that I have created and that has "cell" identifier
        
        if let label = cell.viewWithTag(10) as? UILabel {
            label.text = learningProgramsArray[indexPath.row].name //Setting label name. In the custom cell I made, there's a label , it has a tag of 10. So I use it to change it's value :)
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
        
        //showActivityIndicator(shouldNotEnableUserInteraction: false)
        
        
        
        if indexPath.row == 0 {
            collectionViewCountLabel.text = "1 из \(learningProgramsArray.count)"
            loadSelectedCourses(pid: learningProgramsArray[0].id)
            return
        }
        
        if indexPath.row == learningProgramsArray.count - 1 {
            collectionViewCountLabel.text = "\(learningProgramsArray.count) из \(learningProgramsArray.count)"
            loadSelectedCourses(pid: learningProgramsArray.last!.id)
            return
        }
        
        collectionViewCountLabel.text = "\(indexPath.row + 1) из \(learningProgramsArray.count)"
        loadSelectedCourses(pid: learningProgramsArray![indexPath.row].id)
        
    }
    
}

//MARK: - TableView Stuff
extension MainPageViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !learningProgramsArray.isEmpty ? selectedCoursesArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrSelect.count == 0 {return 270}
        return arrSelect[indexPath.row] ? 270 : 99
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseExpandableCell", for: indexPath) as! ExpnadableCourseListTableViewCell
        
        cell.openButton.tag = indexPath.row
        cell.openButton.addTarget(self, action: #selector(cellOpened(_:)), for: .touchUpInside)
        
        cell.voytinButton.tag = indexPath.row
        cell.voytinButton.addTarget(self, action: #selector(cellVoytiPressed(_:)), for: .touchUpInside)
        
        let course = selectedCoursesArray[indexPath.row]
        
        cell.nameLabel.text = course.name
        
        if course.available {
            cell.voytinButton.isEnabled = true
            cell.voytinButton.backgroundColor = #colorLiteral(red: 0.1465850472, green: 0.4723283648, blue: 0.7673965096, alpha: 1)
            cell.leadingLineView.backgroundColor = #colorLiteral(red: 0.5039151907, green: 0.7373083234, blue: 0.1494086087, alpha: 1)
            cell.voytiButtonURL =  "https://sdo.adpo.edu.ru\(course.url)"
        } else {
            cell.voytinButton.isEnabled = false
            cell.voytinButton.backgroundColor = .darkGray
            cell.leadingLineView.backgroundColor = #colorLiteral(red: 0.5031527877, green: 0.5032284856, blue: 0.503136158, alpha: 1)
        }
        
        for courseIfer in course.ifer{
            
            let uslovieImage = NSTextAttachment()
            
            //Checking for access and putting the needed image
            if courseIfer.access{
                uslovieImage.image = #imageLiteral(resourceName: "yes")
            }else{
                uslovieImage.image = #imageLiteral(resourceName: "no")
            }
            
            let image = NSAttributedString(attachment: uslovieImage)
            let text = NSAttributedString(string: "   \(courseIfer.name) \n")
            
            let imageText = NSMutableAttributedString(string: "") // This will containt both image and text
            
            imageText.append(image)
            imageText.append(text)
            
            cell.textView.attributedText = imageText
            
        }
        
        
        
        if arrSelect.count != 0{
            if arrSelect[indexPath.row] {
                UIView.animate(withDuration: 0.2) {
                    cell.openImage.transform = CGAffineTransform(rotationAngle: 3.14)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    cell.openImage.transform = .identity
                }
            }
        }
        
        if !course.teachers.isEmpty {
            let teacherFullname = course.teachers.first?.firstname
            
            if let indexOfSpace = teacherFullname?.firstIndex(of: String.Element(" ")) {
                if let teacherName = teacherFullname?.substring(to: indexOfSpace) ,
                    let teacherLastName = teacherFullname?.substring(from: indexOfSpace ) {
                    
                    cell.teacherLabel.text = "\(course.teachers.first!.lastname) \(teacherName.first!).\(teacherLastName.subscript(characterIndex: 1))"
                }
            } else {
                cell.teacherLabel.text = "\(course.teachers.first!.lastname)"
            }
            cell.teacherImage.sd_setImage(with: URL(string:"https://sdo.adpo.edu.ru\(course.teachers[0].pictureurl)"), placeholderImage:nil)
        }
        
        return cell
    }
    
    @IBAction func cellOpened(_ sender:UIButton) {
        for i in 0..<arrSelect.count {
            if i == sender.tag {
                arrSelect[i] = !arrSelect[i] //Opening or closing the cell 
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func cellVoytiPressed(_ sender : UIButton) {
        
        let course = selectedCoursesArray[sender.tag] //Getting the course for selected item
        
        //Setting all arguments for sharing it to course page vc via segue
        courseSegueArguments?["teacherName"] = "\(course.teachers[0].lastname) \(course.teachers[0].firstname)"
        courseSegueArguments?["teacherImageURLString"] = "https://sdo.adpo.edu.ru\(course.teachers[0].pictureurl)"
        courseSegueArguments?["courseName"] = course.name
        courseSegueArguments?["courseId"] = course.courseid
        courseSegueArguments?["avatarImageUrlString"] = avatarImageUrl
        
        self.performSegue(withIdentifier: "goToCourse", sender: self)
        
    }
    
}
