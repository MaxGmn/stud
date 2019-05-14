//
//  UserDefaults.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/14/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsWorking {
   
    static func putArray(array: [Person]) {
        let userDefaults = UserDefaults.standard
            do{
                let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
                userDefaults.set(data, forKey: "persons")
                userDefaults.synchronize()
            } catch {
                print("Something wrong")
            }
    }
    
    static func getArray() -> [Person]{
        guard let data = UserDefaults.standard.object(forKey: "persons") else {
             return []
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [Person]
//        return NSKeyedUnarchiver.unarchivedObject(ofClasses: [Person as AnyClass], from: data as! Data) as! [Person]
       
    }
    
    static func saveImage (by imageState: ImageEditState, name: String) {
        
        switch imageState {
        case .noChanges:
            return
        case .removed:
            removeFile(fileName: name)
        case .changed(let image):
            createFile(fileName: name, image: image)
        }
    }
    
    static func getImage(fileName: String) -> UIImage {
        do {
            guard let fullPath = getFullPath(to: fileName) else {return Constants.emptyAvatar}
            let data = try Data(contentsOf: fullPath)
            return UIImage(data: data) ?? Constants.emptyAvatar
        } catch {
            print("Can't get data")
        }
        return Constants.emptyAvatar
    }
    
    
    
    private static func removeFile(fileName: String) {       
        do {
            guard let fullPath = getFullPath(to: fileName) else {return}
            let fileManager = FileManager.default
            try fileManager.removeItem(at: fullPath)
        } catch {
            print("File \(fileName).jpeg is not deleted")
        }
    }
    
    
    private static func createFile(fileName: String, image: UIImage) {
        do {
            guard let fullPath = getFullPath(to: fileName) else {return}
            let data = image.jpegData(compressionQuality: 0.5)
            try data?.write(to: fullPath)
        } catch {
            print("File \(fileName).jpeg is not created")
        }
    }
    
    private static func getFullPath(to fileName: String) -> URL? {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fullPath = documentsDirectory.appendingPathComponent(fileName + ".jpeg")
            return fullPath
        } catch {
            print("Directory is not exist")
        }
        return nil
    }
}
