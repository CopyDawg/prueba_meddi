import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_event.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_state.dart';
import 'package:prueba_meddi/repositories/user_repository.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return BlocProvider(
      create: (_) => UserBloc(userRepository: userRepository),
      child: BlocRegisterView(
        emailController: emailController,
        phoneController: phoneController,
        passwordController: passwordController,
        nameController: nameController,
      ),
    );
  }
}

class BlocRegisterView extends StatefulWidget {
  const BlocRegisterView({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.nameController,
  });

  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController nameController;

  @override
  State<BlocRegisterView> createState() => _BlocRegisterViewState();
}

  class _BlocRegisterViewState extends State<BlocRegisterView> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_auth.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserRegistered) {
                      context.go('/');
                    }
                    else if (state is UserFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: widget.nameController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              iconColor: Color.fromARGB(255, 44, 107, 196),
                              labelText: "Nombre",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: widget.emailController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              iconColor: Color.fromARGB(255, 44, 107, 196),
                              labelText: "Correo",
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: widget.phoneController,
                            keyboardType: const TextInputType.numberWithOptions(),
                            decoration: const InputDecoration(
                              icon: Icon(Icons.phone),
                              iconColor: Color.fromARGB(255, 44, 107, 196),
                              labelText: "Teléfono",
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 56.0,
                            child: TextField(
                              controller: widget.passwordController,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.password_outlined),
                                iconColor: const Color.fromARGB(255, 44, 107, 196),
                                labelText: "Contraseña",
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              obscureText: _obscureText,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              final email = widget.emailController.text;
                              final phone = widget.phoneController.text;
                              final password = widget.passwordController.text;
                              final name = widget.nameController.text;
                              context.read<UserBloc>().add(
                                RegisterEvent(
                                  email: email, 
                                  password: password, 
                                  name: name, 
                                  phone: phone
                                )
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 128, 207, 95)),
                              foregroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
                            ),
                            child: const Text("Regístrate"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: InkWell(
                onTap: () => context.push("/"),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes cuenta?",
                      style: TextStyle(color: Color.fromARGB(255, 92, 162, 62)),
                    ),
                    Text(
                      " Inicia sesión",
                      style: TextStyle(color: Color.fromARGB(255, 92, 162, 62)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}