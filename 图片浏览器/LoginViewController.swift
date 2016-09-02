//
//  viewController2.swift
//  01加法计算器
//
//  Created by wyc on 16/4/5.
//  Copyright © 2016年 wyc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var user_name: UITextField!
    var user_model:UserModel!
    var login_view_service:LoginViewService!
    //页面跳转之前的检查
    private func test_text(_:Void){
        if self.user_name.text==""{
            self.show_error_label("用户名不能为空")
        }else if self.password.text==""{
            self.show_error_label("密码不能为空")
        }else{
            self.error_label.text=""
        }
    }
    //注册按钮事件
    @IBAction func register(sender: UIButton) {
        self.jump("RegisterViewController")
    }
    //登陆按钮事件
    @IBAction func login(sender: UIButton) {
        self.test_text()
        if !(self.error_label.text==""){
            return
        }
        //用model封装用户名和密码
        self.user_model.setUser_name(self.user_name.text!)
        self.user_model.setPassword(self.password.text!)
        let check_type:String=self.login_view_service.check_user(self.user_model)
        if(check_type=="success"){
            //验证成功实现网页的跳转
            self.jump("MainViewController")
        }else{
            self.show_error_label(check_type)
            self.error_label.textColor=UIColor.redColor()
            //收回键盘
            self.end_editing()
        }
    }
    //脱机测试事件
    @IBAction func out_net_action(sender: UIButton) {
        self.jump("offlineMainController")
    }
    //页面跳转函数
    private func jump(controller:String){
        let mainStoryboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(controller) as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    //按下return键回收键盘
    @IBAction func close_keyborad(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    //显示错误信息
    private func show_error_label(error:String){
        //收回键盘
        self.end_editing()
        self.error_label.text=error
        self.error_label.hidden=false
    }
    //view停止编辑，回收键盘
    private func end_editing(_:Void){
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //在加载view之前初始化外部类
        self.user_model=UserModel()
        self.login_view_service=LoginViewService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

