//
//  UserModel.swift
//  中风康复训练
//
//  Created by wyc on 16/4/16.
//  Copyright © 2016年 wyc. All rights reserved.
//

import Foundation

class UserModel{
    private var user_name:String!
    private var password:String!
    
    internal func setUser_name(user_name:String){
        self.user_name=user_name
    }
    internal func setPassword(password:String){
        self.password=password
    }
    internal func getUser_name(_:Void)->String{
        return self.user_name
    }
    internal func getPassword(_:Void)->String{
        return self.password
    }
}