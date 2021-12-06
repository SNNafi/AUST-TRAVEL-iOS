//
//  PlistReader.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 6/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation

struct PlistReader {
    
    static func read(file name: String) -> [String: Any]? {
        var data: [String: Any]?
        if let infoPlistPath = Bundle.main.url(forResource: name, withExtension: "plist") {
            do {
                let plistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] {
                    data = dict
                }
            } catch {
                print(error)
                data =  nil
            }
        }
        return data
    }
}

