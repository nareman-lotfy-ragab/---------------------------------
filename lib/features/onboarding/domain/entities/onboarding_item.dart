import 'package:equatable/equatable.dart';

class OnboardingItem extends Equatable {
  final String title;
  final String description;
  final String image;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  List<Object?> get props => [title, description, image];
}
