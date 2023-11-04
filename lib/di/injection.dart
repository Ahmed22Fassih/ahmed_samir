import '../data/Api/apiImpl.dart';
import '../data/networkUtils/networkUtil.dart';
import '../data/repositories/dataManagerImpl.dart';
import '../data/sharedPreference/prefs.dart';
import '../main.dart';
import '../movies/movies_viewModel.dart';
import '../movies_details/movies_details_viewModel.dart';

Future init() async {
  di.registerLazySingleton<DataManagerImpl>(
      () => DataManagerImpl(di<ApiImpl>(), di<Prefs>()));
  di.registerLazySingleton<ApiImpl>(() => ApiImpl(di<DioUtils>()));
  di.registerLazySingleton<DioUtils>(() => DioUtils());
  di.registerLazySingleton<Prefs>(() => Prefs());

  di.registerFactory<MoviesViewModel>(
      () => MoviesViewModel(repository: di<DataManagerImpl>()));

  di.registerFactory<MoviesDetailsViewModel>(
      () => MoviesDetailsViewModel(repository: di<DataManagerImpl>()));
}
