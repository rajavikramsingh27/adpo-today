//
//  ExpnadableCourseListTableViewCell.swift
//  ADPO
//
//  Created by Sam on 22.07.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ExpnadableCourseListTableViewCell: UITableViewCell {
    
    var voytiButtonURL : String? = ""
    //    var cellExists : Bool = false
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var infoView: UIView!
    //        {
    //        didSet{
    //            infoView.isHidden = true
    //            infoView.alpha = 0
    //        }
    //    }
    
    @IBOutlet weak var leadingLineView: UIView!
    @IBOutlet weak var middleLineView: UIView!
    
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var openImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateUslovieLabel: UILabel!
    @IBOutlet weak var predidushiyUrokLabel: UILabel!
    
    @IBOutlet weak var dateUslovieImage: UIImageView!
    @IBOutlet weak var predidushiyUrokImage: UIImageView!
    
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var teacherImage: UIImageView!
    
    @IBOutlet weak var voytinButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        voytinButton.layer.cornerRadius = 10 //Rounding button
        
        
        // contentView.layer.cornerRadius = 8
        bottomView.layer.cornerRadius = 8
        topView.layer.cornerRadius = 8
        
        
        teacherImage.layer.cornerRadius = teacherImage.frame.size.width / 2
        teacherImage.clipsToBounds = true
        
        //Setting gradient color for login line
        middleLineView.addGradient(colors: [.white, .lightGray, .white], locations: [0, 0.4, 1])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //    func animate(duration : Double , c: @escaping () -> Void){
    //        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
    //            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration) {
    //
    //                self.infoView.isHidden = !self.infoView.isHidden
    //
    //                //Fade in effect
    //                if self.infoView.alpha == 1 {
    //                    self.infoView.alpha = 0.5
    //                } else {
    //                    self.infoView.alpha = 1
    //                }
    //            }
    //        }) { (finsihed : Bool) in
    //            //print("Animation Complete")
    //            c()
    //        }
    //    }
    
}
