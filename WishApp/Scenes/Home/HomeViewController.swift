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
import Social

class HomeViewController: UIViewController {
    
    var contactStore = CNContactStore()
    let contactVC = CNContactPickerViewController()
    var phoneNumber: String?
    
    enum Identifier: String {
        case WishList
    }
    var listOfWishList: [WishList] = []
    var wishListSelected: WishList?
    let wishListService: WishListService = LocalWishListService.shared

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var EmptyListTrigger: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WishLists"
        // Set Navigation Bar Button
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createWishList))
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(activateEditMode))
        let barButtonColor: UIColor = UIColor(cgColor: CGColor(red: CGFloat(0.13), green: CGFloat(0.40), blue: CGFloat(2.19), alpha: CGFloat(1.0)))
        rightBarButton.tintColor = barButtonColor
        leftBarButton.tintColor = barButtonColor
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        
        self.contactVC.delegate = self
        
        self.tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: Identifier.WishList.rawValue)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getAndSetListOfWishList()
        
        self.requestForContactAccess(completionHandler: {access in
            // TODO handle refus     pop up ?
        })
        
    }
    
    func getAndSetListOfWishList() {
        self.wishListService.list(completion: { err, list in
            self.listOfWishList = list
            self.testIfListEmpty()
            self.tableView.reloadData()
            print("List : \(list)")
        })
    }
    
    func testIfListEmpty() -> Void {
        if(self.listOfWishList.count == 0) {
            self.tableView.isHidden = true
            self.EmptyListTrigger.isHidden = false
        }
        else {
            self.tableView.isHidden = false
            self.EmptyListTrigger.isHidden = true
        }
    }
    
    @objc
    func activateEditMode(){
        UIView.animate(withDuration: 0.33, animations: {
            self.tableView.isEditing = !self.tableView.isEditing
        })
    }
    
    @objc
    func createWishList() -> Void {
        var nameTextField: UITextField!
        let alertController = UIAlertController(title: "New WishList !", message: "Please enter the name of your WishList", preferredStyle: .alert)
        alertController.addTextField { (txtName) -> Void in
            nameTextField = txtName
            nameTextField.placeholder = "Name"
        }
        
        let createAction = UIAlertAction(title: "Create WishList", style: .default) { (action) -> Void in
            let name: String = nameTextField.text!
            if(!name.isEmpty){
                let wishList = WishList(name: name)
                self.wishListService.create(wishList: wishList) { (err, wish) in
                    guard err == nil else {
                        self.presentErrorAlert()
                        return
                    }
                    print("Wishlist created with : \(nameTextField.text!)")
                    self.getAndSetListOfWishList()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        alertController.addAction(createAction)
        present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOutside)))
        })
    
    }
    
    func presentErrorAlert()-> Void {
        let alert = UIAlertController(title: "Creation error", message: "Please enter a unique name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOutside)))
        })
        
    }
    
    @objc
    func tapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func goToWishListDetail(wishList: WishList) {
        let WLDetailController = WishListDetailViewController.newInstance(wishList: wishList)
        self.navigationController?.pushViewController(WLDetailController, animated: true)
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

    func sendMessage() {
        guard let phone = self.phoneNumber,
              let message = self.wishListSelected?.toMessageString() else {
            return;
        }
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [phone]
        composeVC.body = message
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func otherShare(wishlist: WishList) {
        
        let message = wishlist.toMessageString()
        let sharingItems: [Any] = [message]
        let activityController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)

        present(activityController, animated: true)
    }

}




extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listOfWishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.WishList.rawValue, for: indexPath) as! WishListTableViewCell
        let wishList = self.listOfWishList[indexPath.row]
        cell.nameLabel.text = wishList.name
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deletedWishList = self.listOfWishList[indexPath.row]
        self.wishListService.remove(wishList: deletedWishList, completion: {(err, isDeleted) in
            if(isDeleted){
                self.getAndSetListOfWishList()
                self.presentSuccessAlert()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = self.listOfWishList[sourceIndexPath.row]
        self.listOfWishList.remove(at: sourceIndexPath.row)
        self.listOfWishList.insert(tmp, at: destinationIndexPath.row)
        self.wishListService.updateList(wishListTab: self.listOfWishList, completion: {(err, isUpdated) in })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToWishListDetail(wishList: self.listOfWishList[indexPath.row])
    }
    
    func presentSuccessAlert()-> Void {
        let alert = UIAlertController(title: "WishList list updated !", message: "A WishList has been deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOutside)))
        })
    }
    
    func presentcontactchoice()-> Void {
        guard let phone = self.phoneNumber else {
            return
        }
        let alert = UIAlertController(title: "Send Message action", message: "Do you want to send your WishList to \(phone)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: {
                print("send to : \(phone)")
                self.sendMessage()
            })
        }))
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapOutside)))
        })
    }
    
    
    private func handleChooseContact() {
        self.present(self.contactVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let message = UIContextualAction(style: .normal, title: "Send Message") { [weak self] (action, view, completionHandler) in self?.handleChooseContact()
            self?.wishListSelected = self?.listOfWishList[indexPath.row]
            completionHandler(true)
        }
        message.backgroundColor = .systemGreen
        
        let share = UIContextualAction(style: .normal,
                                         title: "Share") { [weak self] (action, view, completionHandler) in
            guard let wishlist = self?.listOfWishList[indexPath.row] else {
                return
            }
            self?.otherShare(wishlist: wishlist)
            completionHandler(true)
        }
        share.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [message, share])
    }
    
}


extension HomeViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumber: String = contact.phoneNumbers[0].value.stringValue
        self.phoneNumber = phoneNumber
        self.contactVC.dismiss(animated: true, completion: {
            self.presentcontactchoice()
        })
    }
}

extension HomeViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

