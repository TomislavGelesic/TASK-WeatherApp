//
//  SearchSceneViewController.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 15.01.2021..
//

import UIKit
import Combine

class SearchSceneViewController: UIViewController {
    
    var disposeBag = Set<AnyCancellable>()
    
    var viewModel: SearchSceneViewModel
    
    var coordinator: SearchSceneCoordinator
   
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "body_image-clear-day")
        return imageView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "multiply.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .black
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
        
    let inputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return textField
    }()
    
    
    let searchIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let searchIconView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init(coordinator: SearchSceneCoordinator, viewModel: SearchSceneViewModel) {
        
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = false
        setupViews()
        setupKeyboardNotifications()
        setConstraints()
        setSubscribers()
        view.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        inputField.becomeFirstResponder()
    }
    
}

extension SearchSceneViewController {
    
    func setupViews() {
        
        view.addSubviews([backgroundImageView, cancelButton, tableView, inputField])
        
        searchIconView.addSubview(searchIcon)
        
        inputField.delegate = self
        inputField.leftViewMode = .always
        inputField.leftView = searchIconView
        inputField.addTarget(self, action: #selector(inputFieldDidChange), for: .allEditingEvents)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        cancelButton.addTarget(self, action: #selector(cancellSearchTapped), for: .touchUpInside)
    }
    
    @objc func inputFieldDidChange() {
        
        if let validText = inputField.text {
            
            if validText.isEmpty == false {
                
                let cityPath = "\(Constants.GeoNamesORG.BASE)\(Constants.GeoNamesORG.GET_CITY_BY_NAME)\(validText)\(Constants.GeoNamesORG.MAX_ROWS)\(10)\(Constants.GeoNamesORG.KEY)"
                
                guard let getCityURLPath = URL(string: cityPath) else { return }
                
                viewModel.searchNewCitiesSubject.send(getCityURLPath)
            } else {
            
                viewModel.viewModelData.removeAll()
                viewModel.refreshUISubject.send()
            }
        }
        
    }
    
    @objc func cancellSearchTapped() {
        
        coordinator.goToHomeScene(selectedCity_id: nil)
    }
    
    func setupKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        else { return }
        
        let newBottomOffset_inputField = view.frame.height - keyboardEndFrame.height - 45
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
    
        UIView.animate(
            withDuration: duration * 2,
            delay: TimeInterval(1),
            options: animationCurve,
            animations: { [unowned self] in
                
                self.setConstraints_inputField(for: newBottomOffset_inputField)
                self.inputField.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        
        let newBottomOffset = view.frame.height/4
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { [unowned self] in
                
                self.setConstraints_inputField(for: newBottomOffset)
                self.inputField.layoutIfNeeded()
            },
            completion: nil
        )
        
        coordinator.goToHomeScene(selectedCity_id: nil)
        
    }
    
    func setConstraints() {
        
        setConstraints_backgroundImageView()
        setConstraints_cancelButton()
        setConstraints_availableCitiesTableView()
        setConstraints_searchIcon()
        setConstraints_searchIconView()
        setConstraints_inputField(for: 100)
    }
    
    func setConstraints_backgroundImageView() {
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setConstraints_cancelButton() {
        cancelButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.trailing.equalTo(view).inset(UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5))
        }
    }
    
    func setConstraints_availableCitiesTableView() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(cancelButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(200)
        }
    }
    
    func setConstraints_searchIcon() {
        
        searchIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerX.equalTo(searchIconView)
        }
    }
    
    func setConstraints_searchIconView() {
        searchIconView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
        }
    }
    
    func setConstraints_inputField(for bottomOffset: CGFloat) {
        
        inputField.snp.remakeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: bottomOffset, right: 5))
        }
    }
    
    func setSubscribers() {
        
        viewModel.initializeSearchSubject(subject: viewModel.searchNewCitiesSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        viewModel.alertSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (message) in
                self.showAPIFailedAlert(for: message, completion: nil)
            }
            .store(in: &disposeBag)
        
        viewModel.spinnerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (isVisible) in
                
                isVisible ? self.showSpinner() : self.hideSpinner()
            })
            .store(in: &disposeBag)
        
        viewModel.refreshUISubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (_) in
    
                self.tableView.reloadData()
            }
            .store(in: &disposeBag)
    }
}

extension SearchSceneViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        inputField.resignFirstResponder()
        return true
    }
}

extension SearchSceneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewModelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: viewModel.getScreenData(for: indexPath.row))
        return cell
    }
}

extension SearchSceneViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = viewModel.viewModelData[indexPath.row]
        coordinator.goToHomeScene(selectedCity_id: item.geonameId)
    }
}


