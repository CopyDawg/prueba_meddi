import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_meddi/models/hospital/hospital.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_event.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_bloc.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_event.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_state.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_state.dart';
import 'package:prueba_meddi/repositories/user_repository.dart';
import 'package:prueba_meddi/repositories/hospital_repository.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final UserRepository userRepository = UserRepository();
  final HospitalRepository hospitalRepository = HospitalRepository();
  int currentPage = 1;
  final int rowsPerPage = 10;
  int totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HospitalsBloc(hospitalRepository: hospitalRepository)
            ..add(FetchHospitals(currentPage, rowsPerPage)),
        ),
        BlocProvider(
          create: (_) => UserBloc(userRepository: userRepository),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 44, 131, 202),
              title: Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/meddi_white.png")
                  )
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    context.read<UserBloc>().add(LogoutEvent());
                  },
                ),
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_home.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserLoggedOut) {
                    context.go('/');
                  }
                },
                builder: (context, userState) {
                  return BlocBuilder<HospitalsBloc, HospitalsState>(
                    builder: (context, hospitalState) {
                      if (hospitalState is HospitalsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (hospitalState is HospitalsLoaded) {
                        totalPages = hospitalState.hospitalData.totalPages;
                        return Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left: 20, top: 10),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sucursales",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 3,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blueAccent
                                        ),
                                      ),
                                      Text(
                                        "Conoce nuestras sucursales",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 0, 0, 0)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Center(
                                child: ListView.builder(
                                  itemCount: hospitalState.hospitalData.hospitals.length,
                                  itemBuilder: (context, index) {
                                    final hospital = hospitalState.hospitalData.hospitals[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                                      child: HospitalCard(hospital: hospital),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: SizedBox()
                            ),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back, 
                                        color: Color.fromARGB(255, 92, 92, 92)
                                      ),
                                      onPressed: currentPage > 1
                                          ? () {
                                              setState(() {
                                                currentPage--;
                                              });
                                              context.read<HospitalsBloc>().add(FetchHospitals(currentPage,rowsPerPage));
                                            }
                                          : null,
                                    ),
                                    Text(
                                      'Página $currentPage / $totalPages',
                                      style: const TextStyle(color: Color.fromARGB(255, 92, 92, 92), fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward, 
                                        color: Color.fromARGB(255, 92, 92, 92),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          currentPage++;
                                        });
                                        context.read<HospitalsBloc>().add(
                                          FetchHospitals(currentPage, rowsPerPage),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (hospitalState is HospitalsError) {
                        return Center(child: Text(hospitalState.error));
                      }
                      return const Center(child: Text("No hay datos"));
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  const HospitalCard({
    super.key,
    required this.hospital,
  });

  final Hospital hospital;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(5)),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color.fromARGB(255, 148, 207, 255),
            Colors.white,
          ],
        ),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Image.network(
              hospital.logo,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/no_image.jpg',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Flexible(
            flex: 3,
            child: ListTile(
              title: Text(hospital.name),
              subtitle: Text("${hospital.phone}\n${hospital.address}"),
              onTap: () {
                context.push('/hospital/${hospital.id}', extra: hospital,);
              },
            ),
          ),
        ],
      ),
    );
  }
}