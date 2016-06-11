//
//  LoginViewService.swift
//  中风康复训练
//
//  Created by wyc on 16/4/16.
//  Copyright © 2016年 wyc. All rights reserved.
//

import Foundation

class LoginViewService{
    
    //外部类
    var document_service:DocumentService!
    
    internal func check_user(user:UserModel,type:String)->String{
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
                check_type="resume_error"
            }else{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        check_type=(json["type"] as? String)!
                        //记录用户的信息
                        if check_type=="success"{
                            let user_id:String=(json["user_id"] as? String)!
                            if type=="Line"{
                                self.recoder_user(user_id, user: user)
                            }else{
                                self.recoder_user_off(user_id, user: user)
                            }
                        }
                    } else {
                        check_type="nojson_error"
                    }
                }catch{
                    check_type="parse_error"
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
    //在线保存用户信息
    private func recoder_user(user_id:String,user:UserModel){
        //加载外部类
        self.document_service=DocumentService()
        //创建联机所需的文件夹
        self.document_service.create_dir("Line User")
        //得到user.plist文件的路径
        let fileName="Line User/"+user.getUser_name()+".plist"
        let filePath=self.document_service.create_plist(fileName)
        //将用户信息写入
        let dictionary:NSDictionary=["user_id":user_id,"user_name":user.getUser_name(),"password":user.getPassword()]
        dictionary.writeToFile(filePath, atomically: true)
    }
    //离线是保存用户信息
    private func recoder_user_off(user_id:String,user:UserModel){
        //加载外部类
        self.document_service=DocumentService()
        //得到user.plist文件的路径
        let fileName="Off User/"+user.getUser_name()+".plist"
        let filePath=self.document_service.getplist_path(fileName)
        //将用户信息写入
        let dictionary:NSDictionary=["user_id":user_id,"user_name":user.getUser_name(),"password":user.getPassword()]
        dictionary.writeToFile(filePath, atomically: true)
    }
}