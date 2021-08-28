//
//  View Extensions.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 01.09.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

extension  UIImageView{
    func load(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
