//
//  UserDefaults.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/14/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
   
//    static func putArray(array: [Person]) {
//        let userDefaults = UserDefaults.standard
//            do{
//                let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
//                userDefaults.set(data, forKey: "persons")
//                userDefaults.synchronize()
//            } catch {
//                print("Something wrong")
//            }
//    }
//    
//    static func getArray() -> [Person]{
//        guard let data = UserDefaults.standard.object(forKey: "persons") else {
//             return []
//        }
//
//        do {
//            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as! [Person]
//        } catch {
//            return []
//        }
//       
//    }
    
    static func putDictionary(dictionary: [Character : [Person]]) {
        let userDefaults = UserDefaults.standard
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false)
            userDefaults.set(data, forKey: "groupedPersons")
            userDefaults.synchronize()
        } catch {
            print(error)
        }
    }
    
    static func getDictionary() -> [Character : [Person]]{
        guard let data = UserDefaults.standard.object(forKey: "groupedPersons") else {
            return [:]
        }
        
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as! [Character : [Person]]
        } catch {
            return [:]
        }
        
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
    
    static func getImage(fileName: String) -> UIImage? {
        do {
            guard let fullPath = getFullPath(to: fileName) else {return nil}
            let data = try Data(contentsOf: fullPath)
            return UIImage(data: data)
        } catch {
            print("Can't get data")
        }
        return nil
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
