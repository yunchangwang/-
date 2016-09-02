//
//  LoginViewService.swift
//  中风康复训练
//
//  Created by wyc on 16/4/16.
//  Copyright © 2016年 wyc. All rights reserved.
//

import Foundation

class LoginViewService{
    internal func check_user(user:UserModel)->String{
        var check_type:String=""
        //1.创建一个url
        let request=NSMutableURLRequest(URL:NSURL(string: "http://wyc19941128.6655.la:29503/IOSServer/test")!)
        //2.设置request的相关属性
        request.HTTPMethod="POST"
        request.HTTPBody=NSString(string:"name=\(user.getUser_name())&password=\(user.getPassword())").dataUsingEncoding(NSUTF8StringEncoding)
        //3.得到session
        let session=NSURLSession.sharedSession()
        //4.设置信号量，完成同步机制
        let semaphore = dispatch_semaphore_create(0)
        //5.设置任务以及返回机制
        let task=session.dataTaskWithRequest(request, completionHandler: {(data,response,error)->Void in
            if error != nil{
                check_type="网络连接出错"
            }else{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        check_type=(json["type"] as? String)!
                        //记录用户的信息
                        if check_type=="success"{
                            let user_id:String=(json["user_id"] as? String)!
                            self.recoder_user(user_id, user: user)
                        }
                    } else {
                        check_type="消息发送出错"
                    }
                }catch{
                    check_type="回送消息解析出错"
                }
            }
            //撤销信号量
            dispatch_semaphore_signal(semaphore)
        })
        //6.提交任务
        task.resume()
        //7.无限等待直到撤销信号量
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        //8.返回验证的值
        return check_type
    }
    
    private func recoder_user(user_id:String,user:UserModel){
        //得到user.plist文件的路径
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as NSString
        let filePath=documentPath.stringByAppendingPathComponent("user.plist")
        print(filePath)
        //判断文件是否存在，不存在则创建
        if(!NSFileManager.defaultManager().fileExistsAtPath(filePath)){
            //创建文件
            NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
        }
        //将用户信息写入
        let dictionary:NSDictionary=["user_id":user_id,"user_name":user.getUser_name(),"password":user.getPassword()]
        dictionary.writeToFile(filePath, atomically: true)
    }
}