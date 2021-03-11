//
//  HNHomeViewController.swift
//  HNAssignment
//
//  Created by NGUYEN HUNG on 3/10/21 on 1/23/21.
//

import UIKit
import HNService
import RxCocoa
import RxSwift
import HNDesignSystem
import RxDataSources

protocol HNHomePresentableListener: class {
    var refreshTrigger: PublishRelay<Void> { get }
    var searchTrigger: PublishRelay<String> { get }
    var didSelectForecastTrigger: PublishRelay<HNHomeWeatherCellViewModel?> { get }
}

class HNHomeViewController: UIViewController, HomeViewModelPresentable {
    // Presenter
    weak var listener: HNHomePresentableListener?
    let homeCellViewModels = BehaviorRelay<[HNHomeWeatherCellViewModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let showErrorMessage = PublishRelay<String>()
    
    // IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // Variable
    typealias Section = SectionModel<String, HNHomeWeatherCellViewModel>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    private lazy var dataSource = initDataSource()
    
    let refreshControl = UIRefreshControl()

    let disposeBag = DisposeBag()

    let viewModel = HNHomeViewModel(
        getMoviesUseCase: HNGetForecastDailyUseCase(
            repository: HNForecastDataRespository(
                movieService: HNWeatherService()
            )
        )
    )
}

// MARK: - Life cycle
extension HNHomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchBar()
        configureViewModel()
        configurePresenter()
        configureListener()
        configureRefreshControl()
    }
}

// MARK: - Configure
extension HNHomeViewController {
    private func configureViewModel() {
        viewModel.presenter = self
        viewModel.router = self
        viewModel.didBecomeActive()
    }
    
    private func configurePresenter() {
        homeCellViewModels
            .asDriver(onErrorJustReturn: [])
            .map { [Section(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        isLoading
            .asDriver()
            .map { !$0 }
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        showErrorMessage
            .subscribeNext { errorMessage in
                print(errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureListener() {
        guard let listener = listener else {
            return
        }
        
        tableView
            .rx.modelSelected(HNHomeWeatherCellViewModel.self)
            .subscribeNext { [weak self] model in
                self?.listener?.didSelectForecastTrigger.accept(model)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .map { $0 ?? "" }
            .bind(to: listener.searchTrigger)
            .disposed(by: disposeBag)
    }
    
    private func configureRefreshControl() {
        refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.beginRefreshing()
                self.listener?.refreshTrigger.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    private func beginRefreshing() {
        Observable<Int>.timer(.milliseconds(500), scheduler: MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        title = R.string.localizable.homeNavTitle()
        refreshControl.tintColor = Colors.ink500
        tableView.refreshControl = refreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "abc")
        tableView.register(R.nib.hnWeatherTableViewCell)
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Your place"
        navigationItem.titleView = searchBar
    }
}

// MARK: - TableView
extension HNHomeViewController {
    func initDataSource() -> RxTableViewSectionedReloadDataSource<Section> {
        return RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { (_, tableView, indexPath, model) -> UITableViewCell in
                let cell: HNWeatherTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: R.reuseIdentifier.hnWeatherTableViewCell, for: indexPath
                )!

                cell.model = model
                return cell
        })
    }
}

// MARK: - Router
extension HNHomeViewController: HomeViewModelRouting {
    func goToWeatherDetail() {
        // Will navigation to another screen
    }
}
