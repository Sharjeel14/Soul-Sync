/// Holds a [bloc] instance and optional [data] to pass through a route.
class RouteWithBlocData<T, B> {
  final B bloc;
  final T? data;

  const RouteWithBlocData({required this.bloc, this.data});
}
