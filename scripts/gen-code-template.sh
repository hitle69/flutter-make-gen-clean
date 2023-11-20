#!/bin/bash
show_help() {
  echo "================================================================================================================================================================"
  echo "#     Usage: Create template at feature layer & folder $0 [options]"
  echo "#     Usage: Layer support: 'dto','model','data_source','repository','entity','usecase','page','widget','uistate'"
  echo "#     Usage: Example: 'make template feature=\"feed\" layer=\"uistate\" name=\"new_feed\"'"
  echo "#     Options:"
  echo "#       feature    Ex: feature='feed' The feature that template belong to "
  echo "#       layer      Ex: layer='dto' The layer of template just is one of 'dto','model','data_source','repository','entity','usecase','page','widget','uistate'"
  echo "#       name       Ex: name='new_feed' Name as underscore case, using to generate name of class name of file follow convention"
  echo "================================================================================================================================================================"
}

while getopts "vh" opt; do
  case "$opt" in
  v)
    show_help
    exit 0
    ;;
  h)
    show_help
    exit 0
    ;;
  *)
    echo "Invalid option: -$OPTARG"
    show_help
    exit 1
    ;;
  esac
done

# Create the template content

if [ -z "$1" ]; then
  echo "[ERROR]: feature is requried"
  show_help
  exit 1
fi

if [ -z "$2" ]; then
  echo "[ERROR]: layor is required"
  show_help
  exit 1
fi
if [ -z "$3" ]; then
  echo "[ERROR]: name is required"
  show_help
  exit 1
fi

feature=$(echo "$1" | tr '[:upper:]' '[:lower:]')
layer=$(echo "$2" | tr '[:upper:]' '[:lower:]')
name=$(echo "$3" | tr '[:upper:]' '[:lower:]')
echo "Format name for name"
underscore_case_regex="^[a-z_]+$"
# Check if the argument matches the underscore_case pattern
if [[ "$name" =~ $underscore_case_regex ]]; then
  echo "[INFO]: checked '$name' valid underscore_case."
else
  echo "[ERROR]: The string '$name' must in not in underscore_case."
  exit 1
fi

underscore_case="$name"

# Convert underscore_case to PascalCase
pascal_case=""
IFS='_'
read -ra words <<<"$underscore_case"
for word in "${words[@]}"; do
  # Capitalize the first letter of each word
  pascal_case="${pascal_case}$(echo "$word" | awk '{print toupper(substr($0, 1, 1)) tolower(substr($0, 2))}')"
done

nameClass=$pascal_case
echo "[INFO]: Create name class $nameClass"

templateEntity=$(
  cat <<END
import 'package:freezed_annotation/freezed_annotation.dart';
part '${name}_entity.freezed.dart';
part '${name}_entity.g.dart';

@freezed
class ${nameClass}Entity with _\$${nameClass}Entity {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ${nameClass}Entity({
    @Default("") String customField,
  }) = _${nameClass}Entity;

  factory ${nameClass}Entity.fromJson(Map<String, Object?> json) => _\$${nameClass}EntityFromJson(json);
}
END
)

templateModel=$(
  cat <<END
import 'package:freezed_annotation/freezed_annotation.dart';
part '${name}_model.freezed.dart';
part '${name}_model.g.dart';

@freezed
class ${nameClass}Model with _\$${nameClass}Model {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ${nameClass}Model({
    @Default("") String customField,
  }) = _${nameClass}Model;

  factory ${nameClass}Model.fromJson(Map<String, Object?> json) => _\$${nameClass}ModelFromJson(json);
}
END
)

templateDto=$(
  cat <<END
import 'package:codebase/src/features/$feature/data/models/${name}_model.dart';
import 'package:codebase/src/features/$$feature/domain/entities/${name}_entity.dart';
extension ${nameClass}EntityDTO on ${nameClass}Model {
  ${nameClass}Entity toEntity() {
    return ${nameClass}Model(
      customField: customField,
    );
  }
}
extension ${nameClass}ModelDTO on ${nameClass}Entity {
  ${nameClass}Model toModel() {
    return ${nameClass}Model(
      customField: customField,
    );
  }
}
END
)

templateDataCource=$(
  cat <<END
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part '${name}_data_source.g.dart';

@RestApi()
abstract class ${nameClass}DataSource {
  factory ${nameClass}DataSource(Dio dio, {String baseUrl}) = _${nameClass}DataSource;
}

END
)

templateUsecase=$(
  cat <<END
import 'package:codebase/src/core/domain/base_usecase.dart';

class ${nameClass}UseCase extends BaseUseCase<Future<bool?>, bool> {

  @override
  Future<bool?> call([bool? params]) async {
    return false;
  }
}

END
)

templateRepository=$(
  cat <<END

class ${nameClass}Repository {
  
}

END
)

templateWidget=$(
  cat <<END

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${nameClass}Widget extends ConsumerStatefulWidget {
  const ${nameClass}Widget({super.key});
  @override
  ConsumerState<${nameClass}Widget> createState() => _State();
}

class _State extends ConsumerState<${nameClass}Widget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
END
)

templatePage=$(
  cat <<END

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${nameClass}Page extends ConsumerStatefulWidget {
  const ${nameClass}Page({super.key});
  @override
  ConsumerState<${nameClass}Page> createState() => _State();
}

class _State extends ConsumerState<${nameClass}Page> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
END
)

templateUiState=$(
  cat <<END
import 'package:freezed_annotation/freezed_annotation.dart';
part '${name}_ui_states.freezed.dart';

@freezed
class ${nameClass}UiStates with _\$${nameClass}UiStates {
  const factory ${nameClass}UiStates({
    @Default(false) bool customField,
  }) = _${nameClass}UiStates;
}

END
)

featuresFolder=lib/src/features
featureFolder=$featuresFolder/$feature
dataFolder=$featureFolder/data
domainFolder=$featureFolder/domain
uiFolder=$featureFolder/ui
# data
dataDataSourcesFolder=$dataFolder/data_sources
dataDtoFolder=$dataFolder/dto
dataModelFolder=$dataFolder/models
dataRepositoriesFolder=$dataFolder/repository
# domain
domainEntitiesFolder=$domainFolder/entities
domainRepositoryFolder=$domainFolder/repository
domainUseCasesFolder=$domainFolder/usecases
# ui
uiManagerFolder=$uiFolder/manager
uiPresentationFolder=$uiFolder/presentation
uiPresentationPagesFolder=$uiPresentationFolder/pages
uiPresentationWidgetFolder=$uiPresentationFolder/widgets

# touch $dataDataSourcesFolder/${feature}_data_source.dart
# touch $dataDtoFolder/${feature}_dto.dart
# touch $dataModelFolder/${feature}_model.dart
# touch $dataRepositoriesFolder/${feature}_repository.dart
folder=""
template=""
fileName=""
# Check the value of the $layer variable and return the corresponding template
if [ "$layer" = "dto" ]; then
  template="$templateDto"
  folder="$dataDtoFolder"
  fileName="${name}_dto.dart"
elif [ "$layer" = "model" ]; then
  template="$templateModel"
  folder="$dataModelFolder"
  fileName="${name}_model.dart"
elif [ "$layer" = "data_source" ]; then
  template="$templateDataCource"
  folder="$dataDataSourcesFolder"
  fileName="${name}_data_source.dart"
elif [ "$layer" = "repository" ]; then
  template="$templateRepository"
  folder="$dataRepositoriesFolder"
  fileName="${name}_repository.dart"
elif [ "$layer" = "entity" ]; then
  template="$templateEntity"
  folder="$domainEntitiesFolder"
  fileName="${name}_entity.dart"
elif [ "$layer" = "usecase" ]; then
  template="$templateUsecase"
  folder="$domainUseCasesFolder"
  fileName="${name}_usecase.dart"
elif [ "$layer" = "page" ]; then
  template="$templatePage"
  folder="$uiPresentationWidgetFolder"
  fileName="${name}_page.dart"
elif [ "$layer" = "widget" ]; then
  template="$templateWidget"
  folder="$uiPresentationWidgetFolder"
  fileName="${name}_widget.dart"
elif [ "$layer" = "uistate" ]; then
  template="$templateUiState"
  folder="$uiManagerFolder"
  fileName="${name}_ui_states.dart"
else
  echo "[ERROR]: Please define $layer template first"
  exit 1
fi
set -e

filePath="$folder/${fileName}"
if [ -e "$filePath" ]; then
  echo "File '$filePath' exists."
  exit
else
  echo "[INFO]: Creating file '$filePath' "
fi

# Save the template content to a file
echo "$template" >"$filePath"
set +e
valid_layers=("model" "entity" "uistate")
# Check if the $layer variable is one of the valid layers
valid=false
for valid_layer in "${valid_layers[@]}"; do
  echo compare "$layer" with "$valid_layer"
  if [ "$layer" = "$valid_layer" ]; then
    valid=true
    break
  fi
done
code "$filePath"
echo "try to open vs code at $filePath $valid"
if [ "$valid" = true ]; then
  flutter pub run build_runner build
else
  echo "[INFO]: The layer '$layer' no not need to run generate code"
fi
echo "[INFO]: generate success: $filePath"
exit 0
