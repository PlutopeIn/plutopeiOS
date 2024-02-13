//
//  SelectWalletBackUpViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit
class SelectWalletBackUpViewController: UIViewController, Reusable {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvBackup: UITableView!
    @IBOutlet weak var lblChooseBackup: UILabel!
    
    var arrBackupWallets: [WalletBackUpData]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation header
        defineHeader(headerView: headerView, titleText: StringConstants.selectBackup)
        self.lblChooseBackup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.choosethebackupforthewalletyouwanttorestore, comment: "")
        
        /// Table Register
        tableRegister()
        // getBackUpFiles
        getBackUpFiles()
    }
    
    /// get backup files
    func getBackUpFiles() {
        guard let iCloudContainerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            let error = NSError(domain: "com.plutoPe.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get iCloud container URL"])
            self.showICloudPopup()
            self.tbvBackup.setEmptyMessage("No backup file found!", font: UIFont.systemFont(ofSize: 15), textColor: .gray)
            self.lblChooseBackup.isHidden = true
            return
        }
        BackupWallet.shared.getFilesFromICloudDrive(iCloudContainerURL: iCloudContainerURL) { result in
            switch result {
            case .success(let fileURLsWithCreationDates):
                // Process the array of tuples
                for (url, creationDate) in fileURLsWithCreationDates {
                    // Process the data as needed
                    print("File URL: \(url)")
                    print("Creation Date: \(creationDate)")

                    self.arrBackupWallets?.append(WalletBackUpData(title: url.lastPathComponent, date: creationDate.toString(format: "dd MMM yyyy"), time: creationDate.toString(format: "hh:mm a")))
                }
                if self.arrBackupWallets?.count == 0 {
                    self.tbvBackup.setEmptyMessage("No backup file found!", font: UIFont.systemFont(ofSize: 15), textColor: .gray)
                    self.lblChooseBackup.isHidden = true
                } else {
                    self.lblChooseBackup.isHidden = false
                    self.tbvBackup.reloadData()
                    self.tbvBackup.restore()
                }
                
            case .failure(let error):
                // Handle the error
                self.tbvBackup.setEmptyMessage("No backup file found!", font: UIFont.systemFont(ofSize: 15), textColor: .gray)
                self.lblChooseBackup.isHidden = true
                print("Error: \(error)")
            }
        }
    }
    
    /// Table register
    func tableRegister() {
        tbvBackup.delegate = self
        tbvBackup.dataSource = self
        tbvBackup.register(WalletBackupViewCell.nib, forCellReuseIdentifier: WalletBackupViewCell.reuseIdentifier)
        tbvBackup.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
    }
}
