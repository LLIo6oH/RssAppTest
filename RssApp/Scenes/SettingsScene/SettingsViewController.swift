//
//  SettingsViewController.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    // MARK: - PROPERTIES
    private let viewModel: SettingsViewModel
    private let timerLabel = UILabel()
    private let timerTextField = UITextField()
    private let clearCacheButton = UIButton(type: .system)
    private let setTimeButton = UIButton(type: .system)
    
    // MARK: - LIFE CYCLE
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Настройки"
        
        setupUI()
    }
}

private extension SettingsViewController {
    func setupUI() {
        timerLabel.text = "Интервал обновления (в секундах):"
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textColor = .black
        view.addSubview(timerLabel)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        timerTextField.borderStyle = .roundedRect
        timerTextField.placeholder = "Введите интервал"
        timerTextField.keyboardType = .numberPad
        timerTextField.translatesAutoresizingMaskIntoConstraints = false
        timerTextField.backgroundColor = .clear
        timerTextField.textColor = .black
        timerTextField.attributedPlaceholder = NSAttributedString(string: "Введите интервал", attributes: placeholderAttributes)
        view.addSubview(timerTextField)
        
        setTimeButton.setTitle("Задать интервал", for: .normal)
        setTimeButton.addTarget(self, action: #selector(setUpdateInterval), for: .touchUpInside)
        setTimeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(setTimeButton)
        
        clearCacheButton.setTitle("Очистить кэш", for: .normal)
        clearCacheButton.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
        clearCacheButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearCacheButton)
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            timerTextField.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10),
            timerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            setTimeButton.topAnchor.constraint(equalTo: timerTextField.bottomAnchor, constant: 20),
            setTimeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clearCacheButton.topAnchor.constraint(equalTo: setTimeButton.bottomAnchor, constant: 20),
            clearCacheButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func clearCache() {
        viewModel.clearImageCache()
        let alert = UIAlertController(title: "Кэш очищен", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func setUpdateInterval() {
        let intervalText = timerTextField.text ?? ""
        let interval = TimeInterval(intervalText) ?? 300
        
        viewModel.setUpdateInterval(interval)
        
        let alert = UIAlertController(title: "Таймер установлен", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
