import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
//   locator.registerSingleton(SnackbarService());
  // locator.registerLazySingleton(() => ApiService());
  // locator.registerLazySingleton(() => SuperheroService());
}
