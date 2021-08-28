//
//  BookViewController.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 02.09.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import SDWebImage

class BookViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var pagePickerView : UIPickerView!
    
    @IBOutlet weak var currentPageLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var moduleCmid = String()
    
    var page = Int()
    
    var gbooksData :GbookDataAnswer?
    
    var gBookDataManager = GbookDataManager()
    
    let token = UserDefaults.standard.string(forKey: "token")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        currentPageLabel.text = "0 из 0"
        
        pagePickerView.delegate = self
        pagePickerView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        page = 0
        
        gBookDataManager.delegate = self
        
        gBookDataManager.getBooksData(token: token!, cmid: moduleCmid)
    }
    
    //MARK: - Actions
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        
        page += 1
        
        collectionView.scrollToItem(at: IndexPath(row: page , section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        
        page -= 1
        
        collectionView.scrollToItem(at: IndexPath(row: page , section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
}

//MARK: - UICollectionView Stuff
extension BookViewController : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath)
        
        if let imageView = cell.viewWithTag(1) as? UIImageView{
            
            imageView.backgroundColor = .white
            
            imageView.contentMode = .scaleAspectFit
            
            let urlString = gbooksData?.pages[indexPath.row].url ?? ""
            
            if let url = URL(string: urlString){
                
                imageView.load(url: url)
            }
            
        }
        
        if let scrollView = cell.viewWithTag(11) as? UIScrollView {
            scrollView.maximumZoomScale = 6
            scrollView.minimumZoomScale = 1
            
            scrollView.delegate = self
            scrollView.zoomScale = 1
        }
        
        return cell
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize = collectionView.frame
        
        return CGSize(width: collectionViewSize.width, height: collectionViewSize.height - 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if gbooksData == nil{return}
        
        if indexPath.row == 0 {
            currentPageLabel.text = "1 из \(gbooksData!.pages.count)"
            
            return
        }
        
        if indexPath.row == gbooksData!.pages.count - 1 {
            currentPageLabel.text = "\(gbooksData!.pages.count) из \(gbooksData!.pages.count)"
            
            return
        }
        
        currentPageLabel.text = "\(indexPath.row + 1) из \(gbooksData!.pages.count)"
        
        page = indexPath.row
    }
    
}

//MARK: - UIPickerView Stuff
extension BookViewController : UIPickerViewDelegate , UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return gbooksData?.pages.count ?? 0
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if gbooksData == nil {
            return ""
            
        }
        
        return "\(gbooksData!.pages[row].num)"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredHorizontally, animated: true)
        
        page = row
    }
    
}

//MARK: - GbookDataManagerDelegate Stuff

extension BookViewController : GbookDataManagerDelegate {
    
    func didgetBooksData(data: GbookData) {
        
        DispatchQueue.main.async {
            if data.code != 200 {
                
                return
            }
            
            self.gbooksData = data.answer[0]
            
            self.nameLabel.text = data.answer[0].name
            
            self.pagePickerView.reloadAllComponents()
            self.collectionView.reloadData()
        }
        
        
    }
    
    func didFailGettingGbookDataWithError(error: String) {
        print(error)
    }
    
}
