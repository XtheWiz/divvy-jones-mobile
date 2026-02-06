import 'package:flutter/material.dart';

/// Maps expense category strings to Material icons.
class CategoryIcons {
  const CategoryIcons._();

  static IconData fromCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.local_taxi;
      case 'entertainment':
        return Icons.movie;
      case 'accommodation':
        return Icons.hotel;
      case 'shopping':
        return Icons.shopping_bag;
      case 'health':
        return Icons.medical_services;
      case 'utilities':
        return Icons.power;
      default:
        return Icons.receipt;
    }
  }
}
