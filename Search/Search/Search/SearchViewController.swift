import RIBs
import RxSwift
import SnapKit
import UIKit

protocol SearchPresentableListener: AnyObject {

    func viewDidLoad()
    func deleteRecentKeyword(_ keyword: String)
    func deleteAllRecentKeywords()
    func filterRecentKeywords(with text: String)
}

protocol SearchResultPresentableListener: AnyObject {

    func search(with keyword: String)
    func didSelectItem(_ item: SearchResultItem)
}

final class SearchViewController: UIViewController, SearchPresentable, SearchResultPresentable, SearchViewControllable, SearchResultViewControllable {

    weak var searchListener: SearchPresentableListener?
    weak var searchResultListener: SearchResultPresentableListener?

    // MARK: - UI
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 8, y: 0, width: 20, height: 20)
        iconContainer.addSubview(iconView)
        textField.leftView = iconContainer
        textField.leftViewMode = .always
        textField.placeholder = "저장소"
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        return textField
    }()

    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionHeaderTopPadding = 0
        tableView.register(RecentKeywordCell.self, forCellReuseIdentifier: RecentKeywordCell.Const.identifier)
        tableView.register(FilteredRecentKeywordCell.self, forCellReuseIdentifier: FilteredRecentKeywordCell.Const.identifier)
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.Const.identifier)
        tableView.register(RecentKeywordHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentKeywordHeaderView.Const.identifier)
        tableView.register(RecentKeywordFooterView.self, forHeaderFooterViewReuseIdentifier: RecentKeywordFooterView.Const.identifier)
        return tableView
    }()

    private let loadingContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.6)
        view.isHidden = true
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<SearchInteractor.SearchSection, SearchInteractor.SearchItem> = makeDataSource()
}

// MARK: - Lifecycle
extension SearchViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        searchListener?.viewDidLoad()
    }
}

// MARK: - SearchPresentable
extension SearchViewController {

    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<SearchInteractor.SearchSection, SearchInteractor.SearchItem>) {
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - SearchResultPresentable
extension SearchViewController {

    func showLoading() {
        loadingContainerView.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        loadingContainerView.isHidden = true
        activityIndicator.stopAnimating()
    }

    func presentWebView(url: URL) {
        let webViewController = WebViewController(url: url)
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

// MARK: - RecentKeywordCellDelegate
extension SearchViewController: RecentKeywordCellDelegate {

    func deleteKeywordTapped(on cell: RecentKeywordCell) {
        guard let indexPath = resultTableView.indexPath(for: cell),
              case .recentKeyword(let keyword) = dataSource.itemIdentifier(for: indexPath) else { return }
        searchListener?.deleteRecentKeyword(keyword.keyword)
    }
}

// MARK: - RecentKeywordFooterViewDelegate
extension SearchViewController: RecentKeywordFooterViewDelegate {

    func deleteAllKeywordTapped(on footer: RecentKeywordFooterView) {
        searchListener?.deleteAllRecentKeywords()
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if resultTableView.contentOffset.y <= 0 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text, !keyword.isEmpty else { return false }
        searchResultListener?.search(with: keyword)
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataSource.sectionIdentifier(for: section) == .recentKeyword else { return nil }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentKeywordHeaderView.Const.identifier)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard dataSource.sectionIdentifier(for: section) == .recentKeyword else { return nil }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentKeywordFooterView.Const.identifier) as? RecentKeywordFooterView
        footer?.delegate = self
        return footer
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource.itemIdentifier(for: indexPath) {
        case .recentKeyword(let keyword):
            searchTextField.text = keyword.keyword
            searchTextField.resignFirstResponder()
            searchResultListener?.search(with: keyword.keyword)
        case .filteredRecentKeyword(let keyword):
            searchTextField.text = keyword.keyword
            searchTextField.resignFirstResponder()
            searchResultListener?.search(with: keyword.keyword)
        case .searchResult(let item):
            searchResultListener?.didSelectItem(item)
        default:
            break
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldHide = scrollView.contentOffset.y > 0
        if navigationController?.navigationBar.isHidden != shouldHide {
            navigationController?.setNavigationBarHidden(shouldHide, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        dataSource.sectionIdentifier(for: section) == .recentKeyword ? 44 : 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        dataSource.sectionIdentifier(for: section) == .recentKeyword ? 44 : 0
    }
}

// MARK: - Private
extension SearchViewController {

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        resultTableView.delegate = self
        view.addSubview(searchTextField)
        view.addSubview(resultTableView)
        view.addSubview(loadingContainerView)
        loadingContainerView.addSubview(activityIndicator)
    }

    private func setupLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        resultTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        loadingContainerView.snp.makeConstraints {
            $0.edges.equalTo(resultTableView)
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        searchListener?.filterRecentKeywords(with: textField.text ?? "")
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<SearchInteractor.SearchSection, SearchInteractor.SearchItem> {
        UITableViewDiffableDataSource(tableView: resultTableView) { tableView, indexPath, item in
            switch item {
            case .recentKeyword(let keyword):
                let cell = tableView.dequeueReusableCell(withIdentifier: RecentKeywordCell.Const.identifier, for: indexPath) as? RecentKeywordCell
                cell?.configure(with: keyword)
                cell?.delegate = self
                return cell ?? UITableViewCell()
            case .filteredRecentKeyword(let keyword):
                let cell = tableView.dequeueReusableCell(withIdentifier: FilteredRecentKeywordCell.Const.identifier, for: indexPath) as? FilteredRecentKeywordCell
                cell?.configure(with: keyword)
                return cell ?? UITableViewCell()
            case .searchResult(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.Const.identifier, for: indexPath) as? SearchResultCell
                cell?.configure(with: item)
                return cell ?? UITableViewCell()
            }
        }
    }
}
