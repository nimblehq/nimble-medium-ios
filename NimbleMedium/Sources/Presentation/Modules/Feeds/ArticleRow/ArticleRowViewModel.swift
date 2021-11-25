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
    var uiModel: Driver<ArticleRow.UIModel?> { get }
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
    private var articleFavouritesCount: Int

    var input: ArticleRowViewModelInput { self }
    var output: ArticleRowViewModelOutput { self }

    @PublishRelayProperty var didFailToToggleFavouriteArticle: Signal<Void>
    @BehaviorRelayProperty(nil) var uiModel: Driver<ArticleRow.UIModel?>

    let id: String

    init(article: Article) {
        id = article.id
        articleIsFavourite = article.favorited
        articleFavouritesCount = article.favoritesCount

        getCurrentSessionUseCase.execute()
            .subscribe(with: self) { owner, user in
                owner.$uiModel.accept(
                    .init(
                        id: article.id,
                        articleTitle: article.title,
                        articleDescription: article.description,
                        articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                        articleFavoriteCount: article.favoritesCount,
                        articleCanFavorite: user?.username != article.author.username,
                        articleIsFavorited: article.favorited,
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
            .flatMapLatest { owner, args -> Observable<Void> in
                let (isFavourite, favouritesCount) = args
                return owner.toggleFavouriteArticleTriggered(
                    owner: owner,
                    isFavourite: isFavourite,
                    favouritesCount: favouritesCount
                )
            }
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

    private func toggleFavouriteArticleTriggered(
        owner: ArticleRowViewModel,
        isFavourite: Bool,
        favouritesCount: Int
    ) -> Observable<Void> {
        toggleArticleFavoriteStatusUseCase
            .execute(slug: id, isFavorite: isFavourite)
            .do(
                onError: { _ in
                    owner.$didFailToToggleFavouriteArticle.accept(())
                    owner.updateFavouriteArticle(
                        owner.articleIsFavourite,
                        count: owner.articleFavouritesCount
                    )
                },
                onCompleted: {
                    owner.articleIsFavourite = isFavourite
                    owner.articleFavouritesCount = favouritesCount
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func updateToggleFavouriteArticle() -> Observable<(Bool, Int)> {
        guard let uiModel = $uiModel.value else { return .empty() }
        let isFavourite = uiModel.articleIsFavorited
        let count = uiModel.articleFavoriteCount + 1 * (!isFavourite ? 1 : -1)
        updateFavouriteArticle(!isFavourite, count: count)

        return .just((!isFavourite, count))
    }

    private func updateFavouriteArticle(_ isFavourite: Bool, count: Int) {
        guard var uiModel = $uiModel.value else { return }
        uiModel.articleIsFavorited = isFavourite
        uiModel.articleFavoriteCount = count
        $uiModel.accept(uiModel)
    }
}

extension Array where Element == Article {

    var viewModels: [ArticleRowViewModelProtocol] {
        map { Resolver.resolve(ArticleRowViewModelProtocol.self, args: $0) }
    }
}
