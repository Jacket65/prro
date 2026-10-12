import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_outcome.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_use_case.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/finish_pending_order_state.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/pending_order_cubit.dart';

class MockFinishPendingOrderUseCase extends Mock
    implements FinishPendingOrderUseCase {}

class MockPendingOrderStore extends Mock implements PendingOrderStoreI {}

PendingOrder _pending({String orderId = '1042'}) => PendingOrder(
  orderId: orderId,
  idempotencyKey: 'key-42',
  // Any instant: the cubit carries it through, never compares it.
  createdAt: DateTime(2026, 1, 1, 12),
);

void main() {
  setUpAll(() {
    registerFallbackValue(_pending());
  });

  late MockFinishPendingOrderUseCase finishPendingOrder;
  late MockPendingOrderStore store;
  late PendingOrderCubit cubit;

  setUp(() {
    finishPendingOrder = MockFinishPendingOrderUseCase();
    store = MockPendingOrderStore();
    when(() => store.clear()).thenAnswer((_) async {});
    when(() => finishPendingOrder.reject()).thenAnswer((_) async {});
    cubit = PendingOrderCubit(finishPendingOrder, store);
  });

  tearDown(() => cubit.close());

  group('load', () {
    blocTest<PendingOrderCubit, PendingOrderState>(
      'nothing pending stays hidden and calls nothing',
      setUp: () => when(() => store.read()).thenReturn(null),
      build: () => cubit,
      act: (bloc) => bloc.load(),
      expect: () => const <PendingOrderState>[PendingOrderHidden()],
      verify: (_) => verifyNever(
        () => finishPendingOrder.load(),
      ),
    );

    blocTest<PendingOrderCubit, PendingOrderState>(
      'a pending order resolves through the receipt read',
      setUp: () {
        when(() => store.read()).thenReturn(_pending());
        when(() => finishPendingOrder.load()).thenAnswer(
          (_) async => PendingOrderUnfinished(
            orderId: '1042',
            idempotencyKey: 'key-42',
            createdAt: DateTime.utc(2026),
            totalKopecks: 45000,
          ),
        );
      },
      build: () => cubit,
      act: (bloc) => bloc.load(),
      expect: () => <dynamic>[
        const PendingOrderResolving(),
        isA<PendingOrderReady>()
            .having((s) => s.orderId, 'orderId', '1042')
            .having((s) => s.totalKopecks, 'totalKopecks', 45000),
      ],
    );

    blocTest<PendingOrderCubit, PendingOrderState>(
      'an already-settled order surfaces the notice',
      setUp: () {
        when(() => store.read()).thenReturn(_pending());
        when(() => finishPendingOrder.load()).thenAnswer(
          (_) async =>
              const PendingOrderAlreadySettled('Оплату вже підтверджено.'),
        );
      },
      build: () => cubit,
      act: (bloc) => bloc.load(),
      expect: () => const <PendingOrderState>[
        PendingOrderResolving(),
        PendingOrderNotice('Оплату вже підтверджено.'),
      ],
    );
  });

  group('confirm', () {
    blocTest<PendingOrderCubit, PendingOrderState>(
      'a confirmed order leaves only the notice',
      setUp: () {
        when(() => store.read()).thenReturn(_pending());
        when(() => finishPendingOrder.confirm(any())).thenAnswer(
          (_) async => const PendingOrderConfirmed('Оплату підтверджено.'),
        );
      },
      build: () => cubit,
      act: (bloc) async {
        await bloc.confirm();
      },
      expect: () => const <PendingOrderState>[
        PendingOrderResolving(),
        PendingOrderNotice('Оплату підтверджено.'),
      ],
      verify: (_) => verify(
        () => finishPendingOrder.confirm(any()),
      ).called(1),
    );

    blocTest<PendingOrderCubit, PendingOrderState>(
      'a failed confirm returns to actionable, keeping the record',
      setUp: () {
        when(() => store.read()).thenReturn(_pending());
        when(() => finishPendingOrder.confirm(any())).thenAnswer(
          (_) async => const PendingOrderConfirmFailed(
            'Не вдалося підтвердити оплату. Спробути ще раз?',
          ),
        );
      },
      build: () => cubit,
      act: (bloc) => bloc.confirm(),
      expect: () => <dynamic>[
        const PendingOrderResolving(),
        isA<PendingOrderReady>()
            .having((s) => s.orderId, 'orderId', '1042')
            .having(
              (s) => s.message,
              'message',
              'Не вдалося підтвердити оплату. Спробути ще раз?',
            ),
      ],
    );

    blocTest<PendingOrderCubit, PendingOrderState>(
      'confirm without a stored record does nothing',
      setUp: () => when(() => store.read()).thenReturn(null),
      build: () => cubit,
      act: (bloc) => bloc.confirm(),
      expect: () => const <PendingOrderState>[],
      verify: (_) => verifyNever(() => finishPendingOrder.confirm(any())),
    );
  });

  group('reject', () {
    blocTest<PendingOrderCubit, PendingOrderState>(
      'drops the local record and hides the banner',
      setUp: () => when(() => store.read()).thenReturn(_pending()),
      build: () => cubit,
      act: (bloc) => bloc.reject(),
      expect: () => const <PendingOrderState>[PendingOrderHidden()],
      verify: (_) {
        verify(() => finishPendingOrder.reject()).called(1);
        verifyNever(() => finishPendingOrder.confirm(any()));
      },
    );
  });
}
