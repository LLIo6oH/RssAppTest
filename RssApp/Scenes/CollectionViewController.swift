//
//  CollectionViewController.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 24.12.2024.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: - PROPERTIES
    let action: Selector? = nil
    let rightBarButtonImage: UIImage? = nil
    
    // MARK: - LIFE CYCLE
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
    }
    
    // MARK: - SUBSCRIPTIONS
    func setObservers(observerTypes: [Notification.Name]) {
        for observerType in observerTypes {
            NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: observerType, object: nil)
        }
    }
    
    @objc func receiveNotification(_ notification: Notification) {
        handleNotification(notification.name, notificationObject: notification.object)
    }
    
    func handleNotification(_ notificationName: Notification.Name, notificationObject: Any?) {
        fatalError("Fatal error: Shouldn't be called")
    }
    
    // MARK: - UI
    func setupNavigationBar(rightBarButtonImage: UIImage?, action: Selector?) {
        if let rightBarButtonImage = rightBarButtonImage, let action = action {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: rightBarButtonImage,
                style: .plain,
                target: self,
                action: action
            )
        }
    }
}
