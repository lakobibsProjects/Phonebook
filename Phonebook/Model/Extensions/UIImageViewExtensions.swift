//
//  UIImageViewExtensions.swift
//  Phonebook
//
//  Created by user166683 on 3/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    ///Set image from network
    ///
    ///- Parameters:
    ///             - url: url of image
    func load(url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    ///Set image from network
    ///
    ///- Parameters:
    ///             - url: url of image
    ///             - plug: image that insert when download failed
    func load(url: URL?, plug: UIImage?) {
        if let url = url{
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }else {
            DispatchQueue.main.async {
                self.image = plug
            }
        }
        
    }
}
