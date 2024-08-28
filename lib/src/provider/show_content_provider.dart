import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider manages the visibility of the content video.
final contentVisibilityProvider = StateProvider<bool>((ref) => true);
