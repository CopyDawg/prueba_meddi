import 'package:go_router/go_router.dart';
import 'package:prueba_meddi/models/hospital/hospital.dart';
import 'package:prueba_meddi/presentation/homeView/home_view.dart';
import 'package:prueba_meddi/presentation/authView/login_view.dart';
import 'package:prueba_meddi/presentation/authView/register_view.dart';
import 'package:prueba_meddi/presentation/hospitalDetailView/hospital_detail_view.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/hospital/:id',
      builder: (context, state) {
        final hospitalId = state.pathParameters['id']!;
        final hospital = state.extra as Hospital;
        return HospitalDetailView(hospitalId: hospitalId, hospital: hospital);
      },
    ),
  ]
);