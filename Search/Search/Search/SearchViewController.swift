import RIBs
import RxSwift
import SnapKit
import UIKit

protocol SearchPresentableListener: AnyObject {
    func viewDidLoad()
    func search(with keyword: String)
    func deleteRecentKeyword(_ keyword: String)
    func deleteAllRecentKeywords()
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?

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
        tableView.register(RecentKeywordHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentKeywordHeaderView.identifier)
        tableView.register(RecentKeywordFooterView.self, forHeaderFooterViewReuseIdentifier: RecentKeywordFooterView.identifier)
        return tableView
    }()

    private lazy var dataSource: UITableViewDiffableDataSource<SearchInteractor.SearchSection, SearchInteractor.SearchItem> = makeDataSource()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        listener?.viewDidLoad()
    }
}

// MARK: - SearchPresentable
extension SearchViewController {
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<SearchInteractor.SearchSection, SearchInteractor.SearchItem>) {
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - RecentKeywordCellDelegate
extension SearchViewController: RecentKeywordCellDelegate {
    func recentKeywordCellDidTapDelete(_ cell: RecentKeywordCell) {
        guard let indexPath = resultTableView.indexPath(for: cell),
              case .recentKeyword(let keyword) = dataSource.itemIdentifier(for: indexPath) else { return }
        listener?.deleteRecentKeyword(keyword.keyword)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text, !keyword.isEmpty else { return false }
        listener?.search(with: keyword)
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataSource.sectionIdentifier(for: section) == .recentKeyword else { return nil }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentKeywordHeaderView.identifier)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard dataSource.sectionIdentifier(for: section) == .recentKeyword else { return nil }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecentKeywordFooterView.identifier) as? RecentKeywordFooterView
        footer?.onDeleteAll = { [weak self] in
            self?.listener?.deleteAllRecentKeywords()
        }
        return footer
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
        resultTableView.delegate = self
        view.addSubview(searchTextField)
        view.addSubview(resultTableView)
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
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<SearchInteractor.SearchSection, SearchInteractor.SearchItem> {
        UITableViewDiffableDataSource(tableView: resultTableView) { tableView, indexPath, item in
            switch item {
            case .recentKeyword(let keyword):
                let cell = tableView.dequeueReusableCell(withIdentifier: RecentKeywordCell.Const.identifier, for: indexPath) as? RecentKeywordCell
                cell?.configure(with: keyword)
                cell?.delegate = self
                return cell ?? UITableViewCell()
            case .filteredRecentKeyword, .searchResult:
                return UITableViewCell()
            }
        }
    }
}
