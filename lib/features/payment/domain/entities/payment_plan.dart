import 'package:flutter/widgets.dart';

enum PaymentType { subscription, charge }

/// 결제 플랜 엔티티
class PaymentPlan {
  final String id;
  final String name;
  final int price;
  final int chatLimit;
  final double pricePerChat;
  final String description;
  final PaymentType type;
  final IconData icon;
  final String? googleProductId;

  const PaymentPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.chatLimit,
    required this.pricePerChat,
    required this.description,
    required this.type,
    required this.icon,
    this.googleProductId,
  });
}
