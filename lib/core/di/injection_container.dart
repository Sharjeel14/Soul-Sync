import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../services/flutter_local_notification_service.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() {
  getIt.init();

  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService.internal(),
  );
}
