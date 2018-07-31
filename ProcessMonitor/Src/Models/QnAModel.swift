//
//  QnAModel.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 7/31/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import Foundation
class QnAStruct {
    var questionText:   String
    var AnswerText:     String
    var hasChart:       Bool

    init (){
        questionText    = ""
        AnswerText      = ""
        hasChart        = false
    }
    
    func setQuestionText( pquestiontext:String){ questionText = pquestiontext }
    func getQuestionText () -> String{ return questionText}
    
    func setAnswerText( panswertext:String){ AnswerText = panswertext }
    func getAnswerText () -> String{ return AnswerText}
    
    func setHasChart( phaschart:Bool){ hasChart = phaschart }
    func getHasChart () -> Bool { return hasChart}
    
}
