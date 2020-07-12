//
//  AddPaymentsViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 17.01.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit

class AddPaymentsViewController: UIViewController {
    
    @IBOutlet weak var addPaymentsTableView: UITableView!
    @IBOutlet weak var cashTableView: UITableView!
    @IBOutlet weak var savedPaymentMethodTableView: UITableView!
    @IBOutlet weak var paymentsLabel: UILabel!
    @IBOutlet weak var defaultPaymentImg: UIImageView!
    
    var paymentOptions: [PaymentOptions] = []
    var payments: Bool = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBtnTapped(sender:)))
    }
    
    func setupElements(){
        savedPaymentMethodTableView.delegate = self
        savedPaymentMethodTableView.dataSource = self
        addPaymentsTableView.delegate = self
        addPaymentsTableView.dataSource = self
        
        //prevents empty cells from displaying
        savedPaymentMethodTableView.tableFooterView = UIView(frame: CGRect.zero)
        cashTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        createPaymentOptionArray()
        addCashOption()
    }
    
    @objc func editBtnTapped(sender: UIBarButtonItem) {
        if(savedPaymentMethodTableView.isEditing){
            sender.title = "Edit"
             self.savedPaymentMethodTableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
             self.savedPaymentMethodTableView.setEditing(true, animated: true)
        }
    }
    
    func createPaymentOptionArray(){
        let paymentOption1 = PaymentOptions(image: UIImage(named: "creditcard")!, title: "Add Credit Card")
        let paymentOption2 = PaymentOptions(image: UIImage(named: "paypal")!, title: "Add PayPal")
        
        paymentOptions.append(paymentOption1)
        paymentOptions.append(paymentOption2)
    }

    func addCashOption(){
        if(cashOptinGlobal.count == 0){
            let cashPayment = SavedCards(cardNumber: "Cash ", image: UIImage(named: "money")!, defaultImage: UIImage(named: "tick")!, isDefault: true)
            defaultPayment = cashPayment
            cashOptinGlobal.append(cashPayment)
        }
    }
}

extension AddPaymentsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == cashTableView){
            return cashOptinGlobal.count
        }else if(tableView == addPaymentsTableView){
            return paymentOptions.count
        } else if(tableView == savedPaymentMethodTableView){
            return savedCardsGlobal.count
        }
        return 0
    }
    
    func setNewPaymentEntryDefault(){
        if(defaultPaymentIndex == -1){
            defaultPaymentIndex = 0
            oldDefaultPaymentIndex = -1
        } else {
            oldDefaultPaymentIndex = defaultPaymentIndex
            defaultPaymentIndex =  savedCardsGlobal.count
            if(oldDefaultPaymentIndex > defaultPaymentIndex){
                oldDefaultPaymentIndex = defaultPaymentIndex - 2
            } else if(oldDefaultPaymentIndex == defaultPaymentIndex){
                oldDefaultPaymentIndex = defaultPaymentIndex - 1
            }
            
            if(oldDefaultPaymentIndex > -1){
                let paymentcell = savedPaymentMethodTableView.cellForRow(at: IndexPath(row: oldDefaultPaymentIndex, section: 0)) as! SavedPaymentsTableViewCell
                paymentcell.defaultPaymentImg.isHidden = true
                paymentcell.savePaymentBtn.isHidden = false
                savedCardsGlobal[oldDefaultPaymentIndex].isDefault = false
            }
        }
    }
    
    func setSelectedPaymentEntryDefault(selectedPaymentIndex: Int){
            oldDefaultPaymentIndex = defaultPaymentIndex
            defaultPaymentIndex =  selectedPaymentIndex
        
            if(oldDefaultPaymentIndex == defaultPaymentIndex){
                oldDefaultPaymentIndex = oldDefaultPaymentIndex - 1
            }
        
            
            if(oldDefaultPaymentIndex < savedCardsGlobal.count && oldDefaultPaymentIndex > -1){
                let oldPaymentcell = savedPaymentMethodTableView.cellForRow(at: IndexPath(row: oldDefaultPaymentIndex, section: 0)) as! SavedPaymentsTableViewCell
                oldPaymentcell.defaultPaymentImg.isHidden = true
                oldPaymentcell.savePaymentBtn.isHidden = false
                savedCardsGlobal[oldDefaultPaymentIndex].isDefault = false

            }
            if(cashOptinGlobal[0].isDefault == true){
                let cashcell = cashTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CashTableViewCell
                cashcell.setDefaultBtn.isHidden = false
                cashcell.defaultImg.isHidden = true
                cashOptinGlobal[0].isDefault = false
            }
        
            let newPaymentcell = savedPaymentMethodTableView.cellForRow(at: IndexPath(row: defaultPaymentIndex, section: 0)) as! SavedPaymentsTableViewCell
            newPaymentcell.defaultPaymentImg.isHidden = false
            newPaymentcell.savePaymentBtn.isHidden = true
            savedCardsGlobal[defaultPaymentIndex].isDefault = true
            defaultPayment = savedCardsGlobal[defaultPaymentIndex]
    }
    
    func deletedDefaultPayment(deleteSelectedPaymentIndex: Int){
        
        oldDefaultPaymentIndex = deleteSelectedPaymentIndex - 2
        defaultPaymentIndex = deleteSelectedPaymentIndex - 1
    
        if(defaultPaymentIndex == -1 && savedCardsGlobal.count > 0) {
            defaultPaymentIndex = savedCardsGlobal.count - 1
            oldDefaultPaymentIndex = defaultPaymentIndex - 1
        }
        
        if(defaultPaymentIndex > -1){
            let newPaymentcell = savedPaymentMethodTableView.cellForRow(at: IndexPath(row: defaultPaymentIndex, section: 0)) as! SavedPaymentsTableViewCell
            newPaymentcell.defaultPaymentImg.isHidden = false
            newPaymentcell.savePaymentBtn.isHidden = true
            savedCardsGlobal[defaultPaymentIndex].isDefault = true
            defaultPayment = savedCardsGlobal[defaultPaymentIndex]
            
            if(oldDefaultPaymentIndex > -1){
                let oldPaymentcell = savedPaymentMethodTableView.cellForRow(at: IndexPath(row: oldDefaultPaymentIndex, section: 0)) as! SavedPaymentsTableViewCell
                oldPaymentcell.defaultPaymentImg.isHidden = true
                oldPaymentcell.savePaymentBtn.isHidden = false
                savedCardsGlobal[oldDefaultPaymentIndex].isDefault = false
            }
        }
    }
    
    
    
    func insertSavedPayments(cardEnding: String){
        setNewPaymentEntryDefault()
        
        let savedPayment1 = SavedCards(cardNumber: "Card ends with " + cardEnding, image: UIImage(named: "mastercard")!, defaultImage: UIImage(named: "tick")!, isDefault: true)
        defaultPayment = savedPayment1
        savedCardsGlobal.append(savedPayment1)
        let indexPath = IndexPath(row: savedCardsGlobal.count - 1, section: 0)
        
       
        let cashcell = cashTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CashTableViewCell
        cashcell.setDefaultBtn.isHidden = false
        cashcell.defaultImg.isHidden = true
        cashOptinGlobal[0].isDefault = false
        
        savedPaymentMethodTableView.beginUpdates()
        savedPaymentMethodTableView.insertRows(at: [indexPath], with: .automatic)
        savedPaymentMethodTableView.endUpdates()
        savedPaymentMethodTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == cashTableView) {
            print("inside cash TB")
            let savedPayment =  cashOptinGlobal[indexPath.row]
            let cashCell = tableView.dequeueReusableCell(withIdentifier: "cashCell", for: indexPath) as! CashTableViewCell
            cashCell.setPaymentMethod(savedCards: savedPayment)
            cashCell.tintColor = UIColor(red: 1/255.0, green: 77/255.0, blue: 103.0/255.0, alpha: 1.0)
            if(cashOptinGlobal[0].isDefault == true){
                cashCell.setDefaultBtn.isHidden = true
                cashCell.defaultImg.isHidden = false
            } else {
                cashCell.setDefaultBtn.isHidden = false
                 cashCell.defaultImg.isHidden = true
            }
            cashCell.delegate = self
            return cashCell
            
        } else if (tableView == addPaymentsTableView) {
            let paymentOption = paymentOptions[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentOptions", for: indexPath) as! AddPaymentsTableViewCell
            cell.setPaymentOptions(paymentOption: paymentOption)
            cell.tintColor = UIColor(red: 1/255.0, green: 77/255.0, blue: 103.0/255.0, alpha: 1.0)
            
            return cell
            
        } else if(tableView == savedPaymentMethodTableView){
            
            let savedPayment =  savedCardsGlobal[indexPath.row]
            let paymentcell = tableView.dequeueReusableCell(withIdentifier: "savedCards", for: indexPath) as! SavedPaymentsTableViewCell
            paymentcell.setPaymentMethod(savedCards: savedPayment)
            paymentcell.tintColor = UIColor(red: 1/255.0, green: 77/255.0, blue: 103.0/255.0, alpha: 1.0)
            
            if(savedCardsGlobal[indexPath.row].isDefault == true){
                paymentcell.defaultPaymentImg.isHidden = false
                paymentcell.savePaymentBtn.isHidden = true
            } else {
                paymentcell.defaultPaymentImg.isHidden = true
                paymentcell.savePaymentBtn.isHidden = false
            }
           
            paymentcell.cellDelegate = self
            paymentcell.indexPath = indexPath
            return paymentcell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == addPaymentsTableView {
            if(indexPath.row == 0){
                let vc = storyboard?.instantiateViewController(withIdentifier: "AddCreditCard") as? SaveCardViewController
                vc!.viewParentController = self
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if(indexPath.row == 1){
                let vc = storyboard?.instantiateViewController(withIdentifier: "toWIP") as? WIPViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == savedPaymentMethodTableView {
         return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == savedPaymentMethodTableView {
            if(editingStyle == .delete){
                if(savedCardsGlobal[indexPath.row].isDefault == true){
                    deletedDefaultPayment(deleteSelectedPaymentIndex: indexPath.row)
                } else{
                    oldDefaultPaymentIndex = oldDefaultPaymentIndex-1
                    defaultPaymentIndex = defaultPaymentIndex-1
                }
                
                savedCardsGlobal.remove(at: indexPath.row)
                savedPaymentMethodTableView.beginUpdates()
                savedPaymentMethodTableView.deleteRows(at: [indexPath], with: .automatic)
                savedPaymentMethodTableView.endUpdates()
                savedPaymentMethodTableView.reloadData()
                if(savedCardsGlobal.count == 0){
                    let cashcell = cashTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CashTableViewCell
                    cashcell.setDefaultBtn.isHidden = true
                    cashcell.defaultImg.isHidden = false
                    cashOptinGlobal[0].isDefault = true
                    defaultPayment = cashOptinGlobal[0]
                }
            }
        }
    }
}

extension AddPaymentsViewController: SavedPaymentProtocol{
    func setAsDefault(index: Int) {
        setSelectedPaymentEntryDefault(selectedPaymentIndex: index)
    }
}

extension AddPaymentsViewController: CashCellProtocol{
    func setAsDefault(){
        let cashcell = cashTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CashTableViewCell
        cashcell.setDefaultBtn.isHidden = true
        cashcell.defaultImg.isHidden = false
        cashOptinGlobal[0].isDefault = true
        defaultPayment = cashOptinGlobal[0]
        print("default Payment is \(defaultPaymentIndex)")
        let newPaymentcell = savedPaymentMethodTableView.cellForRow(at: IndexPath(row: defaultPaymentIndex, section: 0)) as! SavedPaymentsTableViewCell
        newPaymentcell.defaultPaymentImg.isHidden = true
         newPaymentcell.savePaymentBtn.isHidden = false
        savedCardsGlobal[defaultPaymentIndex].isDefault = false
    }
}
