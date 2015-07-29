//
//  SSDPlistManager.swift
//  SSDExercise
//
//  Created by 李 智恒 on 15/7/27.
//  Copyright (c) 2015年 李 智恒. All rights reserved.
//

class SSDPlistManager: NSObject {
    //单例
    static let sharedManager = SSDPlistManager()
    var exercisesArray: [[String: String]]?
    
    //写入成功返回true，否则返回false
    func saveToSandBox(_array: NSArray, bookNumber: Int)->Bool {
        var array = _array as NSArray
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var path = paths[0] as! String
        var pathInSandbox = path.stringByAppendingString("ku_ssd\(bookNumber).plist")
        
        return array.writeToFile(pathInSandbox, atomically: true)
        
    }
    
    
    //将题库中的plist文件导入沙盒中的Documents目录下
    func movePlistsToSandbox(){
        
        for i in 1...9 {
            movePlistsToSandbox(i)
        }
    }
    
    func movePlistsToSandbox(bookNumber: Int){
        var pathInBundle = NSBundle.mainBundle().pathForResource("ku_ssd\(bookNumber)", ofType: "plist")
        if let p = pathInBundle {
            var array = NSArray(contentsOfFile: p)

            if saveToSandBox(array!, bookNumber: bookNumber) == true {
                println("SSD\(bookNumber)导入至沙盒成功")
            } else {
                println("SSD\(bookNumber)导入至沙盒失败")
            }
        }
    }
    
    
    func loadArray(bookNumber: Int)->[[String: String]]? {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var path = paths[0] as! String
        var pathInSandbox = path.stringByAppendingString("ku_ssd\(bookNumber).plist")
        println(pathInSandbox)
        self.exercisesArray = NSArray(contentsOfFile: pathInSandbox) as? [[String: String]]

        return self.exercisesArray
    }
    
    //status为"done"、"mark"或者是abcd
    //写入成功返回true，否则返回false
    func saveStatus(_exercise: [String: String], bookNumber: Int, status: String)->Bool {
        var exercise = _exercise
        var index = (NSArray(array: self.exercisesArray!)).indexOfObject(exercise)
        if status == "done" || status == "mark" {
            exercise[status] = "1"
        }else if status == "a" || status == "b" || status == "c" || status == "d" {
            exercise["wrong"] = status
        }
        
        exercisesArray?[index] = exercise
        return saveToSandBox(exercisesArray! as NSArray, bookNumber: bookNumber)
    }
    
    
    
    
    
    
    
}