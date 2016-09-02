//
//  ChartViewController.swift
//  中风康复训练
//
//  Created by wyc on 16/4/16.
//  Copyright © 2016年 wyc. All rights reserved.
//

import UIKit
import QuartzCore

class ChartViewController: UIViewController,LineChartDelegate {
    var label = UILabel()
    var lineChart: LineChart!
    var data:[CGFloat] = []
    var data2:[CGFloat]=[]
    var xLabels:[String]=[]
    var list:NSArray!
    
    @IBAction func escp(sender: UIButton) {
        self.jump("LoginViewController")
    }
    @IBAction func save(sender: AnyObject) {
        self.jump("ResViewController")
    }
    
    private func jump(controller:String){
        let mainStoryboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(controller) as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
        
        //从plist文件中读数据
        self.show_plist()
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
    }
    
    private func show_plist(_:Void){
        //从plist文件中读出数据
        let filePath=self.getplist_path("recoder.plist")
        list=NSArray(contentsOfFile: filePath)! as NSArray
        for i in 0..<list.count{
            let dictionary:NSDictionary=list[i] as! NSDictionary
            //顺便将值添加到recoderlist
            self.data.append(CGFloat((dictionary["accuracy"]?.doubleValue)!))
            self.data2.append(CGFloat((dictionary["photo_num"]?.doubleValue)!))
            self.xLabels.append("测试"+String(i+1))
        }
    }
    //获得plist文件的路径
    private func getplist_path(plist_name:String)->String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as NSString
        let filePath=documentPath.stringByAppendingPathComponent(plist_name)
        return filePath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text="测试\(Int(x+1)) [测试数量:\(Int(yValues[1])),正确率:\(yValues[0])%]"
    }
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
}