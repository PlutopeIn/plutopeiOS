//
//  WalletSetUpInteractor.swift
//  Plutope
//
//  Created by Trupti Mistry on 06/02/25.
//

final class WalletSetUpInteractor {

    private let accountStorage: AccountStorage

    init(accountStorage: AccountStorage) {
        self.accountStorage = accountStorage
    }

    func save(importAccount: ImportAccount) {
        accountStorage.importAccount = importAccount
    }
}
