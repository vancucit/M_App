//
//  Array-Extension.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/19/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

extension Array where Element: Equatable
{
    mutating func removeObject(object: Element) {
        
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

