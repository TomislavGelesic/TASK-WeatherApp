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
    
    let searchIconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    
    deinit {
        print("SearchSceneViewController deinit")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init(viewModel: SearchSceneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupKeyboardNotifications()
        setConstraints()
        setSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputField.becomeFirstResponder()
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

extension SearchSceneViewController {
    
    func setupViews() {
        view.backgroundColor = .lightGray
        view.addSubviews([cancelButton, tableView, inputField])
        searchIconContainer.addSubview(searchIcon)
        inputField.delegate = self
        inputField.leftViewMode = .always
        inputField.leftView = searchIconContainer
        inputField.leftView?.layoutIfNeeded()
        inputField.addTarget(self, action: #selector(inputFieldDidChange), for: .allEditingEvents)
        tableView.dataSource = self
        tableView.delegate = self
        cancelButton.addTarget(self, action: #selector(cancelSearchTapped), for: .touchUpInside)
    }
    
    @objc func inputFieldDidChange() {
        guard let validText = inputField.text else { return }
        validText.isEmpty ? viewModel.search(text: nil) : viewModel.search(text: validText)
    }
    
    @objc func cancelSearchTapped() { viewModel.didSelectCancel() }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardEndFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        else { return }
        
        let newBottomOffset_inputField = keyboardEndFrame.height + 10
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(
            withDuration: duration * 2,
            delay: TimeInterval(1),
            options: animationCurve,
            animations: { [unowned self] in                
                self.setConstraintsOnInputField(for: newBottomOffset_inputField)
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
                self.setConstraintsOnInputField(for: newBottomOffset)
                self.inputField.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func setSubscribers() {
        
        viewModel.spinnerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (value) in
                value ? self.showSpinner() : self.hideSpinner()
            }
            .store(in: &disposeBag)
        
        viewModel.alertSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (message) in
                self.showAlert(text: message) { }
            }
            .store(in: &disposeBag)
        
        viewModel.initializeSearchSubject(subject: viewModel.searchSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        viewModel.refreshUISubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (_) in
                
                if let text = inputField.text,
                   text.isEmpty {
                    viewModel.screenData.removeAll()
                }
                self.tableView.reloadData()
            }
            .store(in: &disposeBag)
    }
}

extension SearchSceneViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputField.resignFirstResponder()
        viewModel.didSelectCancel()
        return true
    }
}

extension SearchSceneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: viewModel.getScreenData(for: indexPath.row))
        return cell
    }
}

extension SearchSceneViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCity(at: indexPath.row)
        inputField.text = ""
        inputField.resignFirstResponder()
    }
}


//MARK: CONSTRAINTS BELOW

extension SearchSceneViewController {
    
    func setConstraints() {
        setConstraintsOnCancelButton()
        setConstraintsOnAvailableCitiesTableView()
        setConstraintsOnSearchIcon()
        setConstraintsOnSearchIconContainer()
        setConstraintsOnInputField(for: 100)
    }
    
    func setConstraintsOnCancelButton() {
        cancelButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.trailing.equalTo(view).inset(UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
        }
    }
    
    func setConstraintsOnAvailableCitiesTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(cancelButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(330)
        }
    }
    
    func setConstraintsOnSearchIcon() {
        searchIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerX.centerY.equalTo(searchIconContainer)
        }
    }
    
    func setConstraintsOnSearchIconContainer() {
        searchIconContainer.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
    }
    
    func setConstraintsOnInputField(for bottomInset: CGFloat) {
        inputField.snp.remakeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: bottomInset, right: 5))
            make.height.equalTo(20)
        }
    }
}

