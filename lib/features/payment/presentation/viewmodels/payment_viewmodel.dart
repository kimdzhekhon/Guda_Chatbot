import 'package:flutter/material.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_viewmodel.g.dart';

class PaymentState {
  final List<PaymentPlan> subscriptionPlans;
  final List<PaymentPlan> chargePlans;
  final PaymentType selectedType;

  PaymentState({
    required this.subscriptionPlans,
    required this.chargePlans,
    this.selectedType = PaymentType.subscription,
  });

  List<PaymentPlan> get currentPlans =>
      selectedType == PaymentType.subscription ? subscriptionPlans : chargePlans;

  PaymentState copyWith({
    List<PaymentPlan>? subscriptionPlans,
    List<PaymentPlan>? chargePlans,
    PaymentType? selectedType,
  }) {
    return PaymentState(
      subscriptionPlans: subscriptionPlans ?? this.subscriptionPlans,
      chargePlans: chargePlans ?? this.chargePlans,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

@riverpod
class PaymentViewModel extends _$PaymentViewModel {
  @override
  PaymentState build() {
    final subscriptionPlans = [
      const PaymentPlan(
        id: 'light',
        name: 'Guda Light',
        price: 7900,
        chatLimit: 500,
        pricePerChat: 15.8,
        description: '가볍게 시작하는 명상과 대화',
        type: PaymentType.subscription,
        icon: Icons.eco,
      ),
      const PaymentPlan(
        id: 'pro',
        name: 'Guda Pro',
        price: 14900,
        chatLimit: 1200,
        pricePerChat: 12.4,
        description: '깊이 있는 탐구를 위한 추천 요금제',
        type: PaymentType.subscription,
        icon: Icons.psychology,
      ),
      const PaymentPlan(
        id: 'elite',
        name: 'Guda Elite',
        price: 29900,
        chatLimit: 3000,
        pricePerChat: 9.9,
        description: '모든 지혜를 자유롭게 누리는 마스터 플랜',
        type: PaymentType.subscription,
        icon: Icons.workspace_premium,
      ),
    ];

    final chargePlans = [
      const PaymentPlan(
        id: 'charge_100',
        name: '100회 충전',
        price: 2900,
        chatLimit: 100,
        pricePerChat: 29.0,
        description: '부담 없이 한 번씩 사용하는 실속형',
        type: PaymentType.charge,
        icon: Icons.chat_bubble,
      ),
      const PaymentPlan(
        id: 'charge_200',
        name: '200회 충전',
        price: 4900,
        chatLimit: 200,
        pricePerChat: 24.5,
        description: '가장 많은 사용자가 선택하는 충전식',
        type: PaymentType.charge,
        icon: Icons.forum,
      ),
      const PaymentPlan(
        id: 'charge_500',
        name: '500회 충전',
        price: 9900,
        chatLimit: 500,
        pricePerChat: 19.8,
        description: '헤비 유저를 위한 대용량 충전 플랜',
        type: PaymentType.charge,
        icon: Icons.people,
      ),
    ];

    return PaymentState(
      subscriptionPlans: subscriptionPlans,
      chargePlans: chargePlans,
    );
  }

  void selectType(PaymentType type) {
    state = state.copyWith(selectedType: type);
  }
}
