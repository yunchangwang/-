//
//  ChartViewService.swift
//  中风康复训练
//
//  Created by wyc on 16/4/16.
//  Copyright © 2016年 wyc. All rights reserved.
//

import Foundation

class ChartViewService{
    internal func save_recoder(recoder:NSArray)->String{
        var check_type:String=""
        let request=NSMutableURLRequest(URL:NSURL(string: "http://wyc19941128.6655.la:29503/IOSServer/test3")!)
        request.HTTPMethod="POST"
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(recoder, options: [])
        }catch{
            print("exception")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session=NSURLSession.sharedSession()
        let semaphore=dispatch_semaphore_create(0)
        let task=session.dataTaskWithRequest(request, completionHandler: {(data,response,error)->Void in
            if error != nil{
                check_type="网络连接出错"
            }else{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        check_type = (json["type"] as? String)!
                    } else {
                        check_type="发送消息出错"
                    }
                }catch{
                    check_type="回送消息解析出错"
                }
            }
            dispatch_semaphore_signal(semaphore)
        })
        
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return check_type
    }

}
