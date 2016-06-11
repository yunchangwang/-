//
//  DocumentService.swift
//  中风康复训练
//
//  Created by wyc on 16/5/15.
//  Copyright © 2016年 wyc. All rights reserved.
//

import Foundation

class DocumentService{
    //在document目录创建文件夹
    func create_dir(dir_name:String){
        let dir_path=self.getplist_path(dir_name)
        //判断文件夹是否存在，不存在则创建之
        if(!NSFileManager.defaultManager().fileExistsAtPath(dir_path)){
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(dir_path, withIntermediateDirectories: false, attributes: nil)
            }catch{
                print("文件夹创建失败")
            }
        }
    }
    //在相应的文件夹下创建plist文件
    func create_plist(plist_name:String)->String{
        let plist_path=self.getplist_path(plist_name)
        //如果文件不存在创建之
        if(!NSFileManager.defaultManager().fileExistsAtPath(plist_path)){
            NSFileManager.defaultManager().createFileAtPath(plist_path, contents: nil, attributes: nil)
        }
        return plist_path
    }
    
    //得到plist文件的路径
    func getplist_path(plist_name:String)->String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as NSString
        let filePath=documentPath.stringByAppendingPathComponent(plist_name)
        return filePath
    }
    //检查相关文件是否存在
    func check_exits(file_path:String)->Bool{
        let plist_path=self.getplist_path(file_path)
        if(NSFileManager.defaultManager().fileExistsAtPath(plist_path)){
            return true
        }else{
            return false
        }
    }
    //检查report中测试是否结束
    func check_report(file_path:String)->Bool{
        //先检查文件是否存在
        if !self.check_exits(file_path){
            return false
        }else{
            //查看是否测完
            let temp=NSArray(contentsOfFile: self.getplist_path(file_path))! as NSArray
            if temp.count==5{
                return true
            }else{
                return false
            }
        }
    }
}
