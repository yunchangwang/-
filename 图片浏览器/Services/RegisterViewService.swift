//
//  RegisterViewService.swift
//  中风康复训练
//
//  Created by wyc on 16/4/16.
//  Copyright © 2016年 wyc. All rights reserved.
//

import Foundation

class RegisterViewService{
    internal func register_user(user:UserModel)->String{
        var check_type:String=""
        //1.创建一个url
        let request=NSMutableURLRequest(URL:NSURL(string: "http://wyc19941128.6655.la:29503/IOSServer/test2")!)
        let params=["username":user.getUser_name(),"password":user.getPassword()] as Dictionary<String,String>
        request.HTTPMethod="POST"
        //2.给服务器传递json
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        }catch{
            print("exception")
        }
        //3.这里要设置格式
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session=NSURLSession.sharedSession()
        let semaphore=dispatch_semaphore_create(0)
        
        let task=session.dataTaskWithRequest(request, completionHandler:{(data,response,error)->Void in
            if error != nil{
                check_type="resume_error"
            }else{
                let strData=NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(strData)
                
                do{
                    if let json=try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
                        check_type=(json["type"] as? String)!
                    }else{
                        check_type="nojson_error"
                    }
                }catch{
                    check_type="parse_error"
                }
            }
            dispatch_semaphore_signal(semaphore)
        })
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return check_type
    }
}