//
//  ImageTableViewCell.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/21/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var person: Person!
    let picker = UIImagePickerController()
    
    func setContent(_ cellType: CellType) {
        switch cellType {
        case .image(let data):
            updateCellData(presentation: data)
        default:
            break
        }
    }
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        addImagePicker()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        imageTapAction()
        
       
        // Configure the view for the selected state
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
