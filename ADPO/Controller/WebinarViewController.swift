//
//  WebinarViewController.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 25.08.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class WebinarViewController: UIViewController {
    
    @IBOutlet weak var webinarImageView: UIImageView!
    @IBOutlet weak var webinarNameLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var topSmallView: UIView!
    @IBOutlet weak var bottomSmallView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var webinarDataManager = WebinarDataManager()
    
    var webinarVideoUrlString = String()
    
    let token = UserDefaults.standard.string(forKey: "token")
    
    var webinarId : String?
    var avatarImageUrl : String?
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webinarDataManager.delegate = self
        
        if let safeWebinarId = webinarId{
            
            webinarDataManager.getWebinarData(token: token!, webinarId: safeWebinarId)
            
        }
        
        if let safeImageUrl = avatarImageUrl{
            
            if let url = URL(string: safeImageUrl){
                
                avatarImageView.sd_setImage(with: url)
            }
            
        }
        
        topSmallView.addGradient(colors: [#colorLiteral(red: 0.9597807527, green: 0.9649797082, blue: 0.960365355, alpha: 1), .lightGray, #colorLiteral(red: 0.9597807527, green: 0.9649797082, blue: 0.960365355, alpha: 1)], locations: [0, 0.5, 1])
        bottomSmallView.addGradient(colors: [#colorLiteral(red: 0.9597807527, green: 0.9649797082, blue: 0.960365355, alpha: 1), .lightGray, #colorLiteral(red: 0.9597807527, green: 0.9649797082, blue: 0.960365355, alpha: 1)], locations: [0, 0.5, 1])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setUpNavBar()
    }
    
    //    MARK: - NavBar Stuff
    
    func setUpNavBar(){
        
        let titleView = UIImageView(image: UIImage(named: "smallLogoNotFull"))
        
        titleView.contentMode = .scaleAspectFit
        
        titleView.clipsToBounds = true
        
        titleView.frame = .init(x: 0, y: 0, width: 95, height: 30)
        
        navigationItem.titleView = titleView
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2
        avatarImageView.clipsToBounds = true
        
        avatarImageView.backgroundColor = .lightGray
        
    }
    
    //MARK: - Actions
    
    @IBAction func avatarButtonPressed(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true){
            
        }
        
    }
    
    @IBAction func webinarImagePressed(_ sender: UIButton) {
        
        playVideo()
        
    }
    
    func playVideo(){
        
        if let url = URL(string: webinarVideoUrlString){
            
            playerView = AVPlayer(url: url)
            
            playerViewController.player = playerView
            
            self.playerViewController.player?.play()
            
            present(playerViewController, animated: true, completion: nil)
            
        }
        
    }
    
    
    
}

extension WebinarViewController : WebinarDataManagerDelegate{
    
    func didGetWebinarData(data: WebinarData) {
        
        DispatchQueue.main.async {
            
            if data.code != 200{ //Showing error
                
                let alertController = UIAlertController(title: "Ошибка", message: data.errorText, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ок", style: .cancel) { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                return
            }
            
            let webinar = data.answer[0]
            
            self.webinarNameLabel.text = webinar.title
            
            if let safePoster = webinar.poster{
                if let webinarImageUrl = URL(string: safePoster) { //Putting webinar image to the "videoPlayer's" screen
                    self.webinarImageView.sd_setImage(with: webinarImageUrl)
                }
            }
            
            if let authorImageUrl = URL(string: webinar.author_pic){
                
                self.authorImageView.layer.cornerRadius = self.authorImageView.frame.width / 2
                self.authorImageView.clipsToBounds = true
                
                self.authorImageView.sd_setImage(with: authorImageUrl)
            }
            
            self.authorLabel.text = webinar.author
            
            self.textView.text = webinar.description
            
            self.webinarVideoUrlString = webinar.videohttps
            
        }
        
    }
    
    func didFailGettingWebinarDataWithError(error: String) {
        print("\(error) ERROR WITH GETTING WEBINAR DATA BY ID")
    }
    
}
