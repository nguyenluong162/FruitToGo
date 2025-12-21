import 'package:flutter/material.dart';
import '../widgets/double_circle.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool rememberMe = false;
  bool obscurePassword = true;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header box
              Container(
                width: double.infinity,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9DA82),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                child: Stack(
                  children: [
                    // Background decorative circles
                    Positioned(
                      top: -40,
                      left: 310,
                      child: DoubleCircle(outerRadius: 70, innerRadius: 60),
                    ),
                    Positioned(
                      top: 100,
                      left: -30,
                      child: DoubleCircle(outerRadius: 55, innerRadius: 46),
                    ),

                    // Header content (arrow + text)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            },
                            child: Image.asset(
                              'assets/icons/left-arrow.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Let's get to know you more.",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Email
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFEBA3),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: const Color(0xFFFFEBA3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    // contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16), // adjust to center the icon nicely
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            _obscureText
                                ? 'assets/icons/eye-close.png'
                                : 'assets/icons/eye-open.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  ),
                ),
              ),


              const SizedBox(height: 8),

              // Remember me + Forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              rememberMe = !rememberMe;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 10), // 👈 nudges the icon upward
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset(
                                rememberMe
                                    ? 'assets/icons/checkbox-tick.png'
                                    : 'assets/icons/checkbox.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Remember me'),
                      ],
                    ),

                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDF8E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context,'/home');
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1, color: Color(0xFFF9DA82))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Color(0xFFF9DA82))),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Google login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDF8E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: Image.asset(
                      'assets/icons/google.png',
                      width: 24,
                      height: 24,
                    ),
                    label: const Text(
                      'Log in with Google',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),


              const SizedBox(height: 12),

              // Facebook login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDF8E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: Image.asset(
                      'assets/icons/facebook.png',
                      width: 24,
                      height: 24,
                    ),
                    label: const Text(
                      'Log in with Facebook',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Terms
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By clicking continue, you agree to our ',
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),

        ),
      ),
    );
  }
}
