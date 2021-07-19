.PHONY: init
init: init_pod init_carthage ## ライブラリ群をインストールする

.PHONY: init_pod
init_pod: ## CocoaPodsライブラリを準備する
	bundle exec pod install

.PHONY: init_carthage
init_carthage: ## Carthageライブラリを準備する
	carthage update --use-xcframeworks --cache-builds --no-use-binaries --platform iOS,macOS

.PHONY: generate
generate: sourcery_generate mockolo_generate format ## 各種コード自動生成を実行する

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
	if [[ ! -f "./templates/AutoDefaultValue.swifttemplate" ]] || [[ ! -f "./templates/AutoDefaultValue.extension.swifttemplate" ]]; then \
	curl -o "./templates/AutoDefaultValue.swifttemplate" \
		"https://raw.githubusercontent.com/tasuwo/SwiftTemplates/master/Templates/AutoDefaultValue.swifttemplate"; \
	curl -o "./templates/AutoDefaultValue.extension.swifttemplate" \
		"https://raw.githubusercontent.com/tasuwo/SwiftTemplates/master/Templates/AutoDefaultValue.extension.swifttemplate"; \
	fi
	./Pods/Sourcery/bin/sourcery \
		--sources ./Domain \
		--templates ./templates \
		--output ./Preview\ Content/Mocks/Struct/Domain.AutoDefaultValue.generated.swift \
		--args import=Domain

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
