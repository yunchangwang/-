//
//  ViewController.swift
//  图片浏览器
//
//  Created by wyc on 16/4/6.
//  Copyright © 2016年 wyc. All rights reserved.
//

import UIKit

class CommonMainViewController: UIViewController {
    @IBOutlet weak var break_btn: UIButton!
    @IBOutlet weak var reactime_res_label: UILabel!
    @IBOutlet weak var accuracy_res_label: UILabel!
    @IBOutlet weak var start_btn: UIButton!
    @IBOutlet weak var reactime_label: UILabel!
    @IBOutlet weak var accuracy_label: UILabel!
    @IBOutlet weak var right_hand: UIButton!
    @IBOutlet weak var left_hand: UIButton!
    //图片个数的索引标签
    @IBOutlet weak var label_num: UILabel!
    //控件image view
    @IBOutlet weak var imge_view: UIImageView!
    //对属性进行懒加载，存放的是所需的图片
    lazy var pic:NSArray = {
        let diaryList:String = NSBundle.mainBundle().pathForResource("pic", ofType:"plist")!
        var pic_temp=NSArray(contentsOfFile: diaryList)! as NSArray
        return pic_temp
    }()
    //现在的测试no
    var now_no:Int=10
    //结束所有测试的no
    var end_no:Int=15
    //图片的个数索引
    var index:Int=0
    //存放随机数字的数组
    var random_num:[Int] = []
    //测试的正确率
    var accuracy:Double=100
    //为了正确率，需要错误次数和已经测试次数
    var error_num:Int=0
    var alltest_num:Int=0
    //测试的反应事件
    var reaction_time:Double=0
    //为了反应时间，需要开始时间和结束时间
    var start_time:Double=0
    var end_time:Double=0
    //记录测试的结果
    var recode_array:Array<NSDictionary> = []
    //用于跳转的计时器
    var timer:NSTimer!
    //用于跳转的controller参数
    var controller:String!
    //开始测试按钮的事件
    @IBAction func start_test(sender: UIButton) {
        //随机产生照片索引
        self.init_random_num(self.now_no)
        //测试开始的初始化
        self.init_start_test(self.now_no)
        //所有控件的初始化
        self.init_view()
    }
    //右手按钮的事件
    @IBAction func right_hand(sender: UIButton) {
        self.account(sender)
        self.is_over()
        //如果本次时最后一次那么结束，否则下一张
    }
    //左手按钮的事件
    @IBAction func left_hand(sender: UIButton) {
        self.account(sender)
        self.is_over()
        //如果本次时最后一次那么结束，否则下一张
    }
    
    //同时判断本次测试和所有测试
    internal func is_over(_:Void){
    }

    
    //休息按钮事件
    @IBAction func break_action(sender: UIButton) {
    }
    
    //页面跳转函数
    @objc internal func jump(){
        self.timer.invalidate()
        let mainStoryboard=UIStoryboard(name:"Main",bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(self.controller) as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //得到plist文件的路径
    internal func getplist_path(plist_name:String)->String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as NSString
        let filePath=documentPath.stringByAppendingPathComponent(plist_name)
        return filePath
    }
    
    //测试开始的初始化
    internal func init_start_test(i:Int){
        self.label_num.text="1/"+String(i)
        self.reactime_res_label.text="0s"
        self.accuracy_res_label.text="100%"
        //随机产生照片索引
        self.init_random_num(i)
        //初始化控件
        self.init_view()
        //将第一张照片显示
        let dictionary:NSDictionary=self.pic[self.random_num[self.index]] as! NSDictionary
        self.imge_view.image=UIImage.init(named: String(dictionary["index"]!))
        //得到当前的时间
        self.start_time=NSDate().timeIntervalSince1970
    }
    
    //随机产生now_no个0-11的数字
    internal func init_random_num(end:Int){
        for _ in 0..<end{
            var num_temp:Int
            num_temp=Int(arc4random()%12)
            self.random_num.append(num_temp)
        }
    }
    
    //初始化控件属性
    internal func init_view(_:Void){
        //显示需要的控件
        self.imge_view.hidden=false
        self.left_hand.hidden=false
        self.right_hand.hidden=false
        self.accuracy_label.hidden=false
        self.accuracy_res_label.hidden=false
        self.reactime_label.hidden=false
        self.reactime_res_label.hidden=false
        self.start_btn.hidden=true
    }
    
    //隐藏所有的控件
    internal func hidde_view(_:Void){
        self.imge_view.hidden=true
        self.left_hand.hidden=true
        self.right_hand.hidden=true
        self.accuracy_label.hidden=true
        self.accuracy_res_label.hidden=true
        self.reactime_label.hidden=true
        self.reactime_res_label.hidden=true
        self.start_btn.hidden=false
    }
    
    //判断测试是否结束
    internal func is_end_test()->Bool{
        var is_end:Bool=false
        if self.index==self.now_no-1{
            is_end=true
            //重新开始前要记录数据(正确率，平均反应时间，记录的时间)
            self.recode()
            self.init_again()
        }
        return is_end
    }
    
    internal func recode(_:Void){
        //正确率
        var temp1:NSString=""
        temp1=NSString.init(string:self.accuracy_res_label.text!)
        temp1=temp1.substringToIndex(temp1.length-1)
        //平均反应时间
        var temp2:NSString=""
        temp2=NSString.init(string: self.reactime_res_label.text!)
        temp2=temp2.substringToIndex(temp2.length-1)
        //当前的时间
        var temp3:NSDate
        temp3=NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateString :String
        dateString = formatter.stringFromDate(temp3)
        //将数据写入plis文件中，这个文件的临时文件
        let dictionary : NSDictionary=["photo_num":String(now_no),"accuracy":String(temp1),"action_time":String(temp2),"recode_time":dateString]
        self.recode_array.append(dictionary)
    }
    
    //如果测试结束要重新初始化
    internal func init_again(_:Void){
        self.label_num.text="第"+String(self.now_no-9)+"次测试结束"
        self.now_no+=1
        //再次隐藏控件
        self.hidde_view()
        //改变开始按钮的文本
        self.start_btn.setTitle("开始第"+String(self.now_no-9)+"次测试", forState: UIControlState.Normal)
        //清空前一次测试的数据
        self.index=0
        self.alltest_num=0
        self.error_num=0
    }
    
    //计算正确率和反应时间
    private func account(sender:UIButton){
        let dictionary:NSDictionary=self.pic[self.random_num[self.index]] as! NSDictionary
        //1.计算正确率和反应时间
        //1.1已经测试次数＋＋
        self.alltest_num+=1
        //1.2判断选择是否正确，来决定错误次数是否＋＋
        if !(String(dictionary["title"]!)==String((sender.titleLabel?.text)!)){
            self.error_num+=1
        }
        //1.3计算值
        self.accuracy=Double((self.alltest_num-self.error_num))/Double(self.alltest_num)*100
        if (self.alltest_num-self.error_num)%self.alltest_num==0{
            self.accuracy_res_label.text=String(format: "%.0f",self.accuracy)+"%"
        }else{
            self.accuracy_res_label.text=String(format: "%.2f",self.accuracy)+"%"
        }
        //1.4得到结束时间
        self.end_time=NSDate().timeIntervalSince1970
        //先定义一个临时变量
        var temp:NSString=""
        temp=NSString.init(string: self.reactime_res_label.text!)
        self.reactime_res_label.text=String(format: "%.2f",(self.end_time-self.start_time+Double(temp.substringToIndex(temp.length-1))!)/Double(self.alltest_num))+"s"
    }
    
    //图片下一张的事件
    internal func next(_:Void){
        //1.图片索引++
        self.index+=1
        //2.从pic中获得图片的名称
        let dictionary:NSDictionary=self.pic[self.random_num[self.index]] as! NSDictionary
        //3.通过image属性来设置图片框里的图片
        self.label_num.text=String(self.index+1)+"/"+String(self.now_no)
        //print(dictionary["index"]!)
        self.imge_view.image=UIImage.init(named: String(dictionary["index"]!))
        //得到下一次的开始时间
        self.start_time=NSDate().timeIntervalSince1970
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

