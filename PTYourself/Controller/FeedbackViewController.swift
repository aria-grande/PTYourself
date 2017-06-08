//
//  FeedbackViewController.swift
//  PTYourself
//
//  Created by Aree Oh on 2017. 6. 8..
//  Copyright © 2017년 Aree Oh. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(configureMailComposeVC(), animated: true, completion: nil)
        }
        else {
            print("cannot send email")
        }
    }

    func configureMailComposeVC() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["christina.ohari@gmail.com"])
        mailComposeVC.setSubject("[PTYourself] 피드백/버그")
        mailComposeVC.setMessageBody("<br/><br/><hr/><h3>버그 발생시 신고 양식</h3><br/>- 내용: _ <br/>- 휴대폰 기종: <br/>- os버전: \(UIDevice.current.systemVersion)<br/>", isHTML: true)
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
