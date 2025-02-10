import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_event.dart';
import 'package:prueba_meddi/presentation/blocs/user_bloc/user_state.dart';
import 'package:prueba_meddi/repositories/user_repository.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (_) => UserBloc(userRepository: userRepository),
      child: BlocLoginView(
        emailController: emailController, 
        passwordController: passwordController
      )
    );
  }
}

class BlocLoginView extends StatefulWidget {
  const BlocLoginView({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<BlocLoginView> createState() => _BlocLoginViewState();
}

class _BlocLoginViewState extends State<BlocLoginView> {
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
                    if (state is UserSuccess) {
                      context.go('/home');
                    } else if (state is UserFailure) {
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: widget.emailController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            iconColor: Color.fromARGB(255, 44, 107, 196),
                            labelText: "Correo",
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
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            final email = widget.emailController.text;
                            final password = widget.passwordController.text;
                            context.read<UserBloc>().add(LoginEvent(email: email, password: password));
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 128, 207, 95)),
                            foregroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
                          ),
                          child: const Text("Iniciar sesión"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: InkWell(
                onTap: () => context.push("/register"),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Aún no tienes cuenta?",
                      style: TextStyle(color: Color.fromARGB(255, 92, 162, 62)),
                    ),
                    Text(
                      " Regístrate",
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