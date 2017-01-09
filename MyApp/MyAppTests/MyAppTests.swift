//
//  MyAppTests.swift
//  MyAppTests
//
//  Created by Cuc Nguyen on 4/7/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import XCTest

class MyAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    //end test1
    
    //test 2
    //        var err: NSError?
    //        let myURL = NSURL(string: getAbsoluteUrl("challenge/send"))!
    //        let request = NSMutableURLRequest(URL: myURL)
    //        var dataJson = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    //        request.HTTPMethod = "POST"
    //        request.HTTPBody = dataJson
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //
    ////        var jsonData = JSON()
    //        request.setValue(AuthToken.sharedInstance.authenticationToken, forHTTPHeaderField: "ServiceAuthToken")
    //        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
    //            print("Response: \(response)")
    //            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
    //            print("Body: \(strData)")
    //            var err: NSError?
    //            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
    //
    //            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
    //            if(err != nil) {
    //                print(err!.localizedDescription)
    //                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
    //                print("Error could not parse JSON: '\(jsonStr)'")
    //            }
    //            else {
    //                // The JSONObjectWithData constructor didn't return an error. But, we should still
    //                // check and make sure that json has a value using optional binding.
    //                if let parseJSON = json {
    //                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
    //                    var success = parseJSON["success"] as? Int
    //                    print("Succes: \(success)")
    //                }
    //                else {
    //                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
    //                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
    //                    print("Error could not parse JSON: \(jsonStr)")
    //                }
    //            }
    //        })
    //
    //        task.resume()
    
    //ednd test 2
    
    //test here 1
    //        let myURL = NSURL(string: getAbsoluteUrl("challenge/send"))!
    //        let request = NSMutableURLRequest(URL: myURL)
    //        request.HTTPMethod = "POST"
    //        request.setValue("application/json", forHTTPHeaderField: "Accept")
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        request.setValue(AuthToken.sharedInstance.authenticationToken, forHTTPHeaderField: "ServiceAuthToken")
    //
    //        let dataJson = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
    //        let stringJson = NSString(data: dataJson!, encoding: NSUTF8StringEncoding)
    //        request.HTTPBody = stringJson!.dataUsingEncoding(NSUTF8StringEncoding)
    //        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
    //            data, response, error in
    //            if (error == nil) {
    //                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
    //                print("strDat \(strData)")
    //                let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
    //               
    //                callback(true,nil)
    //            }
    //        }
    //        task.resume()
}
