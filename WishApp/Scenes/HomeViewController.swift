//
//  HomeViewController.swift
//  WishApp
//
//  Created by VIDAL Léo on 03/01/2021.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI

class HomeViewController: UIViewController {
    
    var contactStore = CNContactStore()
    
    var phoneNumber: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "home"
        self.requestForContactAccess(completionHandler: {success in
            print("success : \(success)")
        } )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showContactPicker))
    }
    
    @objc
    func showContactPicker() -> Void {
        let contactVC = CNContactPickerViewController()
        contactVC.delegate = self
        self.present(contactVC, animated: true, completion: nil)
    }
    
    func requestForContactAccess(completionHandler: @escaping (Bool) -> Void ) {
        let autorisationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        print("authorized : \(autorisationStatus)")
        switch autorisationStatus {
            case .authorized:
                completionHandler(true)
            case .denied, .notDetermined:
                self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: {(access, error) -> Void in
                    if(access) {completionHandler(true)}
                    else {completionHandler(false)}
                })
            default:
                completionHandler(false)
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        guard let phone = self.phoneNumber else {
            return;
        }
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [phone]
        composeVC.body = "Hello bro"
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else { print("shit") }
    }
    

}

extension HomeViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumber: String = contact.phoneNumbers[0].value.stringValue
        self.phoneNumber = phoneNumber
        print("selected contact : \(phoneNumber)")
    }
}

extension HomeViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
