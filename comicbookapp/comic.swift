//
//  comic.swift
//  comicbookapp
//
//  Created by joed lara, caesar shia on 5/30/17.
//  Copyright © 2017 Code School. All rights reserved.
//

import UIKit

class comic {
    
    var name: String
    var description: String
    var deck: String
    var issue_number: String
    var cover_date: String
    var store_date: String
    var image: String
    

    
    
    
    init(d: String, n: String, RD: String, SD: String, issue: String, dd: String, IMG: String) {
        name = n
        description = d
        deck = dd
        issue_number = issue
        cover_date = RD
        store_date = SD
        image = IMG
    }
    
    
    
    
    
    
    
    
    
    
}
