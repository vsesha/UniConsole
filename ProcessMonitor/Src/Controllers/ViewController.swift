//
//  ViewController.swift
//  ProcessMonitor
//
//  Created by Vasudevan Seshadri on 1/8/18.
//  Copyright © 2018 Vasudevan Seshadri. All rights reserved.
//

import UIKit
import AWSCognito
import AWSLambda


class ViewController: UIViewController, UIGestureRecognizerDelegate {
  

    @IBOutlet weak var questionTextView:    UITextField!
    //@IBOutlet weak var answerTextView:      UITextView!
    @IBOutlet weak var sendToBotButton:     UIButton!
    @IBOutlet weak var microphoneButton:    UIButton!
    @IBOutlet weak var clearButton:         UIButton!
    @IBOutlet weak var speakerButton:       UIButton!
    @IBOutlet weak var helpButton:          UIButton!
    
    @IBOutlet weak var progressBar:         UIProgressView!
    
    @IBOutlet weak var ChatBotTableView:    UITableView!
    

    var m_questionIndex             = 1
    var m_keyboardHeight            = 0.0
    var speechCtrl                  = SpeechController()
    var botCommunicationMgr         = BotCommunicationManager()
    
    var QnAArray:[QnAStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decorateControls()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleMicLongPress))
       
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.delegateNotification(_:)),
                                               name: NSNotification.Name(rawValue: GLOBAL_APP_INTERNAL_NOTIFICATION_KEY),
                                               object: nil)
        

        
        
        longPressGesture.minimumPressDuration   = 0.20
        longPressGesture.delaysTouchesBegan     = true
        longPressGesture.delegate               = self
        
        microphoneButton.addGestureRecognizer(longPressGesture)
        
        initilizeAWSLambdaConnections()
        ChatBotTableView.dataSource = self
        ChatBotTableView.estimatedRowHeight = 80
        ChatBotTableView.rowHeight = UITableViewAutomaticDimension
        ChatBotTableView.tableFooterView = UIView(frame: CGRect.zero)
        ChatBotTableView.contentInset.top = 10
    }

   
    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
   

   
    
    func updateProgressBar(progress:float_t) {
        progressBar.progress = progress
    }
    
    func initilizeAWSLambdaConnections (){
        print("Creating AWS Cognito Credentials Provider")
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:  AWSRegionType.usEast2,
                                                                identityPoolId: "us-east-2:e565545e-44ca-4557-baa5-56eb6e9f68ac")

        
        
        print("Creating a default AWSservice configuration for unauthenticated user")
        let configuration = AWSServiceConfiguration(region: AWSRegionType.usEast2,
                                                    credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        print("AWSServiceManager = \(AWSServiceManager.default().defaultServiceConfiguration)")
        
    }
    
    func decorateControls(){
        
        questionTextView.layer.shadowOpacity = 0.4
        questionTextView.layer.shadowOffset = CGSizeFromString("1")
        questionTextView.layer.shadowRadius = 4
        questionTextView.layer.masksToBounds = false
        questionTextView.layer.cornerRadius = 4
        
        
        sendToBotButton.layer.shadowOpacity = 0.4
        sendToBotButton.layer.shadowOffset = CGSizeFromString("1")
        sendToBotButton.layer.shadowRadius = 4
        sendToBotButton.layer.masksToBounds = false
        sendToBotButton.layer.cornerRadius = 4
        
        clearButton.layer.shadowOpacity = 0.4
        clearButton.layer.shadowOffset = CGSizeFromString("1")
        clearButton.layer.shadowRadius = 4
        clearButton.layer.masksToBounds = false
        clearButton.layer.cornerRadius = 4
        
        speakerButton.layer.shadowOpacity = 0.4
        speakerButton.layer.shadowOffset = CGSizeFromString("1")
        speakerButton.layer.shadowRadius = 4
        speakerButton.layer.masksToBounds = false
        speakerButton.layer.cornerRadius = 4
        
        helpButton.layer.shadowOpacity = 0.4
        helpButton.layer.shadowOffset = CGSizeFromString("1")
        helpButton.layer.shadowRadius = 4
        helpButton.layer.masksToBounds = false
        helpButton.layer.cornerRadius = 4
        
        ChatBotTableView.layer.shadowOpacity = 0.4
        ChatBotTableView.layer.shadowOffset = CGSizeFromString("1")
        ChatBotTableView.layer.shadowRadius = 4
        ChatBotTableView.layer.masksToBounds = false
        ChatBotTableView.layer.cornerRadius = 4
        
        progressBar.layer.shadowOpacity = 0.4
        progressBar.layer.shadowRadius = 4
        
    }
    
    @objc func handleMicLongPress(gestureRecognizer: UILongPressGestureRecognizer){
        
       updateProgressBar(progress: 0.0)
    
        if(gestureRecognizer.state == UIGestureRecognizerState.began){
            questionTextView.placeholder = "Listening..."
            print("Start Recording")
            questionTextView.text = ""
            recordSpeech()
            
        }
        if(gestureRecognizer.state == UIGestureRecognizerState.ended){
            //answerTextView.text = "Getting your answer..."
            EndEditingAndHideKeyBoard()
            speechCtrl.stopSpeaking()
            
            /*
             let publishToBotTimer = Timer.scheduledTimer (timeInterval: 0.2,
                                                         target: self,
                                                         selector: #selector(sendToBot),
                                                         userInfo: nil,
                                                         repeats: false)
            */
            questionTextView.placeholder = "Ask any question"
            print("End  Recording")
        }
    }
    
    func recordSpeech(){
        speechCtrl.stopSpeaking()
        speechCtrl.startRecording(labelControl: questionTextView)
    }
    
    
    @IBAction func QuestionTextEditBegin(_ sender: UITextField) {
        print("QuestionTextEditBegin")

        
        //move textfields up
        let myScreenRect: CGRect        = UIScreen.main.bounds
        var keyboardHeight : CGFloat    = 216
        /*if (m_keyboardHeight) > 1.0 {
            keyboardHeight = CGFloat(m_keyboardHeight)
        }*/
        
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (sender.frame.origin.y + sender.frame.size.height + UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight - 30)) {
            needToMove = (sender.frame.origin.y + sender.frame.size.height + UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight - 30);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
        
        
        
    }
    
    
    @IBAction func QuestionTextEditEnded(_ sender: UITextField) {
         print("QuestionTextEditEnded")
        //move textfields back down
        EndEditingAndHideKeyBoard()
    }
    
    
    @IBAction func helpButtonTouched(_ sender: Any) {
        updateProgressBar(progress: 0.0)
        questionTextView.text = "Help Me"
        EndEditingAndHideKeyBoard()
        sendToBot_new()
    }
    
    @IBAction func speakerTouch(_ sender: Any) {
        updateProgressBar(progress: 0.0)
        if(GLOBAL_IS_MUTE_MODE) {
            speakerButton.setImage(UIImage(named:"unmute"), for: .normal)
            GLOBAL_IS_MUTE_MODE = false
        } else {
            SpeakMessage.instance.stopSpeaking()
            speakerButton.setImage(UIImage(named:"mute"),   for: .normal)
            GLOBAL_IS_MUTE_MODE = true
        }
        
    }
    
    
    
   @objc func EndEditingAndHideKeyBoard(){
        UIView.beginAnimations( "animateView", context: nil)
        updateProgressBar(progress: 0.0)
            var movementDuration:TimeInterval = 0.20
            var frame : CGRect = self.view.frame
            frame.origin.y = 0
            self.view.frame = frame
        UIView.commitAnimations()
        
        self.view.endEditing(true)
        self.questionTextView.endEditing(true)
        questionTextView.resignFirstResponder()
    }
    
    
    @objc func keyboardWillShow(notification: Notification){
        print("keyboardWillShow")
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        m_keyboardHeight = Double(keyboardRectangle.height)
        print ("keyboard Height =  \(m_keyboardHeight)")
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        print("keyboardWillHide")
       //EndEditingAndHideKeyBoard()
    }
 
    

    @IBAction func clearButtonPressed(_ sender: Any) {
        deleteTableData()
    }
 
    func deleteTableData(){
        QnAArray.removeAll()
        ChatBotTableView.reloadData()
        m_questionIndex = 1
    }
    
    @IBAction func sendToBotButtonPrssed(_ sender: Any) {
        EndEditingAndHideKeyBoard()
        updateProgressBar(progress: 0.25)
        addQnAtoTableView()
    }

    @objc func sendToBot_new(){
        do{
            var userQuery = questionTextView.text
            try botCommunicationMgr.sendRequestToProcessManagerBOT_new(queryString: userQuery!, completion:{ (result:String) ->() in
                    print("Response from BOT = \(result)")
                self.reloadAnswer(answer: result)
             
                }
            )
            
        }
        catch let exception as NSException{
            print ("exception = \(exception)")
        }
        catch let error as NSError{
            print ("error = \(error)")
        }
    }
    
    
    func addQnAtoTableView(){
        
        var qnastruct = QnAStruct()
        
        qnastruct.questionText      = questionTextView.text!
        qnastruct.AnswerText        = "..."
 
        qnastruct.hasChart          = true
        QnAArray.append(qnastruct)
        m_questionIndex = QnAArray.count
     
        var indexpath:IndexPath
        indexpath = IndexPath(item: m_questionIndex - 1 , section: 0)
        
        ChatBotTableView.insertRows(at: [indexpath], with: .bottom)
        scrollToBottom()
        sendToBot_new()
    }
  
    func reloadAnswer (answer:String){
        var qnastruct = self.QnAArray[self.m_questionIndex - 1]
        qnastruct.AnswerText = answer
        
        var indexpath:IndexPath
        indexpath = IndexPath(item: self.m_questionIndex - 1 , section: 0)
        self.ChatBotTableView.reloadRows(at: [indexpath], with: .right)
        scrollToBottom()
    }
    
    @objc func delegateNotification(_ notification:NSNotification){
        
        var notifyMsg:  NotificationMessage
        var msgType:    NotificationTypes
        
        notifyMsg   = notification.object as! NotificationMessage
        msgType     = notifyMsg.NotifyType!
        
        switch(msgType){
        case .PROGRESS_BAR_UPDATE:
            var progress = Float(notifyMsg.NotifyMessage as! String)
            updateProgressBar(progress: progress!)
            break
        
        default:
            reloadAnswer(answer: notifyMsg.NotifyMessage!)
            updateProgressBar(progress: 1.0)
            break
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.QnAArray.count-1, section: 0)
            self.ChatBotTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue = \(segue)")
        print("Identifier = \(segue.identifier)")
            
        /*{
            let cell        = sender as! UITableViewCell
            //let cell        = sender as! ChatBotTabelViewCell
            //print("qustion = \(cell.s_UserQuestion.text)")
            let indexpath   = self.ChatBotTableView.indexPath(for: cell)
        
            let selectedCellData = ChatBotTableView.cellForRow(at: indexpath!)
            print("selectedCellData =  \(selectedCellData)")
        }*/
    }
    

}





