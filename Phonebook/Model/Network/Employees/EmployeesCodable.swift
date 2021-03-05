//
//  EmployeesCodable.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

// MARK: - EmployeesList
struct EmployeesList: Codable {
    let employees: [Employee]
    
    enum CodingKeys: String, CodingKey {
        case employees = "results"
    }
}

// MARK: - Employee
struct Employee: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    ///Combine title first name and last name
    ///
    /// - Returns: full name
    func getFullName() -> String{
        var result = ""
        
        if self.name.title != ""{
            result.append("\(name.title) ")
        }
        result.append("\(name.first) ")
        result.append(name.last)
        
        return result
    }
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
