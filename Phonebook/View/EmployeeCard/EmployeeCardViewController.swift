//
//  EmployeeCardViewController.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import MessageUI

class EmployeeCardViewController: UIViewController {
    var vm: EmployeeCardViewModel?
    var employeeCardVMObserverId = 1 //EmployeeCardVMObserver
    
    @IBOutlet weak var fullSizeImageView: UIView!
    @IBOutlet weak var fullSizeImage: UIImageView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //MARK: - Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm?.attach(self)
        
        let tapPhotoGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto(_:)))
        photoImageView.addGestureRecognizer(tapPhotoGestureRecognizer)
        photoImageView.isUserInteractionEnabled = true
        
        let tapFSPhotoGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFullSizePhoto(_:)))
        fullSizeImageView.addGestureRecognizer(tapFSPhotoGestureRecognizer)
        fullSizeImageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateEmployee()
    }
    
    //MARK: - Event handlers
    @IBAction func callButtonPressed(_ sender: Any) {
        vm?.call()
    }
    
    @IBAction func mailButtonPressed(_ sender: Any) {
        //TODO: move to VM
        if (canSendText()) {
            if let phone = vm?.phoneNumber{
                let messageVC = MFMessageComposeViewController()
                messageVC.body = "Enter a message details here"
                messageVC.recipients = [phone]
                messageVC.messageComposeDelegate = self
                self.present(messageVC, animated: true, completion: nil)
            }
        } else {
            let dialogMessage = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true)
        }
        
    }
    
    @objc private func didTapPhoto(_ sender: UITapGestureRecognizer) {
        fullSizeImageView.isHidden = false
    }
    
    @objc private func didTapFullSizePhoto(_ sender: UITapGestureRecognizer) {
        fullSizeImageView.isHidden = true
    }
}

//MARK: - MFMessageComposeViewControllerDelegate
extension EmployeeCardViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            print("Message failed")
        case .sent:
            print("Message was sent")
        default:
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
}

//MARK: - EmployeeCardVMObserver
extension EmployeeCardViewController: EmployeeCardVMObserver{
    func updateEmployee(){
        self.lastnameLabel.text = vm?.lastName
        self.emailLabel.text = vm?.email
        self.nameLabel.text = vm?.name
        self.phoneLabel.text = vm?.phoneNumber
        self.photoImageView.load(url: URL(string: vm!.photoUrl), plug: UIImage(named: "user"))
        self.fullSizeImage.load(url: URL(string: vm!.bigSizePhotoUrl), plug: UIImage(named: "user"))
    }
}
