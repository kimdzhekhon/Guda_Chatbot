import 'package:flutter/material.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';

/// Supabase의 `products` 테이블 데이터를 매핑하는 DTO
class ProductDto {
  final String id;
  final String name;
  final String type;
  final int price;
  final int? usageLimit;
  final double? pricePerChat;
  final String? description;
  final String? iconName;
  final String? googleProductId;

  const ProductDto({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.usageLimit,
    this.pricePerChat,
    this.description,
    this.iconName,
    this.googleProductId,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      price: json['price'] as int,
      usageLimit: json['usage_limit'] as int?,
      pricePerChat: (json['price_per_chat'] as num?)?.toDouble(),
      description: json['description'] as String?,
      iconName: json['icon_name'] as String?,
      googleProductId: json['google_product_id'] as String?,
    );
  }

  /// 엔티티로 변환
  PaymentPlan toEntity() {
    return PaymentPlan(
      id: id,
      name: name,
      price: price,
      chatLimit: usageLimit ?? 0,
      pricePerChat: pricePerChat ?? 0.0,
      description: description ?? '',
      type: type == 'subscription'
          ? PaymentType.subscription
          : PaymentType.charge,
      icon: _getIconData(iconName),
      googleProductId: googleProductId,
    );
  }

  /// 문자열 아이콘 이름을 IconData로 변환
  IconData _getIconData(String? name) {
    switch (name) {
      case 'eco':
        return Icons.eco;
      case 'psychology':
        return Icons.psychology;
      case 'premium':
        return Icons.workspace_premium;
      case 'chat':
        return Icons.chat_bubble;
      case 'forum':
        return Icons.forum;
      case 'people':
        return Icons.people;
      default:
        return Icons.payments;
    }
  }
}
