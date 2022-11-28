import Foundation
import WalletConnectUtils

public struct WalletPushClientFactory {

    public static func create(networkInteractor: NetworkInteracting, pairingRegisterer: PairingRegisterer) -> WalletPushClient {
        let logger = ConsoleLogger(loggingLevel: .off)
        let keyValueStorage = UserDefaults.standard
        let keychainStorage = KeychainStorage(serviceIdentifier: "com.walletconnect.sdk")
        return WalletPushClientFactory.create(
            logger: logger,
            keyValueStorage: keyValueStorage,
            keychainStorage: keychainStorage,
            networkInteractor: networkInteractor,
            pairingRegisterer: pairingRegisterer
        )
    }

    static func create(logger: ConsoleLogging, keyValueStorage: KeyValueStorage, keychainStorage: KeychainStorageProtocol, networkInteractor: NetworkInteracting, pairingRegisterer: PairingRegisterer) -> WalletPushClient {
        let kms = KeyManagementService(keychain: keychainStorage)
        let httpClient = HTTPNetworkClient(host: "echo.walletconnect.com")
        let registerService = PushRegisterService(networkInteractor: networkInteractor, httpClient: httpClient)
        let history = RPCHistoryFactory.createForNetwork(keyValueStorage: keyValueStorage)

        let proposeResponder = ProposeResponder(networkingInteractor: networkInteractor, logger: logger, kms: kms, rpcHistory: history)
        return WalletPushClient(
            logger: logger,
            kms: kms,
            registerService: registerService,
            pairingRegisterer: pairingRegisterer,
            proposeResponder: proposeResponder
        )
    }
}
