//
//  String+Ex.swift
//  MyApp
//
//  Created by Cuc Nguyen on 2/21/17.
//  Copyright © 2017 Kuccu. All rights reserved.
//

import Foundation
import MobileCoreServices

extension String{
    func mimeType() -> String {
        let url = NSURL(fileURLWithPath: self)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
}
