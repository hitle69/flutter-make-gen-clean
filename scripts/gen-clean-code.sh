#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Parameter is empty. Please provide a valid argument."
    exit 1
fi

feature=$(echo "$1" | tr '[:upper:]' '[:lower:]')

current_directory=$(pwd)
if [ ! -d "$current_directory/lib/src" ]; then
    echo "Error: The directory 'lib/src' does not exist within the current directory."
    exit 1
fi

current_folder_name=$(basename "$current_directory")
echo "Current folder name is: $current_folder_name"

featuresFolder=lib/src/features
featureFolder=$featuresFolder/$feature
dataFolder=$featureFolder/data
domainFolder=$featureFolder/domain
uiFolder=$featureFolder/ui

echo "Generate features level folder"
mkdir -p $featuresFolder
mkdir -p $featureFolder
mkdir -p $dataFolder
mkdir -p $domainFolder
mkdir -p $uiFolder

echo "Generate data level folder"
dataDataSourcesFolder=$dataFolder/data_sources
dataDtoFolder=$dataFolder/dto
dataModelFolder=$dataFolder/models
dataRepositoriesFolder=$dataFolder/repository
mkdir -p $dataDataSourcesFolder
mkdir -p $dataDtoFolder
mkdir -p $dataModelFolder
mkdir -p $dataRepositoriesFolder

echo "Create file data folder"
touch $dataDataSourcesFolder/${feature}_data_source.dart
touch $dataDtoFolder/${feature}_dto.dart
touch $dataModelFolder/${feature}_model.dart
touch $dataRepositoriesFolder/${feature}_repository.dart

echo "Generate domain level folder"
domainEntitiesFolder=$domainFolder/entities
domainRepositoryFolder=$domainFolder/repository
domainUseCasesFolder=$domainFolder/usecases

mkdir -p $domainEntitiesFolder
mkdir -p $domainRepositoryFolder
mkdir -p $domainUseCasesFolder

echo "Create file domain folder"
touch $domainEntitiesFolder/${feature}_entity.dart
touch $domainRepositoryFolder/${feature}_repository.dart
touch $domainUseCasesFolder/${feature}_usecase.dart

echo "Generate domain level folder"
uiManagerFolder=$uiFolder/manager
uiPresentationFolder=$uiFolder/presentation
uiPresentationPagesFolder=$uiPresentationFolder/pages
uiPresentationWidgetFolder=$uiPresentationFolder/widgets

mkdir -p $uiManagerFolder
mkdir -p $uiPresentationFolder
mkdir -p $uiPresentationPagesFolder
mkdir -p $uiPresentationWidgetFolder

echo "Create file ui folder"
# mkdir -p $uiManagerFolder/${feature}_controller.dart #for another state management
# for riverpod state management
touch $uiManagerFolder/${feature}_ui_states.dart
touch $uiManagerFolder/${feature}_ui_notifier.dart
touch $uiPresentationPagesFolder/${feature}_page.dart
touch $uiPresentationWidgetFolder/${feature}_widget.dart

touch $featureFolder/di.dart
