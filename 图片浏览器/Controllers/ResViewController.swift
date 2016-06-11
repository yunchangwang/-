//
//  ResViewController.swift
//  中风康复训练
//
//  Created by wyc on 16/4/21.
//  Copyright © 2016年 wyc. All rights reserved.
//

import UIKit

class ResViewController:UIViewController{
    @IBOutlet weak var res_label_2: UILabel!
    @IBOutlet weak var res_label_1: UILabel!
    @IBOutlet weak var res_btn_1: UIButton!
    @IBOutlet weak var res_btn_2: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    var chart_view_service:ChartViewService!
    //数据的总长度
    var recoder_num:Int!
    //用户id千万不能丢失
    var user_id:NSDictionary!
    //传给服务器的数组
    var recodelist:Array<NSDictionary>=[]
    //执行进度条所需的属性
    var timer:NSTimer!
    var remainTime:Int!
    var user_name:String!
    //用来区分在线还是脱机
    var type:String!
    var document_service:DocumentService!
    
    @IBAction func res_btn2_action(sender: UIButton) {
        //退出到login页面
        self.jump()
    }
    @IBAction func res_btn1_action(sender: UIButton) {
        //继续保存
        self.recoder_progress()
    }
    //页面跳转函数
    private func jump(){
        let mainStoryboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //判断数据是否保存成功来显示不同的控件
    private func is_recodered(){
        if self.chart_view_service.save_recoder(self.recodelist as NSArray)=="success"{
            let fileName=self.type+" report/"+self.user_name+".plist"
            //清除recoder.plist文件内容
            NSArray().writeToFile(self.getplist_path(fileName), atomically: true)
            //显示成功页面
            self.success_view()
        }else{
            //显示失败界面
            self.error_view()
        }
    }
    //初始化界面
    private func init_view(){
        self.remainTime=0
        self.res_label_1.text="数据正在保存中"
        self.res_label_2.text="请您耐心等待"
        self.res_btn_1.hidden=true
        self.res_btn_2.hidden=true
    }
    private func loss_view(){
        self.res_label_1.text="对不起,数据已经丢失"
        self.res_label_2.text="浪费了您宝贵的时间"
        self.res_btn_2.hidden=false
        self.res_btn_2.setTitle("退出本次测试", forState: UIControlState.Normal)
    }
    //成功界面
    private func success_view(){
        self.res_label_1.text="数据保存成功"
        self.res_label_2.text="祝您早日健康"
        self.res_btn_2.hidden=false
        self.res_btn_2.setTitle("退出本次测试", forState: UIControlState.Normal)
    }
    //失败页面
    private func error_view(){
        self.res_label_1.text="对不起,保存数据失败"
        self.res_label_2.text="您可以选择"
        self.res_btn_1.hidden=false
        self.res_btn_1.setTitle("稍作休息,再次保存", forState: UIControlState.Normal)
        self.res_btn_2.hidden=false
        self.res_btn_2.setTitle("放弃这次数据", forState: UIControlState.Normal)
    }
    
    private func show_plist(_:Void){
        let fileName1=self.type+" User/"+self.user_name+".plist"
        let fileName2=self.type+" report/"+self.user_name+".plist"
        //从plist文件中读出用户id
        let userPath=self.document_service.getplist_path(fileName1)
        let dic=NSDictionary(contentsOfFile: userPath)! as NSDictionary
        self.user_id=["user_id":dic["user_id"] as! String]
        self.recodelist.append(self.user_id)
        //从plist文件中读出数据
        let filePath=self.document_service.getplist_path(fileName2)
        let list=NSArray(contentsOfFile: filePath)! as NSArray
        self.recoder_num=list.count
        for i in 0..<list.count{
            let dictionary:NSDictionary=list[i] as! NSDictionary
            //顺便将值添加到recoderlist
            self.recodelist.append(dictionary)
        }
    }
    //获得plist文件的路径
    private func getplist_path(plist_name:String)->String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as NSString
        let filePath=documentPath.stringByAppendingPathComponent(plist_name)
        //判断文件是否存在
        if(!NSFileManager.defaultManager().fileExistsAtPath(filePath)){
            NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
        }
        return filePath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //初始化外部类
        self.chart_view_service=ChartViewService()
        self.document_service=DocumentService()
        //1.加载数据
        self.show_plist()
        //判断数据是否丢失(记录和用户id不能丢)
        if self.recoder_num==0||self.user_id.count==0{
            //显示数据丢失页面
            self.loss_view()
        }else{
            //2.执行过程
            self.recoder_progress()
        }
    }
    private func recoder_progress(){
        //2.初始化界面
        self.init_view()
        //3.执行进度条
        //3.1设置进度条的初始值
        self.progress.progress=0
        //3.2设置进度条的大小
        let transform:CGAffineTransform = CGAffineTransformMakeScale(1.0, 3.0);
        self.progress.transform=transform
        //3.3开始执行
        self.progress.hidden=false
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timerAction), userInfo: nil, repeats:true)
        self.timer.fire()
    }
    func timerAction() {
        if(remainTime > self.recoder_num){
            //倒计时结束
            timer.invalidate()
            //隐藏进度条
            self.progress.hidden=true
            //4.保存数据
            self.is_recodered()
        } else {
            let progressValue = Float(remainTime)/Float(self.recoder_num)
            remainTime = remainTime+1
            self.progress.setProgress(progressValue, animated:true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
