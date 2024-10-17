import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/utils/shared_prefs.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: OnboardRoute.page,
            initial: sharedPrefs.isLoggedIn == true ? false : true),
        //authentication Screens Routes
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: InputPhoneRoute.page),
        AutoRoute(page: PhoneVerifyRoute.page),
        AutoRoute(page: SuccessRoute.page),
        //dashboard Screens Routes
        AutoRoute(
          page: DashboardRoute.page,
          initial: sharedPrefs.isLoggedIn == true ? true : false,
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: ShipmentRoute.page),
            AutoRoute(page: ViewProfileRoute.page),
          ],
        ),

        AutoRoute(page: TrackParcelRoute.page),
        AutoRoute(page: BulkDeliveryDetailsRoute.page),
        AutoRoute(page: DeliveryDetailsRoute.page),

        AutoRoute(page: ShipmentDetailsRoute.page),

        AutoRoute(page: GetHelpRoute.page),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: NotificationRoute.page),
        AutoRoute(page: RequestRider.page),
      ];
}
