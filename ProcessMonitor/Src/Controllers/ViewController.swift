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


struct QnAStruct {
    var questionText: String
    var AnswerText: String
    var hasChart:Bool
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
  

    @IBOutlet weak var questionTextView:    UITextField!
    @IBOutlet weak var answerTextView:      UITextView!
    @IBOutlet weak var sendToBotButton:     UIButton!
    @IBOutlet weak var microphoneButton:    UIButton!
    @IBOutlet weak var clearButton:         UIButton!
    @IBOutlet weak var speakerButton:       UIButton!
    @IBOutlet weak var helpButton:          UIButton!
    
    @IBOutlet weak var progressBar:         UIProgressView!
    
    @IBOutlet weak var ChatBotTableView:    UITableView!
    

    
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
       /* let provider = credentialsProvider.identityProvider
        let finalCredProvider = AWSCognitoCredentialsProvider.init(regionType: AWSRegionType.usEast2,
                                                                   unauthRoleArn: "arn:aws:iam::440497887274:role/ALLOW_LAMBDA_EXECUTION",
                                                                   authRoleArn: "arn:aws:iam::440497887274:role/lambda_execution",
                                           identityProvider: provider)*/
        
        //let credentialsProvider = AWSCognitoCredentialsProvider.init(regionType: AWSRegionType.usEast2, identityPoolId: "us-east-2:e565545e-44ca-4557-baa5-56eb6e9f68ac")
        
        
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
        
        answerTextView.layer.shadowOpacity = 0.4
        answerTextView.layer.shadowOffset = CGSizeFromString("1")
        answerTextView.layer.shadowRadius = 4
        answerTextView.layer.masksToBounds = false
        answerTextView.layer.cornerRadius = 4
        
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
        if (!answerTextView.text.isEmpty) {
            answerTextView.text = answerTextView.text + "\r \n"
            
        }
        answerTextView.text = answerTextView.text + "User: "
        answerTextView.text = answerTextView.text + questionTextView.text!

        sendToBot()
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
        answerTextView.text = ""
    }
 
    
    @IBAction func sendToBotButtonPrssed(_ sender: Any) {
        EndEditingAndHideKeyBoard()
        updateProgressBar(progress: 0.25)
        if (!answerTextView.text.isEmpty) {
            answerTextView.text = answerTextView.text + "\r \n"
            
        }
        answerTextView.text = answerTextView.text + "User: "
        answerTextView.text = answerTextView.text + questionTextView.text!
        
        addQnAtoTableView()
        
        sendToBot()
        
    }

  
    
    func invokeLambdaFunction(){
        
        //collect name
        let processName = "GCLR"
        
        //invoke lambda function asynchronously
        NSLog("Invoking lambda default  for Process Name =\(processName)")
        let lambdaInvoker = AWSLambdaInvoker.default()
        
        NSLog("now trying to invoke")
        let task = lambdaInvoker.invokeFunction("TestLambdaFunction", jsonObject: ["processName":processName])
        //let task = lambdaInvoker.invokeFunction("ProcessStatus", jsonObject: nil)
        
        task.continue({ (task: AWSTask!) -> AWSTask<AnyObject>! in
            
            if (task.error != nil) {
                NSLog("Invoke Lambda returned an error : \(task.error)")
                //NSLog("Invoke Lambda returned an error : \(task.error)")
                
            } else {
                if (task.result != nil) {
                    //NSLog("Invoke Lambda : result = \(task.result)")
                    /*
                     //upate text label on the main UI thread
                     let r = task.result as! Dictionary<String,String>
                     print("1")
                     let msg = r["PROCESS_NAME"]
                     print("2")
                     let box = r["BOX"]
                     print("3")
                     print("Process Name  = \(msg)")
                     print("Box =\(box)")
                     */
                    
                    // var data = task.result as! NSDictionary
                    
                    /* var data = task.result as! Any
                     
                     let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary*/
                    
                    
                    //var data:AWSJSONResponseSerializer = task.result as! AWSJSONResponseSerializer
                    
                    
                    
                    
                    
                } else {
                    NSLog("Invoke Lambda : unknow result : \(task)");
                    NSLog("Exception : \(task.exception)")
                    NSLog("Error : \(task.error)" )
                }
            }
            return nil
        })
        
        
    }
    
    @objc func sendToBot(){
        do{
            var userQuery = questionTextView.text
            //addQnAtoTableView()
            try botCommunicationMgr.sendRequestToProcessManagerBOT(queryString: userQuery!,
                                                                   botResponseLabel: answerTextView)
            
        }
        catch let exception as NSException{
            print ("exception = \(exception)")
        }
        catch let error as NSError{
            print ("error = \(error)")
        }
    }
    
    
    func addQnAtoTableView(){
        
        //here
        var qnastruct = QnAStruct(questionText: "",AnswerText: "",hasChart: false)
        
        qnastruct.questionText      = questionTextView.text!
        qnastruct.AnswerText        = "Getting response..."
        qnastruct.hasChart          = true
        print("qnastruct = \(qnastruct)")
        
        print("1")
        QnAArray.append(qnastruct)
        print("2")
        var indexpath:IndexPath
        indexpath = IndexPath(item: QnAArray.count - 1 , section: 0)
        
 
        print("3 - indexpath = \(indexpath)")
        ChatBotTableView.insertRows(at: [indexpath], with: .bottom)
        print("4")
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
            
            answerTextView.text = answerTextView.text + "\nAssistant: "
            answerTextView.text = answerTextView.text + notifyMsg.NotifyMessage!
            updateProgressBar(progress: 1.0)
            break
        }
        
       

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QnAArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatBotTableView.dequeueReusableCell(withIdentifier: "ChatBotTabelViewCell") as! ChatBotTabelViewCell
        var data:QnAStruct =  QnAArray[indexPath.row]
        cell.s_UserQuestion.text = data.questionText
        cell.s_botResponse.text  = data.AnswerText
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}



