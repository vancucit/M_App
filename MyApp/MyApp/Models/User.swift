//
//  User.swift
//  PipeFish
//
//  Created by Cuccku on 10/20/14.
//  Copyright (c) 2014 ImageSourceInc,. All rights reserved.
//

import UIKit

let User_Token:String = "MAPP_User_Token"
let User_Name:String = "MAPP_User_Name"


class User: NSObject,NSCoding {
    class var shareInstance : User {
        
        struct Static {
            static let instance : User = User()
        }
        
        return Static.instance
    }
    
    var idUser = ""
    var nameUser: String = ""
    var avatar:String = ""
    var followerCount: Int = 0
    var followingCount: Int = 0
    var point:Int = 0
    var bio:String?
    var location:String?
    var webSite: String?
    var gender:String?
    var birthDate:String?
    
    var isPublic = false
    var isFollowing = false
    var isFollowwer = false    
    var currentRank:Int = 0
    var completedChallenges:Int = 0
    
    
    var jsonString:String?



    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        self.idUser = aDecoder.decodeObject(forKey: "id") as! String
        self.nameUser = aDecoder.decodeObject(forKey: "Name") as! String
        self.avatar = aDecoder.decodeObject(forKey: "imageUrl") as! String
        
        self.followerCount = aDecoder.decodeInteger(forKey: "Follower")
        self.followingCount = aDecoder.decodeInteger(forKey: "Following")
        self.point = aDecoder.decodeInteger(forKey: "Point")
        self.currentRank = aDecoder.decodeInteger(forKey: "CurrentRank")
        self.completedChallenges = aDecoder.decodeInteger(forKey: "CompletedChallenges")

        self.bio = aDecoder.decodeObject(forKey: "Bio") as? String
        self.location = aDecoder.decodeObject(forKey: "Location") as? String
        self.webSite = aDecoder.decodeObject(forKey: "Website") as? String
        self.birthDate = aDecoder.decodeObject(forKey: "Birthdate") as? String
        self.gender = aDecoder.decodeObject(forKey: "Gender") as? String
        self.isPublic = aDecoder.decodeBool(forKey: "IsPublic") as Bool
        self.isFollowwer = aDecoder.decodeBool(forKey: "IsFollowedByCurrentUser") as Bool
        self.isFollowing = aDecoder.decodeBool(forKey: "IsFollowerOfCurrentUser") as Bool
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode( self.idUser, forKey:"id" )
        aCoder.encode(  self.nameUser, forKey:"Name" )
        aCoder.encode(self.avatar, forKey: "imageUrl")
        aCoder.encode(self.followerCount, forKey: "Follower")
        aCoder.encode(self.followingCount, forKey: "Following")
        aCoder.encode(self.point, forKey: "Point")
        aCoder.encode(self.currentRank, forKey: "CurrentRank")
        aCoder.encode(self.completedChallenges, forKey: "CompletedChallenges")
        
        aCoder.encode(self.bio, forKey: "Bio")
        aCoder.encode(self.location, forKey: "Location")
        aCoder.encode(self.webSite, forKey: "Website")
        aCoder.encode(self.isPublic, forKey: "IsPublic")
        aCoder.encode(self.birthDate, forKey: "Birthdate")
        aCoder.encode(self.gender, forKey: "Gender")
        aCoder.encode(self.isFollowwer, forKey: "IsFollowedByCurrentUser")
        aCoder.encode(self.isFollowing, forKey: "IsFollowerOfCurrentUser")
    }
    
    
    convenience init(jsonDict:NSDictionary){
        self.init()
        //test
        //end test
//        self.idUser = jsonDict["id"].st
    
        self.setUserFromDic(jsonDict)
        
    }
   
    // 1=iPhone5orLower, 2=iPhone6, 3=iPhone6plus
    
    func isIphoneType(_ typePhone: Int)->Bool{
        if(typePhone == 1 && UIScreen.main.bounds.size.width == 320){
            return true
        }
        
        if(typePhone == 2 && UIScreen.main.bounds.size.width == 375){
            return true
        }
        
        if(typePhone == 3 && UIScreen.main.bounds.size.width == 414){
            return true
        }
        
        return false
    }
    
    func setUserFromDic( _ jsonDict:NSDictionary)->() {
        nameUser = jsonDict["firstName"] as! String
        idUser = jsonDict["email"] as! String
//        idUser = jsonDict["id"] as! String
//        nameUser = jsonDict["Name"] as! String
        avatar = jsonDict["imageUrl"] as! String
//        followerCount = jsonDict["Follower"] as! Int
//        followingCount = jsonDict["Following"] as! Int
//        point = jsonDict["Point"] as! Int
//        currentRank = jsonDict["CurrentRank"] as! Int
//        completedChallenges = jsonDict["CompletedChallenges"] as! Int
//        
//        bio = jsonDict["Bio"] as? String
//        location = jsonDict["Location"] as? String
//        webSite = jsonDict["Website"] as? String
//        isPublic = jsonDict["IsPublic"] as! Bool
//        
//        birthDate = jsonDict["Birthdate"] as? String
//        gender = jsonDict["Gender"] as? String
//        isFollowing = jsonDict["IsFollowedByCurrentUser"] as! Bool
//        isFollowwer = jsonDict["IsFollowerOfCurrentUser"] as! Bool
    }
    func toggleIsFollowedByCurrentUser(){
        if (isFollowing) {
            followerCount -= 1
        } else {
            followerCount += 1
        }
        isFollowing = !isFollowing
    }
    
    

}

//class function
extension User{
    
    class func saveToken(_ tokenString:String){
        UserDefaults.standard.set(tokenString, forKey: User_Token)
        UserDefaults.standard.synchronize()
    }
    
    class func getToken() -> String?{
        return UserDefaults.standard.object(forKey: User_Token) as? String
    }
    
    class func hasExistUser() -> Bool {
        if User.getToken() != nil {
            return !User.getToken()!.isEmpty
        }
        return false
    }
    

    
    class func getUserNameCache() -> String?{
        return UserDefaults.standard.object(forKey: User_Name) as? String
    }
    
    
    
    class func hasRememberUser() -> Bool {
        if User.getUserNameCache() != nil {
            return !User.getUserNameCache()!.isEmpty
        }
        return false
    }
    class func logOut(){
        User.saveToken("")
    }
    
}
