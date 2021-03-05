//
//  EmployeeCardViewModel.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class EmployeeCardViewModel: EmployeeCardVMObservable {
    var employeeCardVMObservers = [EmployeeCardVMObserver]()
    private var user: Employee
    var name: String
    var lastName: String
    var email: String
    var photoUrl: String
    var bigSizePhotoUrl: String
    var phoneNumber: String
    
    init(user: Employee) {
        self.user = user
        self.name = "Name: \(user.name.first)"
        self.lastName = "Lastname: \(user.name.last)"
        self.email = "E-mail: \(user.email)"
        self.photoUrl = user.picture.medium
        self.bigSizePhotoUrl = user.picture.large
        self.phoneNumber = "Phone: \(user.phone)"
        notifyEmployeeCardVMObservable()
    }
    
    ///Call employee phone
    func call(){
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)        
    }
}

protocol EmployeeCardVMObservable: AnyObject{
    var employeeCardVMObservers: [EmployeeCardVMObserver] {get set}
    
    func attach(_ observer: EmployeeCardVMObserver)
    
    func detach(_ observer: EmployeeCardVMObserver)
    
    func notifyEmployeeCardVMObservable()
}

extension EmployeeCardVMObservable{
    func attach(_ observer: EmployeeCardVMObserver) {
        employeeCardVMObservers.append(observer)
    }
    
    func detach(_ observer: EmployeeCardVMObserver) {
        employeeCardVMObservers = employeeCardVMObservers.filter({$0.employeeCardVMObserverId != observer.employeeCardVMObserverId})
    }
    
    func notifyEmployeeCardVMObservable() {
        employeeCardVMObservers.forEach({ $0.updateEmployee()
        })
    }
}

protocol EmployeeCardVMObserver{
    var employeeCardVMObserverId : Int { get }
    func updateEmployee()
}
