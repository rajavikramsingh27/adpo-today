//
//  Data Type Extensions.swift
//  ADPO
//
//  Created by Sam Yerznkyan on 01.09.2020.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

extension String {
    func `subscript`(characterIndex: Int) -> Self {
        return String(self[index(startIndex, offsetBy: characterIndex)])
    }
}
