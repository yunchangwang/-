//
//  CommonChart.swift
//  中风康复训练
//
//  Created by wyc on 16/9/25.
//  Copyright © 2016年 wyc. All rights reserved.
//

import Foundation

class CommonChart {
    var lineChart: LineChart!
    var xLabels:[String]=[]
    var list:NSArray!
    
    //获得plist文件的路径
    internal func getplist_path(plist_name:String)->String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as NSString
        let filePath=documentPath.stringByAppendingPathComponent(plist_name)
        return filePath
    }

}