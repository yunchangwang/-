//
//  ViewController.swift
//  xcode屏幕自适应
//
//  Created by wyc on 16/4/8.
//  Copyright © 2016年 wyc. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var return_label: UILabel!
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var register_btn: UIButton!
    @IBOutlet weak var test_password_label: UILabel!
    @IBOutlet weak var password_label: UILabel!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var user_register_label: UILabel!
    //编辑结束时关闭键盘
    @IBOutlet weak var test_password_text: UITextField!
    @IBOutlet weak var password_text: UITextField!
    @IBOutlet weak var user_name_text: UITextField!
    //设置定时器
    var timer:NSTimer!
    var user:UserModel!
    var register_view_service:RegisterViewService!
    //对所填文本信息进行检查
    private func test_text(_:Void){
        if self.user_name_text.text==""{
            self.show_error_label("用户名不能为空")
        }else if self.password_text.text==""{
            self.show_error_label("密码不能为空")
        }else if self.test_password_text.text==""{
            self.show_error_label("请确认密码")
        }else if !(self.password_text.text==self.test_password_text.text){
            self.show_error_label("两次密码不相等")
        }else{
            self.error_label.text=""
        }
    }
    
    //重新填写按钮事件
    @IBAction func reset(sender: UIButton) {
        //回收键盘
        self.view.endEditing(true)
        self.user_name_text.text=""
        self.password_text.text=""
        self.test_password_text.text=""
    }
    //注册事件按钮
    @IBAction func register(sender: UIButton) {
        //回收键盘
        self.end_editing()
        self.test_text()
        if !(self.error_label.text==""){
            return
        }
        //封装注册用户的信息
        self.user.setUser_name(self.user_name_text.text!)
        self.user.setPassword(self.password_text.text!)
        let check_type:String=self.register_view_service.register_user(self.user)
        if check_type=="success"{
            //此处要到后台去注册
            self.return_label.text="注册成功,5秒后返回登陆界面"
            //隐藏所有控件,并且返回登陆界面
            self.hidde_view()
            self.timer=NSTimer.scheduledTimerWithTimeInterval(5,target:self,selector: #selector(return_login),userInfo:nil,repeats:true)
        }else{
            //注册失败
            self.return_label.text="注册失败(\(check_type)),5秒后请重新注册"
            self.hidde_view()
            self.timer=NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(register_again), userInfo: nil, repeats: true)
        }
    }
    
    //显示检查的错误提示
    private func show_error_label(error:String){
        //回收键盘
        self.end_editing()
        self.error_label.hidden=false
        self.error_label.text=error
    }
    
    //返回登陆页面
    @objc private func return_login(){
        //取消执行定时器
        self.timer.invalidate()
        let mainStoryboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    //显示所有控件，重新注册
    @objc private func register_again(){
        //取消定时器
        self.timer.invalidate()
        //显示控件
        self.show_view()
    }
    
    //显示所有控件
    private func show_view(_:Void){
        self.user_register_label.hidden=false
        self.user_name_label.hidden=false
        self.user_name_text.hidden=false
        self.password_text.hidden=false
        self.password_label.hidden=false
        self.test_password_text.hidden=false
        self.test_password_label.hidden=false
        self.register_btn.hidden=false
        self.clear.hidden=false
        self.return_label.hidden=true
    }
    
    //隐藏所有控件，并显示返回的label
    private func hidde_view(_:Void){
        self.user_register_label.hidden=true
        self.user_name_label.hidden=true
        self.user_name_text.hidden=true
        self.password_text.hidden=true
        self.password_label.hidden=true
        self.test_password_text.hidden=true
        self.test_password_label.hidden=true
        self.register_btn.hidden=true
        self.clear.hidden=true
        self.return_label.hidden=false
        self.error_label.hidden=true
    }
    
    //按return键返回键盘
    @IBAction func close_keyborad(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    //view停止编辑，回收键盘
    private func end_editing(_:Void){
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //在加载view之前，初始化外部类
        self.user=UserModel()
        self.register_view_service=RegisterViewService()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

