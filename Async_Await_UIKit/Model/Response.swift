//
//  Response.swift
//  Async_Await_UIKit
//
//  Created by Dorra Ben Abdelwahed on 5/5/2022.
//

import Foundation

struct Response: Codable{
    
    let total: Int
    let total_pages: Int
    let results: [Photos]
    
}
