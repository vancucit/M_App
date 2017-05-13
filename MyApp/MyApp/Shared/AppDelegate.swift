//
//  AppDelegate.swift
//  MyApp
//
//  Created by Cuc Nguyen on 4/7/15.
//  Copyright (c) 2015 Kuccu. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCrash
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController:MMDrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
//        FIRApp.configure()

        FIRCrashMessage("Cause Crash button clicked")
//        fatalError()
//        FIRApp.configure(with: <#T##FIROptions#>)
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //  return [[FBSDKApplicationDelegate sharedInstance] application:application
//        openURL:url
//        sourceApplication:sourceApplication
//        annotation:annotation];
        let parseURL = BFURL(inboundURL: url, sourceApplication: sourceApplication)
        if (parseURL?.appLinkData != nil) {
//            var targetUrl  = parseURL?.targetURL
//            let alertView = UIAlertView(title: NSLocalizedString("Success", comment: "APIerror"), message: NSLocalizedString("GeneralErrorMessage", comment: "APIerror"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
//            alertView.show()
            
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func showLoginViewController(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil);
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
        self.window?.rootViewController = loginVC
    }
    func goToMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let leftMenuVC = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewControllerID") as! LeftMenuViewController
        
        let navLeftVC = UINavigationController(rootViewController: leftMenuVC)
        let newVC = storyboard.instantiateViewController(withIdentifier: "NewsViewControllerID") as! NewsViewController
        newVC.currentNewFeedType = NewsType.News
        let navNewVC = UINavigationController(rootViewController: newVC)
        
        drawerController = MMDrawerController(center: navNewVC, leftDrawerViewController: navLeftVC)
        
        drawerController?.openDrawerGestureModeMask = .all
        drawerController?.closeDrawerGestureModeMask = .all
        self.window?.rootViewController = drawerController
        
    }

}

