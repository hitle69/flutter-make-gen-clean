# flutter-make-gen-clean

Support make command to generate Boilerplate clean code for flutter.

Using riverpod, change script what you want

Why should we follow clean code for mobile?

## Generate feature structure folder

```bash
# Usage: Example: 'make feature=\"feed\"
# Structure folder will be generate: 
# lib/src/features/{feature}/data
# lib/src/features/{feature}/data/data_sources
# lib/src/features/{feature}/data/data_sources/{feature}_data_source.dart
# lib/src/features/{feature}/data/dto
# lib/src/features/{feature}/data/dto/{feature}_dto.dart
# lib/src/features/{feature}/data/models
# lib/src/features/{feature}/data/models/{feature}_model.dart
# lib/src/features/{feature}/data/repository
# lib/src/features/{feature}/data/repository/{feature}_repository.dart

# lib/src/features/{feature}/domain
# lib/src/features/{feature}/domain/entities
# lib/src/features/{feature}/domain/entities/{feature}_entity.dart
# lib/src/features/{feature}/domain/usecases/
# lib/src/features/{feature}/domain/usecases/{feature}_usecase.dart
# lib/src/features/{feature}/domain/repository
# lib/src/features/{feature}/domain/repository/{feature}_repository.dart

# lib/src/features/{feature}/ui
# lib/src/features/{feature}/ui/manager
# lib/src/features/{feature}/ui/manager/{feature}_ui_state.dart
# lib/src/features/{feature}/ui/manager/{feature}_ui_notifier.dart
# lib/src/features/{feature}/ui/presentation/pages
# lib/src/features/{feature}/ui/presentation/pages/{feature}_page.dart
# lib/src/features/{feature}/ui/presentation/widgets
# lib/src/features/{feature}/ui/presentation/widgets/{feature}_widget.dart
# lib/src/features/{feature}/di

```

## Generate template code

```bash
# Usage: Create template at feature layer & folder $0 [options]"
# Usage: Layer support: 'dto','model','data_source','repository','entity','usecase','page','widget','uistate'"
# Usage: Example: 'make template feature=\"feed\" layer=\"uistate\" name=\"new_feed\"'"
# Options:"
#     feature    Ex: feature='feed' The feature that template belong to "
#     layer      Ex: layer='dto' The layer of template just is one of 'dto','model','data_source','repository','entity','usecase','page','widget','uistate'"
#     name       Ex: name='new_feed' Name as underscore case, using to generate name of class name of file follow convention"
```
