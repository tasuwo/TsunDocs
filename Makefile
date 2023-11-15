.PHONY: init
init: init_pod ## ライブラリ群をインストールする

.PHONY: init_pod
init_pod: ## CocoaPodsライブラリを準備する
	bundle exec pod install

.PHONY: generate
generate: sourcery_generate swiftgen_generate mockolo_generate format ## 各種コード自動生成を実行する

.PHONY: swiftgen_generate
swiftgen_generate: init_pod ## SwiftGenによるコード自動生成を実行する
	./Pods/SwiftGen/bin/swiftgen

.PHONY: lint
lint: swiftlint_lint ## 各種Linterを実行する

.PHONY: swiftlint_lint
swiftlint_lint: init_pod ## SwiftLintによるリントを実行する
	Pods/SwiftLint/swiftlint

.PHONY: format
format: swiftformat_format ## 各種フォーマッターを実行する

.PHONY: swiftformat_format
swiftformat_format: init_pod ## SwiftFormatによるフォーマットを実行する
	Pods/SwiftFormat/CommandLineTool/swiftformat --config ./.swiftformat ./

.PHONY: sourcery_generate
sourcery_generate: init_pod ## Sourceryによるモック自動生成を行う
	sh ./scripts/run_sourcery.sh

.PHONY: mockolo_generate
mockolo_generate: ## mockoloによるモック自動生成を行う
	cd BuildTools; \
	./mockolo \
		--sourcedirs ../TsunDocsKit/Sources/Domain \
		--destination ../TsunDocsKit/Sources/PreviewContent/Protocol/Domain.ProtocolMocks.swift \
		--custom-imports Domain
	cd BuildTools; \
	./mockolo \
		--sourcedirs ../TsunDocsKit/Sources/Environment \
		--destination ../TsunDocsKit/Sources/PreviewContent/Protocol/Environment.ProtocolMocks.swift \
		--custom-imports Domain \
		--custom-imports Environment
	cd BuildTools; \
	./mockolo \
		--sourcedirs ../TsunDocsKit/Sources/CoreDataCloudKitHelper \
		--destination ../TsunDocsKit/Sources/PreviewContent/Protocol/CoreDataCloudKitHelper.ProtocolMocks.swift \
		--custom-imports CoreDataCloudKitHelper

.PHONY: help
help: ## ヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
