import SnapKit
import UIKit

protocol RecentKeywordCellDelegate: AnyObject {
    func recentKeywordCellDidTapDelete(_ cell: RecentKeywordCell)
}

final class RecentKeywordCell: UITableViewCell {

    weak var delegate: RecentKeywordCellDelegate?

    // MARK: - UI

    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with keyword: RecentKeyword) {
        keywordLabel.text = keyword.keyword
    }
}

// MARK: - Private
extension RecentKeywordCell {
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(keywordLabel)
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        keywordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
    }

    @objc private func deleteButtonTapped() {
        delegate?.recentKeywordCellDidTapDelete(self)
    }
}

// MARK: - Const
extension RecentKeywordCell {
    enum Const {
        static let identifier = "RecentKeywordCell"
    }
}
