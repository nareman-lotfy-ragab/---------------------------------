// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_input.dart';
// import '../bloc/auth_bloc.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String _selectedRole = 'Farmer';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _onSignUp() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//             SignUpRequested(_emailController.text, _passwordController.text, _selectedRole),
//           );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthAuthenticated) {
//             context.go('/home');
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
//             );
//           }
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Create Account',
//                     style: Theme.of(context).textTheme.displayMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Join Agri-Sense AI and start your journey',
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
//                   ),
//                   const SizedBox(height: 32),
//                   const Text(
//                     'Select Your Role',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
//                   ),
//                   const SizedBox(height: 12),
//                   // Row(
//                   //   children: [
//                   //     Expanded(
//                   //       child: _RoleCard(
//                   //         title: 'Farmer',
//                   //         icon: Icons.agriculture,
//                   //         isSelected: _selectedRole == 'Farmer',
//                   //         onTap: () => setState(() => _selectedRole = 'Farmer'),
//                   //       ),
//                   //     ),
//                   //     const SizedBox(width: 16),
//                   //     Expanded(
//                   //       child: _RoleCard(
//                   //         title: 'Consultant',
//                   //         icon: Icons.person_search,
//                   //         isSelected: _selectedRole == 'Consultant',
//                   //         onTap: () => setState(() => _selectedRole = 'Consultant'),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   const SizedBox(height: 32),
//                   CustomInput(
//                     label: 'Email Address',
//                     hint: 'Enter your email',
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     prefixIcon: Icons.email_outlined,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return 'Please enter your email';
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   CustomInput(
//                     label: 'Password',
//                     hint: 'Enter your password',
//                     controller: _passwordController,
//                     isPassword: true,
//                     prefixIcon: Icons.lock_outline,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return 'Please enter your password';
//                       if (value.length < 6) return 'Password must be at least 6 characters';
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   BlocBuilder<AuthBloc, AuthState>(
//                     builder: (context, state) {
//                       return CustomButton(
//                         text: 'Create Account',
//                         isLoading: state is AuthLoading,
//                         onPressed: _onSignUp,
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Already have an account? ",
//                         style: TextStyle(color: AppColors.textSecondary),
//                       ),
//                       GestureDetector(
//                         onTap: () => context.pop(),
//                         child: const Text(
//                           'Login',
//                           style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RoleCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _RoleCard({
//     required this.title,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primaryGreen.withOpacity(0.1) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryGreen : AppColors.border,
//             width: 2,
//           ),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary, size: 32),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final String _selectedRole = 'Farmer';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              _fullNameController.text.trim(),
              _selectedRole,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: BlocListener<AuthBloc, AuthState>(
       listener: (context, state) {
  if (state is AuthUnauthenticated) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully. Please sign in.'),
        backgroundColor: Colors.green,
      ),
    );

    context.go('/login');
  }

  else if (state is AuthError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message),
        backgroundColor: AppColors.error,
      ),
    );
  }
},

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      /// LOGO
                      Container(
                        width: 90,
                        height: 90,

                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.eco_outlined,
                          color: AppColors.primaryGreen,
                          size: 45,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// TITLE
                      Text(
                        'Agri-Sense AI',

                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 10),

                      /// SUBTITLE
                      Text(
                        'Create your account and start now',

                        textAlign: TextAlign.center,

                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      ),

                      const SizedBox(height: 35),

                      /// FULL NAME
                      CustomInput(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }

                          if (value.length < 3) {
                            return 'Name must be at least 3 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// EMAIL
                      CustomInput(
                        label: 'Email Address',
                        hint: 'Enter your email',

                        controller: _emailController,

                        keyboardType: TextInputType.emailAddress,

                        prefixIcon: Icons.email_outlined,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }

                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// PASSWORD
                      CustomInput(
                        label: 'Password',
                        hint: 'Enter your password',

                        controller: _passwordController,

                        isPassword: true,

                        prefixIcon: Icons.lock_outline,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// CONFIRM PASSWORD
                      CustomInput(
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',

                        controller: _confirmPasswordController,

                        isPassword: true,

                        prefixIcon: Icons.lock_outline,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }

                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 35),

                      /// BUTTON
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'Create Account',
                            isLoading: state is AuthLoading,
                            onPressed: _onSignUp,
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      /// LOGIN TEXT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),

                          GestureDetector(
                            onTap: () => context.pop(),

                            child: const Text(
                              'Login',

                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}