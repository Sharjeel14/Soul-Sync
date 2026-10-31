// GENERATED CODE - HAND CONFIGURED FOR DATING APP DEPENDENCIES
// ignore_for_file: type=lint
// coverage:ignore-file

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

// ───────────────── CORE ─────────────────
import '../api_manager/api_manager.dart' as _i3;
import '../api_manager/base_api_client.dart' as _i4;
import '../api_manager/dio_client.dart' as _i5;
import '../storage/storage_manager.dart' as _i6;

// ───────────────── AUTH ─────────────────
import '../../features/auth/bloc/auth_cubit.dart' as _i7;
import '../../features/auth/repository/auth_repository.dart' as _i8;
import '../../features/auth/repository/auth_repository_impl.dart' as _i9;
import '../../features/auth/services/auth_storage_service.dart' as _i10;

// ───────────────── GLOBAL ─────────────────
import '../../features/global/bloc/global_cubit.dart' as _i11;
import '../../features/global/repository/global_repository.dart' as _i12;
import '../../features/global/repository/global_repository_impl.dart' as _i13;

// ───────────────── HOME & PROFILE & NAV ─────────────────
import '../../features/bottom_nav_bar/bloc/bottom_nav_cubit.dart' as _i16;
import '../../features/home/bloc/home_cubit.dart' as _i21;
import '../../features/home/repository/home_repository.dart' as _i22;
import '../../features/home/repository/home_repository_impl.dart' as _i23;
import '../../features/profile/bloc/profile_cubit.dart' as _i24;
import '../../features/profile/repository/profile_repository.dart' as _i25;
import '../../features/profile/repository/profile_repository_impl.dart' as _i26;
import '../../features/splash/bloc/splash_cubit.dart' as _i33;
import '../../features/matches/repository/match_repository.dart' as _i34;
import '../../features/matches/repository/match_repository_impl.dart' as _i35;
import '../../features/chat/repository/chat_repository.dart' as _i36;
import '../../features/chat/repository/chat_repository_impl.dart' as _i37;
import '../../features/profile/repository/block_repository.dart' as _i38;
import '../../features/profile/repository/block_repository_impl.dart' as _i39;
import '../../features/matches/bloc/matches_cubit.dart' as _i40;
import '../../features/messages/bloc/messages_cubit.dart' as _i41;

// ───────────────── INJECTION ─────────────────
extension GetItInjectableX on _i1.GetIt {
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(this, environment, environmentFilter);

    // ───────────── CORE SERVICES ─────────────
    gh.lazySingleton<_i6.StorageManager>(() => _i6.StorageManager());
    gh.lazySingleton<_i10.AuthStorageService>(() => _i10.AuthStorageService());

    gh.lazySingleton<_i4.BaseApiClient>(() => _i5.DioClient());
    gh.lazySingleton<_i3.ApiManager>(
      () => _i3.ApiManager(gh<_i4.BaseApiClient>()),
    );

    // ───────────── REPOSITORIES ─────────────
    gh.lazySingleton<_i12.GlobalRepository>(
      () => _i13.GlobalRepositoryImpl(),
    );

    gh.lazySingleton<_i8.AuthRepository>(
      () => _i9.AuthRepositoryImpl(
        storageService: gh<_i10.AuthStorageService>(),
      ),
    );

    gh.lazySingleton<_i22.HomeRepository>(
      () => _i23.HomeRepositoryImpl(),
    );

    gh.lazySingleton<_i25.ProfileRepository>(
      () => _i26.ProfileRepositoryImpl(
        storageService: gh<_i10.AuthStorageService>(),
      ),
    );

    gh.lazySingleton<_i34.MatchRepository>(
      () => _i35.MatchRepositoryImpl(),
    );

    gh.lazySingleton<_i36.ChatRepository>(
      () => _i37.ChatRepositoryImpl(),
    );

    gh.lazySingleton<_i38.BlockRepository>(
      () => _i39.BlockRepositoryImpl(),
    );

    // ───────────── GLOBAL CUBITS ─────────────
    gh.lazySingleton<_i11.GlobalCubit>(
      () => _i11.GlobalCubit(
        gh<_i12.GlobalRepository>(),
        gh<_i6.StorageManager>(),
        gh<_i10.AuthStorageService>(),
      ),
    );

    gh.factory<_i7.AuthCubit>(
      () => _i7.AuthCubit(
        gh<_i8.AuthRepository>(),
        gh<_i10.AuthStorageService>(),
      ),
    );

    // ───────────── FEATURE CUBITS ─────────────
    gh.factory<_i16.BottomNavCubit>(() => _i16.BottomNavCubit());

    gh.factory<_i21.HomeCubit>(
      () => _i21.HomeCubit(
        gh<_i22.HomeRepository>(),
        gh<_i34.MatchRepository>(),
        gh<_i38.BlockRepository>(),
      ),
    );

    gh.factory<_i24.ProfileCubit>(
      () => _i24.ProfileCubit(gh<_i25.ProfileRepository>()),
    );

    gh.factory<_i33.SplashCubit>(
      () => _i33.SplashCubit(gh<_i10.AuthStorageService>()),
    );

    gh.factory<_i40.MatchesCubit>(
      () => _i40.MatchesCubit(
        gh<_i34.MatchRepository>(),
        gh<_i38.BlockRepository>(),
      ),
    );

    gh.factory<_i41.MessagesCubit>(
      () => _i41.MessagesCubit(
        gh<_i36.ChatRepository>(),
        gh<_i34.MatchRepository>(),
        gh<_i38.BlockRepository>(),
      ),
    );

    return this;
  }
}
