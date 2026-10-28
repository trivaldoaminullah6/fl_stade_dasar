class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';

  /// Path berparameter dibuat lewat fungsi, bukan string manual
  static String projectDetail(String id) => '/profile/projects/$id';
}
