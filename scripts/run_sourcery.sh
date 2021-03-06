#!/bin/sh

VERSION="v1.1.0"

if [[ ! -f "./templates/AutoDefaultValue.swifttemplate" ]]; then
    curl -o "./templates/AutoDefaultValue.swifttemplate" \
        "https://raw.githubusercontent.com/tasuwo/SwiftTemplates/${VERSION}/Templates/AutoDefaultValue.swifttemplate"
fi

if [[ ! -f "./templates/AutoDefaultValue.extension.swifttemplate" ]]; then
    curl -o "./templates/AutoDefaultValue.extension.swifttemplate" \
        "https://raw.githubusercontent.com/tasuwo/SwiftTemplates/${VERSION}/Templates/AutoDefaultValue.extension.swifttemplate"
fi

./Pods/Sourcery/bin/sourcery \
    --sources ./TsunDocsKit/Sources/Domain \
    --templates ./templates \
    --output ./TsunDocsKit/Sources/PreviewContent/Struct/Domain.AutoDefaultValue.generated.swift \
    --args import="Domain;Foundation"
