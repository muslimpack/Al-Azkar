import 'package:alazkar/src/core/constants/const.dart';
import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/helpers/bookmarks_helper.dart';
import 'package:alazkar/src/core/manager/volume_button_manager.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/quran/data/repository/uthmani_repository.dart';
import 'package:alazkar/src/features/search/domain/repository/search_repo.dart';
import 'package:alazkar/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
import 'package:alazkar/src/features/settings/data/repository/zikr_text_repo.dart';
import 'package:alazkar/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:alazkar/src/features/share_as_image/data/repository/share_image_repo.dart';
import 'package:alazkar/src/features/share_as_image/presentation/controller/cubit/share_image_cubit.dart';
import 'package:alazkar/src/features/theme/domain/repository/theme_storage.dart';
import 'package:alazkar/src/features/theme/presentation/controller/cubit/theme_cubit.dart';
import 'package:alazkar/src/features/ui/data/repository/ui_repo.dart';
import 'package:alazkar/src/features/zikr_content_viewer/data/repository/zikr_viewer_repo.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/repository/zikr_filter_storage.dart';
import 'package:alazkar/src/features/zikr_source_filter/presentation/controller/cubit/zikr_source_filter_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

final sl = GetIt.instance;

Future<void> initSL() async {
  ///MARK: Init storages
  sl.registerLazySingleton(() => GetStorage(kGetStorageName));
  sl.registerLazySingleton(() => UIRepo(sl()));
  sl.registerLazySingleton(() => ThemeStorage(sl()));
  sl.registerLazySingleton(() => ZikrFilterStorage(sl()));
  sl.registerLazySingleton(() => SettingsStorage(sl()));
  sl.registerLazySingleton(() => ShareAsImageRepo(sl()));
  sl.registerLazySingleton(() => ZikrTextRepo(sl()));
  sl.registerLazySingleton(() => ZikrViewerRepo(sl()));
  sl.registerLazySingleton(() => SearchRepo(sl()));

  ///MARK: Init Repo
  sl.registerLazySingleton(() => UthmaniRepository());
  sl.registerLazySingleton(() => BookmarksDBHelper());
  sl.registerLazySingleton(() => AzkarDBHelper());

  ///MARK: Init Manager
  sl.registerFactory(() => VolumeButtonManager());

  ///MARK: Init BLOC

  /// Singleton BLoC
  sl.registerLazySingleton(() => ThemeCubit(sl(), sl()));
  sl.registerLazySingleton(() => HomeBloc(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => SearchCubit(sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => SettingsCubit(sl()));
  sl.registerLazySingleton(() => ZikrSourceFilterCubit(sl()));

  /// Factory BLoC
  sl.registerFactory(
    () => ZikrContentViewerBloc(sl(), sl(), sl(), sl()),
  );
  sl.registerFactory(() => ShareImageCubit(sl()));
}
