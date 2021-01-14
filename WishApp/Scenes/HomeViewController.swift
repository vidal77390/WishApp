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
        let rightButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createWishList))
        rightButton.tintColor = UIColor(cgColor: CGColor(red: CGFloat(0.09), green: CGFloat(0.5), blue: CGFloat(0.09), alpha: CGFloat(1.0)))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc
    func createWishList() -> Void {
        var nameTextField: UITextField?
        let alertController = UIAlertController(title: "New WishList !", message: "Veuillez saisir le nom de votre WishList", preferredStyle: .alert)
        alertController.addTextField { (txtName) -> Void in
            nameTextField = txtName
            nameTextField?.placeholder = "Nom"
        }
        let createAction = UIAlertAction(title: "createWishList", style: .default) { (action) -> Void in
            // TODO create and store wishList
            print("wishlist created with : \(nameTextField?.text)")
        }
        alertController.addAction(createAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    ///|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||///|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||///|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||///|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    /// Part of implementing framework too move later
    
    
    
    
    
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
