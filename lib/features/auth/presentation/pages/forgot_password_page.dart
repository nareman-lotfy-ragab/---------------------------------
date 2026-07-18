// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_input.dart';
// import '../bloc/auth_bloc.dart';

// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _tokenController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isResetMode = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _tokenController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _onSendResetEmail() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//             ForgotPasswordRequested(_emailController.text),
//           );
//     }
//   }

//   void _onResetPassword() {
//     if (_formKey.currentState!.validate()) {
//       if (_newPasswordController.text != _confirmPasswordController.text) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Passwords do not match'),
//             backgroundColor: AppColors.error,
//           ),
//         );
//         return;
//       }

//       context.read<AuthBloc>().add(
//             ResetPasswordRequested(
//               _emailController.text,
//               _tokenController.text,
//               _newPasswordController.text,
//             ),
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
//           if (state is PasswordResetSent) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Password reset email sent. Check your inbox.'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             setState(() => _isResetMode = true);
//           } else if (state is PasswordResetSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Password reset successful. Please login with your new password.'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Future.delayed(const Duration(seconds: 2), () {
//               context.go('/login');
//             });
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
//                     _isResetMode ? 'Reset Your Password' : 'Forgot Password?',
//                     style: Theme.of(context).textTheme.displayMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     _isResetMode
//                         ? 'Enter the reset token from your email and your new password'
//                         : 'Enter your email address and we\'ll send you a link to reset your password',
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
//                   ),
//                   const SizedBox(height: 32),
//                   // Email Input
//                   CustomInput(
//                     label: 'Email Address',
//                     hint: 'Enter your email',
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     prefixIcon: Icons.email_outlined,
//                     enabled: !_isResetMode,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return 'Please enter your email';
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   if (_isResetMode) ...[
//                     const SizedBox(height: 20),
//                     CustomInput(
//                       label: 'Reset Token',
//                       hint: 'Enter the token from your email',
//                       controller: _tokenController,
//                       prefixIcon: Icons.vpn_key_outlined,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please enter the reset token';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     CustomInput(
//                       label: 'New Password',
//                       hint: 'Enter your new password',
//                       controller: _newPasswordController,
//                       isPassword: true,
//                       prefixIcon: Icons.lock_outline,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please enter your new password';
//                         if (value.length < 6) return 'Password must be at least 6 characters';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     CustomInput(
//                       label: 'Confirm Password',
//                       hint: 'Confirm your new password',
//                       controller: _confirmPasswordController,
//                       isPassword: true,
//                       prefixIcon: Icons.lock_outline,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) return 'Please confirm your password';
//                         return null;
//                       },
//                     ),
//                   ],
//                   const SizedBox(height: 40),
//                   BlocBuilder<AuthBloc, AuthState>(
//                     builder: (context, state) {
//                       return CustomButton(
//                         text: _isResetMode ? 'Reset Password' : 'Send Reset Email',
//                         isLoading: state is AuthLoading,
//                         onPressed: _isResetMode ? _onResetPassword : _onSendResetEmail,
//                       );
//                     },
//                   ),
//                   if (!_isResetMode)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 24),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Remember your password? ",
//                             style: TextStyle(color: AppColors.textSecondary),
//                           ),
//                           GestureDetector(
//                             onTap: () => context.pop(),
//                             child: const Text(
//                               'Login',
//                               style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isResetMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSendResetEmail() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ForgotPasswordRequested(_emailController.text),
          );
    }
  }

  void _onResetPassword() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
            ResetPasswordRequested(
            _emailController.text,
            _tokenController.text,
            _newPasswordController.text,
          )
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PasswordResetSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset email sent. Check your inbox.'),
                backgroundColor: Colors.green,
              ),
            );
            setState(() => _isResetMode = true);
          } else if (state is PasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset successful. Please login with your new password.'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              context.go('/login');
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isResetMode ? 'Reset Your Password' : 'Forgot Password?',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isResetMode
                        ? 'Enter the reset token from your email and your new password'
                        : 'Enter your email address and we\'ll send you a link to reset your password',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  // Email Input
                  if (!_isResetMode)
                    CustomInput(
                      label: 'Email Address',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  if (_isResetMode) ...[
                    const SizedBox(height: 20),
                    CustomInput(
                      label: 'Reset Token',
                      hint: 'Enter the token from your email',
                      controller: _tokenController,
                      prefixIcon: Icons.vpn_key_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter the reset token';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomInput(
                      label: 'New Password',
                      hint: 'Enter your new password',
                      controller: _newPasswordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your new password';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomInput(
                      label: 'Confirm Password',
                      hint: 'Confirm your new password',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please confirm your password';
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 40),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: _isResetMode ? 'Reset Password' : 'Send Reset Email',
                        isLoading: state is AuthLoading,
                        onPressed: _isResetMode ? _onResetPassword : _onSendResetEmail,
                      );
                    },
                  ),
                  if (!_isResetMode)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Remember your password? ",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
