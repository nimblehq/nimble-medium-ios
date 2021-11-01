//
//  FeedRowViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 17/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol ArticleRowViewModelInput {

    func toggleFavouriteArticle()
}

// sourcery: AutoMockable
protocol ArticleRowViewModelOutput {

    var id: String { get }
    var uiModel: Driver<ArticleRow.UIModel> { get }
    var didFailToToggleFavouriteArticle: Signal<Void> { get }
}

// sourcery: AutoMockable
protocol ArticleRowViewModelProtocol: ObservableViewModel {

    var input: ArticleRowViewModelInput { get }
    var output: ArticleRowViewModelOutput { get }
}

final class ArticleRowViewModel: ObservableObject, ArticleRowViewModelProtocol {

    @Injected private var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol
    @Injected private var toggleArticleFavoriteStatusUseCase: ToggleArticleFavoriteStatusUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let toggleFavouriteArticleTrigger = PublishRelay<Void>()
    private var articleIsFavourite: Bool

    var input: ArticleRowViewModelInput { self }
    var output: ArticleRowViewModelOutput { self }

    @PublishRelayProperty var didFailToToggleFavouriteArticle: Signal<Void>

    let uiModelSubject: BehaviorRelay<ArticleRow.UIModel?> = .init(value: nil)
    let id: String
    var uiModel: Driver<ArticleRow.UIModel> {
        uiModelSubject
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }

    init(article: Article) {
        id = article.id
        articleIsFavourite = article.favorited

        getCurrentSessionUseCase.execute()
            .subscribe(with: self) { owner, user in
                owner.uiModelSubject.accept(
                    .init(
                        id: article.id,
                        articleTitle: article.title,
                        articleDescription: article.description,
                        articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                        articleFavouriteCount: article.favoritesCount,
                        articleCanFavourite: user?.username != article.author.username,
                        authorImage: try? article.author.image?.asURL(),
                        authorName: article.author.username
                    )
                )
            }
            .disposed(by: disposeBag)

        toggleFavouriteArticleTrigger
            .withUnretained(self)
            .flatMap { $0.0.updateToggleFavouriteArticle() }
            .debounce(.milliseconds(500), scheduler: SharingScheduler.make())
            .withUnretained(self)
            .flatMapLatest { $0.0.toggleFavouriteArticleTriggered(owner: $0.0, isFavourite: $0.1) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleRowViewModel: ArticleRowViewModelInput {

    func toggleFavouriteArticle() {
        toggleFavouriteArticleTrigger.accept(())
    }
}

extension ArticleRowViewModel: ArticleRowViewModelOutput {}

// MARK: - Private

extension ArticleRowViewModel {

    private func toggleFavouriteArticleTriggered(owner: ArticleRowViewModel, isFavourite: Bool) -> Observable<Void> {
        toggleArticleFavoriteStatusUseCase
            .execute(slug: id, isFavorite: isFavourite)
            .do(
                onError: { _ in
                    owner.$didFailToToggleFavouriteArticle.accept(())
                    owner.updateFavouriteArticle(owner.articleIsFavourite)
                },
                onCompleted: {
                    owner.articleIsFavourite = isFavourite
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func updateToggleFavouriteArticle() -> Observable<Bool> {
        guard let uiModel = uiModelSubject.value else { return .empty() }
        updateFavouriteArticle(!uiModel.articleIsFavorited)

        return .just(!uiModel.articleIsFavorited)
    }

    private func updateFavouriteArticle(_ value: Bool) {
        var uiModel = uiModelSubject.value
        uiModel?.articleIsFavorited = value
        uiModelSubject.accept(uiModel)
    }
}

extension Array where Element == Article {

    var viewModels: [ArticleRowViewModelProtocol] {
        map { Resolver.resolve(ArticleRowViewModelProtocol.self, args: $0) }
    }
}
