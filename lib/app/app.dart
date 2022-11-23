import 'package:uia/wrappers/authentication_wrapper.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    // AdaptiveRoute(page: HomeView, initial: true),
  ],
  dependencies: [
    // Singleton(classType: SnackbarService),
    // LazySingleton(classType: ApiService),
    // LazySingleton(classType: SuperheroService),
  ],
  logger: StackedLogger(),
)
class AppSetup {}
