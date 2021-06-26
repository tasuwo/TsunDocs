.PHONY: init
init: ## ライブラリ群をインストールする
	bundle exec pod install

.PHONY: generate
generate: mockolo_generate format ## 各種コード自動生成を実行する

.PHONY: lint
lint: swiftlint_lint ## 各種Linterを実行する

.PHONY: swiftlint_lint
swiftlint_lint: init ## SwiftLintによるリントを実行する
	Pods/SwiftLint/swiftlint

.PHONY: format
format: swiftformat_format ## 各種フォーマッターを実行する

.PHONY: swiftformat_format
swiftformat_format: init ## SwiftFormatによるフォーマットを実行する
	Pods/SwiftFormat/CommandLineTool/swiftformat --config ./.swiftformat ./

.PHONY: mockolo_generate
mockolo_generate: ## mockoloによるモック自動生成を行う
	cd BuildTools; \
	./mockolo \
		--sourcedirs ../Shared \
		--destination ../Preview\ Content/Mocks/Protocol/Shared.ProtocolMocks.swift
	cd BuildTools; \
	./mockolo \
		--sourcedirs ../Domain \
		--destination ../Preview\ Content/Mocks/Protocol/Domain.ProtocolMocks.swift \
		--custom-imports Domain

.PHONY: help
help: ## ヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
