//
//  EmployeesRequestManager.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

class EmployeesRequestManager: DownloadEmployeesObservable{
    var downloadEmployeesObservers = [DownloadEmployeesObserver]()
    private let url = URL(string: "https://randomuser.me/api?results=1000")!
    
    ///Download array of employees
    func loadEmployees(completion: @escaping ([Employee], Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            var users = [Employee]()
            if let data = data{
                do {
                    let result = try JSONDecoder().decode(EmployeesList.self, from: data)
                    
                    users = result.employees
                    self.notifyDownloadEmployeesObservable(employees: result)
                } catch {
                    print(error)
                }
                
                if let error = error {
                    print(error)
                }
            }
            
            completion(users, error)
        }
        task.resume()
    }
}

protocol DownloadEmployeesObservable: AnyObject{
    var downloadEmployeesObservers: [DownloadEmployeesObserver] {get set}
    
    func attach(_ observer: DownloadEmployeesObserver)
    
    func detach(_ observer: DownloadEmployeesObserver)
    
    func notifyDownloadEmployeesObservable(employees: EmployeesList)
}

extension DownloadEmployeesObservable{
    func attach(_ observer: DownloadEmployeesObserver) {
        downloadEmployeesObservers.append(observer)
    }
    
    func detach(_ observer: DownloadEmployeesObserver) {
        downloadEmployeesObservers = downloadEmployeesObservers.filter({$0.downloadEmployeesObserverId != observer.downloadEmployeesObserverId})
    }
    
    func notifyDownloadEmployeesObservable(employees: EmployeesList) {
        downloadEmployeesObservers.forEach({ $0.updateEmployees(employees: employees)
        })
    }
}

protocol DownloadEmployeesObserver{
    var downloadEmployeesObserverId : Int { get }
    func updateEmployees(employees: EmployeesList)
}

