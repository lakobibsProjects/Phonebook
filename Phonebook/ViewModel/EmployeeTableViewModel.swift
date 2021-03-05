//
//  EmployeeTableViewModel.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

class EmployeeTableViewModel: DownloadEmployeesObserver, EmployeeTableVMObservable{
    internal var employeeTableVMObservers = [EmployeeTableVMObserver]()
    private var employeesRequestManager = EmployeesRequestManager()
    private var allEmployees: [Employee] = []
    
    var downloadEmployeesObserverId: Int = 1
    var employees: [Employee] = []
    
    init(){
        employeesRequestManager.attach(self)
        employeesRequestManager.loadEmployees(completion: { data, error in
            self.employees = data
            
            if let error = error{
                print(error.localizedDescription)
            }
        })
    }
    //DownloadEmployeesObserver func
    func updateEmployees(employees: EmployeesList) {
        self.employees = employees.employees
        allEmployees = employees.employees
        notifyEmployeeTableVMObservable(employees: employees.employees)
    }
    
    ///Return short inso about employee for cell
    ///
    /// - Parameters:
    ///             - id: id of employee
    /// - Returns:
    ///          - name: full name of employee
    ///          - photoUrl: url of thumbnail photo
    func getEmployeeInfo(by id: Int) -> (name: String, photoUrl: String){
        return (employees[id].getFullName(), employees[id].picture.thumbnail)
    }
    
    ///Resotore full array of employees
    func restoreEmployees(){
        employees = allEmployees
        notifyEmployeeTableVMObservable(employees: allEmployees)
    }
}


protocol EmployeeTableVMObservable: AnyObject{
    var employeeTableVMObservers: [EmployeeTableVMObserver] {get set}
    
    func attach(_ observer: EmployeeTableVMObserver)
    
    func detach(_ observer: EmployeeTableVMObserver)
    
    func notifyEmployeeTableVMObservable(employees: [Employee])
}

extension EmployeeTableVMObservable{
    func attach(_ observer: EmployeeTableVMObserver) {
        employeeTableVMObservers.append(observer)
    }
    
    func detach(_ observer: EmployeeTableVMObserver) {
        employeeTableVMObservers = employeeTableVMObservers.filter({$0.employeeTableVMObserverId != observer.employeeTableVMObserverId})
    }
    
    func notifyEmployeeTableVMObservable(employees: [Employee]) {
        employeeTableVMObservers.forEach({ $0.updateEmployees(employees: employees)
        })
    }
}

protocol EmployeeTableVMObserver{
    var employeeTableVMObserverId : Int { get }
    func updateEmployees(employees: [Employee])
}

