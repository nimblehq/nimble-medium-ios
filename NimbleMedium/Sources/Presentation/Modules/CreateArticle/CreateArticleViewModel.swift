//
//  CreateArticleViewModel.swift
//  NimbleMedium
//
//  Created by Minh Pham on 19/10/2021.
//

import RxSwift
import RxCocoa
import Combine
import Resolver

// sourcery: AutoMockable
protocol CreateArticleViewModelInput {

    func didTapPublishButton(
        title: String,
        description: String,
        body: String,
        tagsList: String
    )
}

protocol CreateArticleViewModelOutput {

    var didCreateArticle: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
    var isLoading: Driver<Bool> { get }
}

protocol CreateArticleViewModelProtocol: ObservableViewModel {

    var input: CreateArticleViewModelInput { get }
    var output: CreateArticleViewModelOutput { get }
}

final class CreateArticleViewModel: ObservableObject, CreateArticleViewModelProtocol {

    typealias CreateArticleParams = (
        title: String, description: String, body: String, tagsList: [String]
    )

    private let disposeBag = DisposeBag()

    var input: CreateArticleViewModelInput { self }
    var output: CreateArticleViewModelOutput { self }

    @PublishRelayProperty var didCreateArticle: Signal<Void>
    @PublishRelayProperty var errorMessage: Signal<String>

    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>

    @Injected var createArticleUseCase: CreateArticleUseCaseProtocol

    private let createArticleTrigger = PublishRelay<CreateArticleParams>()

    init() {
        createArticleTrigger
            .withUnretained(self)
            .flatMapLatest { owner, inputs in owner.createArticleTriggered(owner: owner, inputs: inputs) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension CreateArticleViewModel: CreateArticleViewModelInput {

    func didTapPublishButton(
        title: String,
        description: String,
        body: String,
        tagsList: String
    ) {
        $isLoading.accept(true)
        createArticleTrigger.accept((title, description, body, tagsList.toStringsArray()))
    }
}

extension CreateArticleViewModel: CreateArticleViewModelOutput { }

private extension CreateArticleViewModel {

    func createArticleTriggered(owner: CreateArticleViewModel, inputs: CreateArticleParams) -> Observable<Void> {
        createArticleUseCase
            .execute(
                params: CreateArticleParameters(
                    title: inputs.title,
                    description: inputs.description,
                    body: inputs.body,
                    tagList: inputs.tagsList
                )
            )
            .do(
                onSuccess: { _ in
                    owner.$isLoading.accept(false)
                    owner.$didCreateArticle.accept(())
                },
                onError: { error in
                    owner.$isLoading.accept(false)
                    owner.$errorMessage.accept(error.detail)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
