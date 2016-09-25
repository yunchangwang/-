//
//  ViewController.swift
//  图片浏览器
//
//  Created by wyc on 16/4/6.
//  Copyright © 2016年 wyc. All rights reserved.
//

import UIKit

class MainViewController: CommonMainViewController {
    //休息按钮事件
    @IBAction internal override func break_action(sender: UIButton) {
//        super.break_action(<#T##sender: UIButton##UIButton#>)
        //1.隐藏休息按钮
        sender.hidden=true
        //2.隐藏所有的控件
        self.hidde_view()
        self.label_num.text="即将退出"
        self.start_btn.setTitle("请下次完成测试", forState: UIControlState.Normal)
        self.start_btn.enabled=false
        //3.将已经测试的纪录保存起来
        let filePath=self.getplist_path("recoder.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(filePath){
            NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
        }
        (self.recode_array as NSArray).writeToFile(filePath, atomically: true)
        //4.将测试的now_no保存起来
        //5.5秒后跳转到LoginViewController界面
        self.controller="LoginViewController"
        self.timer=NSTimer.scheduledTimerWithTimeInterval(5,target:self,selector: #selector(jump),userInfo:nil,repeats:true)
    }
    
    //同时判断本次测试和所有测试
    internal override func is_over(_:Void){
//        super.is_over(<#T##Void#>)
        //如果本次是最后一次那么结束，否则下一张
        if !self.is_end_test(){
            self.next()
        }
        //当是最后一次的时候记录结果
        if(self.now_no==self.end_no){
            let filePath=self.getplist_path("recoder.plist")
            if !NSFileManager.defaultManager().fileExistsAtPath(filePath){
                NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
            }
            (self.recode_array as NSArray).writeToFile(filePath, atomically: true)
            //隐藏休息按钮
            self.break_btn.hidden=true
            //跳到另一个页面处理报表，并且数据入库
            self.label_num.text="所有测试结束"
            self.start_btn.setTitle("后台正在处理", forState: UIControlState.Normal)
            self.start_btn.enabled=false
            //5秒后跳转到ChartViewController界面
            self.controller="ChartViewController"
            self.timer=NSTimer.scheduledTimerWithTimeInterval(5,target:self,selector: #selector(jump),userInfo:nil,repeats:true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //读出plist文件中的值，看是否有未完成的测试
        let filePath=self.getplist_path("recoder.plist")
        //判断该文件是否存在，如果存在读出数据
        if(NSFileManager.defaultManager().fileExistsAtPath(filePath)){
            let temp=NSArray(contentsOfFile: filePath)! as NSArray
            if(temp.count<5&&temp.count>0){
                self.now_no=self.now_no+temp.count
                //将纪录读出
                for i in 0..<temp.count{
                self.recode_array.append(temp[i] as! NSDictionary)
                }
                self.label_num.text="您还遗留\(5-temp.count)次测试"
                self.start_btn.setTitle("请继续上次测试", forState: UIControlState.Normal)
            }
        }else{
            //创建文件
            NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

