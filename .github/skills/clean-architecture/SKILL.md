---
name: clean-architecture-template
description: "Create a Swift clean architecture feature scaffold using the feature name as a prefix, including required protocol files."
---

# Clean Architecture Template Skill

Use this skill to generate a new Swift feature scaffold that follows Clean Architecture principles. The feature name should be used as the prefix for all generated files and types.

## When to use
- Creating a new feature in Swift using Clean Architecture
- Generating a consistent feature folder with domain, data, and presentation layers
- Including protocol definitions for all boundary interfaces

## Expected input
- Feature name in PascalCase or UpperCamelCase
- Optional: preference for UIKit or SwiftUI presentation layer

## Generated structure
Create a new feature folder and generate the following Swift files:

1. Domain Layer
   - `<Feature>UseCaseProtocol.swift`
   - `<Feature>UseCase.swift`
   - `<Feature>RepositoryProtocol.swift`
   - `<Feature>Entity.swift`
   - `<Feature>Response.swift`

2. Data Layer
   - `<Feature>Repository.swift`
   - `<Feature>RemoteDataSourceProtocol.swift`
   - `<Feature>LocalDataSourceProtocol.swift`
   - `<Feature>RemoteDataSource.swift`
   - `<Feature>LocalDataSource.swift`

3. Presentation Layer
   - `<Feature>ViewModelProtocol.swift`
   - `<Feature>ViewModel.swift`
   - `<Feature>ViewState.swift`
   - `<Feature>View.swift` or `<Feature>ViewController.swift`

4. Assembly / Factory
   - `<Feature>Assembly.swift`

## Requirements
- Use the feature name as the prefix for all files, types, and protocols.
- Keep Swift code clean and idiomatic.
- Include protocols for use case, repository, and data sources.
- Provide a simple wiring example in the assembly file.
- Use `public` access only where required for module boundaries.

## Example
If the feature name is `MovieList`, generate:
- `MovieListUseCaseProtocol.swift`
- `MovieListUseCase.swift`
- `MovieListRepositoryProtocol.swift`
- `MovieListEntity.swift`
- `MovieListRepository.swift`
- `MovieListRemoteDataSourceProtocol.swift`
- `MovieListLocalDataSourceProtocol.swift`
- `MovieListViewModelProtocol.swift`
- `MovieListViewModel.swift`
- `MovieListViewState.swift`
- `MovieListView.swift`
- `MovieListAssembly.swift`

## Notes
- If the user specifies SwiftUI, prefer `View.swift`.
- If the user specifies UIKit, prefer `ViewController.swift`.
- If a feature already exists, do not overwrite without confirmation.
