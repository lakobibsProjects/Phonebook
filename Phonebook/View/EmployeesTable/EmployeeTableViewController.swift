//
//  EmployeeTableViewController.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UIViewController {
    private let vm = EmployeeTableViewModel()
    var employeeTableVMObserverId = 1   //EmployeeTableVMObserver
    private var content: Employee!
    private var hideKeyboardGR: UITapGestureRecognizer!
    
    @IBOutlet weak var employeSearchBar: UISearchBar!
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var loadEmployeesActivityIndicator: UIActivityIndicatorView!
    
    //MARK: Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.attach(self)
        
        employeSearchBar.delegate = self
        
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        employeeTableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "EmployeeTableViewCell")
        employeeTableView.rowHeight = 64
        
        loadEmployeesActivityIndicator.startAnimating()
        self.view.bringSubviewToFront(loadEmployeesActivityIndicator)
        
        hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    }
    
    override func viewWillLayoutSubviews() {
        employeeTableView.reloadData()
    }
    
    //MARK: Segueu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "employeeDescription" {
            let destination = segue.destination as! EmployeeCardViewController
            destination.vm = EmployeeCardViewModel(user: content)
        }
    }
    
    //MARK: Event handlers
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(hideKeyboardGR)
    }
}

//MARK: UITableViewDelegate & DataSource
extension EmployeeTableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeTableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        let employe =  vm.employees[indexPath.row]
        let name = employe.getFullName()
        let url = employe.picture.thumbnail
        cell.fillContent(photoUrl: url, name: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        content = vm.employees[row]
        self.performSegue(withIdentifier: "employeeDescription", sender: row)
    }
}

//MARK: UISearchBarDelegate
extension EmployeeTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(hideKeyboardGR)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            vm.restoreEmployees()
        } else{
            vm.employees = vm.employees.filter({(data: Employee) -> Bool in
                return data.getFullName().range(of: searchText, options: .caseInsensitive) != nil
            })
        }
        
        employeeTableView.reloadData()
    }
}

//MARK: EmployeeTableVMObserver
extension EmployeeTableViewController: EmployeeTableVMObserver{
    func updateEmployees(employees: [Employee]){
        DispatchQueue.main.async {
            self.employeeTableView.reloadData()
            self.loadEmployeesActivityIndicator.stopAnimating()
        }
    }
}
