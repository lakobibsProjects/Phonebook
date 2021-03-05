//
//  EmployeeTableViewCell.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    var photoImageView = UIImageView()
    var nameLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    ///Fill cell with info about employee
    ///
    /// - Parameters:
    ///             - photoUrl: url of thumbnail photo
    ///             - name: full name of employee
    func fillContent(photoUrl: String, name: String){
        setupView()
        nameLabel.text = name
        photoImageView.load(url: URL(string: photoUrl), plug: UIImage(named: "user"))
        
    }
    
    private func setupView(){
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2
        photoImageView.clipsToBounds = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //hierarchy of views
        self.addSubview(photoImageView)
        self.addSubview(nameLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints(){
        let leadingImageConstraint = photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0)
        let verticalImageConstraint = photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let widthImageConstraint = photoImageView.widthAnchor.constraint(equalToConstant: 48)
        let heightImageConstraint = photoImageView.heightAnchor.constraint(equalToConstant: 48)
        self.addConstraints([leadingImageConstraint, verticalImageConstraint, widthImageConstraint, heightImageConstraint])
        
        let leadingLabelConstraint = nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8.0)
        let trailingLabelConstraint = nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8.0)
        let verticalLabelConstraint = nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let heightLabelConstraint = nameLabel.heightAnchor.constraint(equalToConstant: 56)
        self.addConstraints([leadingLabelConstraint, trailingLabelConstraint, verticalLabelConstraint, heightLabelConstraint])
    }
}
