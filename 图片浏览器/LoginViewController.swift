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
    var document_service:DocumentService!
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
        //交给后台验证并返回结果
        let check_type:String=self.login_view_service.check_user(self.user_model,type: "Line")
        if(check_type=="success"){
            //验证成功实现网页的跳转
            self.jump("MainViewController")
        }else{
            self.show_error_label(check_type)
            //self.error_label.textColor=UIColor.redColor()
        }
    }
    //保存脱机测试数据
    @IBAction func save_out_line_res(sender: UIButton) {
        //检查用户填写信息
        self.test_text()
        if !(self.error_label.text==""){
            return
        }
        //检查在Off User中是否有相关文件
        let fileName1="Off User/"+self.user_name.text!+".plist"
        if(!self.document_service.check_exits(fileName1)){
            //如果不存在
            self.show_error_label("没有匹配的用户")
        }else{
            //如果存在查看是否有测试数据
            let fileName2="Off report/"+self.user_name.text!+".plist"
            if !self.document_service.check_report(fileName2){
                self.show_error_label("您还没有测试呢")
            }else{
                //进行后台验证
                //用model封装用户名和密码
                self.user_model.setUser_name(self.user_name.text!)
                self.user_model.setPassword(self.password.text!)
                let check_type:String=self.login_view_service.check_user(self.user_model,type: "Off")
                if(check_type=="success"){
                    //验证成功跳转到保存页面
                    self.jump("ResViewController")
                }else{
                    //验证失败
                    self.show_error_label(check_type)
                    self.error_label.textColor=UIColor.redColor()
                }
            }
        }
    }
    //脱机测试事件
    @IBAction func out_net_action(sender: UIButton) {
        //检查用户是否填写信息
        self.test_text()
        if !(self.error_label.text==""){
            return
        }
        //创建脱机所需的文件夹
        self.document_service.create_dir("Off User")
        //从Off User文件中检查是否有该用户
        let fileName="Off User/"+self.user_name.text!+".plist"
        //判断该文件是否存在
        if self.document_service.check_exits(fileName){
            //如果存在，比较两次的密码
            //从plist文件中读出用户id
            let userPath=self.document_service.getplist_path(fileName)
            let dic=NSDictionary(contentsOfFile: userPath)! as NSDictionary
            let password_temp=dic["password"] as! String
            if !(password_temp==self.password.text!){
                self.show_error_label("本地密码不一样")
            }else{
                self.jump("offlineMainController")
            }
        }else{
            let filePath=self.document_service.create_plist(fileName)
            //写入脱机测试时的用户信息
            let dictionary:NSDictionary=["user_name":self.user_name.text!,"password":self.password.text!]
            dictionary.writeToFile(filePath, atomically: true)
            self.jump("offlineMainController")
        }
    }
    
    //页面跳转函数
    private func jump(controller:String){
        if controller=="RegisterViewController"{
            let vc=self.storyboard?.instantiateViewControllerWithIdentifier(controller) as! RegisterViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else if controller=="MainViewController"{
            let vc=self.storyboard?.instantiateViewControllerWithIdentifier(controller) as! MainViewController
            vc.user_name=self.user_name.text!
            self.presentViewController(vc, animated: true, completion: nil)
        }else if controller=="ResViewController"{
            let vc=self.storyboard?.instantiateViewControllerWithIdentifier(controller) as! ResViewController
            vc.user_name=self.user_name.text!
            vc.type="Off"
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            let vc=self.storyboard?.instantiateViewControllerWithIdentifier(controller) as! offlineMainController
            vc.user_name=self.user_name.text!
            self.presentViewController(vc, animated: true, completion: nil)
        }
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
        self.document_service=DocumentService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

