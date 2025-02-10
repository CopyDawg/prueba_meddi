import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_meddi/models/hospital/hospital.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_bloc.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_event.dart';
import 'package:prueba_meddi/presentation/blocs/hospitals_bloc/hospitals_state.dart';
import 'package:prueba_meddi/repositories/hospital_repository.dart';

class HospitalDetailView extends StatelessWidget {
  final String hospitalId;
  final Hospital hospital;

  HospitalDetailView({super.key, required this.hospitalId, required this.hospital});
  final HospitalRepository hospitalRepository = HospitalRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HospitalsBloc(hospitalRepository: hospitalRepository),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/home');
            },
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 44, 131, 202),
          title: const Text("Detalles del hospital", style: TextStyle(color: Colors.white),)
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_home.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<HospitalsBloc, HospitalsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hospital.photo.isNotEmpty
                      ? Image.network(
                          hospital.photo,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          }
                        )
                      : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          hospital.name, 
                          textAlign: TextAlign.center, 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 20
                          )
                        )
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: 'Dirección: ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: hospital.address,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: 'Teléfono: ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: hospital.phone,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: 'Horario: ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: hospital.schedule,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<HospitalsBloc>().add(
                            SendRequest(hospitalId),
                          );
                          if(state is HospitalsTokenExpired) {
                            context.go('/');
                          } else if(state is HospitalsError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No se ha enviado la solicitud, intente más tarde"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Se ha enviado la solicitud al hopital"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 97, 135, 223)),
                          foregroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
                        ),
                        child: const Text("Enviar Solicitud"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}