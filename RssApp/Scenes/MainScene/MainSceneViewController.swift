//
//  MainViewController.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 22.12.2024.
//

import Swinject
import UIKit

final class MainSceneViewController: CollectionViewController {
    // MARK: - PROPERTIES
    private let viewModel: MainSceneViewModel
    private var newsItems: [NewsItem] = []
    private var updateTimer: Timer?
    private let router = Router.shared
    
    // MARK: - LIFE CYCLE
    init(viewModel: MainSceneViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObservers(observerTypes: [.updateTimerIntervalChanged, .cacheIsCleared])
        
        title = "Новости"
        setupNavigationBar(rightBarButtonImage: UIImage(systemName: "gearshape"), action: #selector(openSettings))
        
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        
        updateNews()
        startUpdateTimer(interval: 300)
    }
    
    override func handleNotification(_ notificationName: Notification.Name, notificationObject: Any?) {
        notificationSwitcher(notificationName, notificationObject: notificationObject)
    }
    
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        let newsItem = newsItems[indexPath.item]
        cell.configure(with: newsItem)
        if let imageURL = newsItem.enclosure {
            viewModel.loadImage(for: imageURL) { imageData in
                if let imageData {
                    cell.setImage(UIImage(data: imageData))
                } else {
                    cell.setImage(nil)
                }
            }
        } else {
            cell.setImage(nil)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var newsItem = newsItems[indexPath.item]
        
        guard let url = URL(string: newsItem.link) else { return }
        
        newsItem.isRead = true
        
        viewModel.updateNewsStatus(newsItem: newsItem) { updatedNewsItem in
            guard let updatedNewsItem = updatedNewsItem else { return }
            self.newsItems[indexPath.item] = updatedNewsItem
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        let webViewController = WebViewController()
        webViewController.url = url
        
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

private extension MainSceneViewController {
    @objc func openSettings() {
        let settingsVC = router.openSettingsScene()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func notificationSwitcher(_ notificationName: Notification.Name, notificationObject: Any?) {
        switch notificationName {
        case .cacheIsCleared:
            updateNews()
        case .updateTimerIntervalChanged:
            handleTimerIntervalChange(Notification(name: notificationName, object: notificationObject))
        default:
            break
        }
    }
    
    func handleTimerIntervalChange(_ notificationObject: Any?) {
        guard let newInterval = notificationObject as? TimeInterval else { return }
        startUpdateTimer(interval: newInterval)
    }
    
    func updateNews() {
        viewModel.fetchNews { [weak self] newsItems in
            DispatchQueue.main.async {
                self?.newsItems = newsItems
                self?.collectionView.reloadData()
            }
        }
    }
    
    func startUpdateTimer(interval: TimeInterval) {
        updateTimer?.invalidate()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.updateNews()
        }
    }
    
    func stopUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}
