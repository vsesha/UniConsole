//
//  QnAModel.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 7/31/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
class QnAStruct : NSObject{
    var questionText:   String?
    var AnswerText:     String?
    var hasChart:       Bool?
    var chartType:      Int?
    var chartValues:    [[String]]?
    
    override init () {
        super.init()
        questionText    = ""
        AnswerText      = ""
        hasChart        = false
        chartType       = 0
        chartValues     = [[String]]()
        
    }
    
    func setQuestionText( pquestiontext:String){ questionText = pquestiontext }
    func getQuestionText () -> String{ return questionText!}
    
    func setAnswerText( panswertext:String){ AnswerText = panswertext }
    func getAnswerText () -> String{ return AnswerText!}
    
    func setHasChart( phaschart:Bool){ hasChart = phaschart }
    func getHasChart () -> Bool { return hasChart!}
    
    func setChartType (pcharttype:Int) {chartType = pcharttype}
    func getChartType () -> Int {return chartType!}
    
}
