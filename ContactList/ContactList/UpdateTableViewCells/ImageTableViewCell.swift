//
//  ImageTableViewCell.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/21/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var pictureImageView: UIImageView!
    
    func setContent(_ presentation: Presentation) {
        if presentation.cellType == .image {
            updateCellData(presentation: presentation)
        }
    }
    
}

private extension ImageTableViewCell {    
    func updateCellData(presentation: Presentation) {
        switch presentation.dataType {
        case .image(let image):
            pictureImageView.image = image ?? Constants.emptyAvatar
        default:
            break
        }
    }
}
