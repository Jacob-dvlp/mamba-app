import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_fast_tracker/domain/entities/fast_protocol_entity.dart';
import 'package:mamba_fast_tracker/domain/entities/fast_session_entity.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mamba_fast_tracker/presentation/home/cubit/fast_cubit.dart';

import '../../../helper/healper_test.dart';

void main() {
  late MockStartFastUseCase mockStart;
  late MockPauseFastUseCase mockPause;
  late MockResumeFastUseCase mockResume;
  late MockEndFastUseCase mockEnd;
  late MockGetActiveSessionUseCase mockGetActive;

  setUpAll(() {
    registerFallbackValue(FastProtocolEntity.sixteen8);
  });

  setUp(() {
    mockStart = MockStartFastUseCase();
    mockPause = MockPauseFastUseCase();
    mockResume = MockResumeFastUseCase();
    mockEnd = MockEndFastUseCase();
    mockGetActive = MockGetActiveSessionUseCase();

    when(() => mockGetActive()).thenAnswer((_) async => null);
  });

  FastCubit _buildCubit() => FastCubit(
        start: mockStart,
        pause: mockPause,
        resume: mockResume,
        end: mockEnd,
        getActive: mockGetActive,
      );

  group('initial state', () {
    test('starts as FastIdle when no active session', () async {
      when(() => mockGetActive()).thenAnswer((_) async => null);
      final cubit = _buildCubit();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<FastIdle>());
      cubit.close();
    });

    test('restores FastActive when running session exists in storage',
        () async {
      final session = Fixtures.runningSession();
      when(() => mockGetActive()).thenAnswer((_) async => session);

      final cubit = _buildCubit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<FastActive>());
      expect((cubit.state as FastActive).session.id, session.id);
      cubit.close();
    });

    test('restores FastActive paused when paused session exists', () async {
      final session = Fixtures.pausedSession();
      when(() => mockGetActive()).thenAnswer((_) async => session);

      final cubit = _buildCubit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<FastActive>());
      expect(
        (cubit.state as FastActive).session.status,
        FastStatus.paused,
      );
      cubit.close();
    });
  });

  group('startFast', () {
    blocTest<FastCubit, FastState>(
      'emits [FastLoading, FastActive] on success',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockStart(any()))
            .thenAnswer((_) async => Fixtures.runningSession());
      },
      build: _buildCubit,
      act: (cubit) => cubit.startFast(FastProtocolEntity.sixteen8),
      skip: 0,
      expect: () => [
        isA<FastLoading>(),
        isA<FastActive>(),
      ],
    );

    blocTest<FastCubit, FastState>(
      'emits FastError when use case throws',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockStart(any())).thenThrow(Exception('Network error'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.startFast(FastProtocolEntity.sixteen8),
      expect: () => [
        isA<FastLoading>(),
        isA<FastError>(),
      ],
    );

    blocTest<FastCubit, FastState>(
      'FastActive has correct protocol after start',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockStart(any())).thenAnswer(
          (_) async =>
              Fixtures.runningSession(protocol: FastProtocolEntity.twelve12),
        );
      },
      build: _buildCubit,
      act: (cubit) => cubit.startFast(FastProtocolEntity.twelve12),
      expect: () => [
        isA<FastLoading>(),
        predicate<FastState>((s) =>
            s is FastActive &&
            s.session.protocol == FastProtocolEntity.twelve12),
      ],
    );

    blocTest<FastCubit, FastState>(
      'calls StartFastUseCase with correct protocol',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockStart(any()))
            .thenAnswer((_) async => Fixtures.runningSession());
      },
      build: _buildCubit,
      act: (cubit) => cubit.startFast(FastProtocolEntity.eighteen6),
      verify: (_) {
        verify(() => mockStart(FastProtocolEntity.eighteen6)).called(1);
      },
    );
  });

  group('pauseFast', () {
    blocTest<FastCubit, FastState>(
      'emits FastActive with paused status',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockPause())
            .thenAnswer((_) async => Fixtures.pausedSession());
      },
      build: _buildCubit,
      act: (cubit) => cubit.pauseFast(),
      expect: () => [
        predicate<FastState>(
            (s) => s is FastActive && s.session.status == FastStatus.paused),
      ],
    );

    blocTest<FastCubit, FastState>(
      'emits nothing when pause returns null',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockPause()).thenAnswer((_) async => null);
      },
      build: _buildCubit,
      act: (cubit) => cubit.pauseFast(),
      expect: () => [],
    );
  });

  group('resumeFast', () {
    blocTest<FastCubit, FastState>(
      'emits FastActive running after resume',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockResume())
            .thenAnswer((_) async => Fixtures.runningSession());
      },
      build: _buildCubit,
      act: (cubit) => cubit.resumeFast(),
      expect: () => [
        predicate<FastState>(
          (s) => s is FastActive && s.session.status == FastStatus.running,
        ),
      ],
    );

    blocTest<FastCubit, FastState>(
      'emits nothing when resume returns null',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockResume()).thenAnswer((_) async => null);
      },
      build: _buildCubit,
      act: (cubit) => cubit.resumeFast(),
      expect: () => [],
    );
  });

  group('endFast', () {
    blocTest<FastCubit, FastState>(
      'emits FastCompleted when session ends',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockEnd())
            .thenAnswer((_) async => Fixtures.completedSession());
      },
      build: _buildCubit,
      act: (cubit) => cubit.endFast(),
      expect: () => [isA<FastCompleted>()],
    );

    blocTest<FastCubit, FastState>(
      'emits FastIdle when end returns null',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockEnd()).thenAnswer((_) async => null);
      },
      build: _buildCubit,
      act: (cubit) => cubit.endFast(),
      expect: () => [isA<FastIdle>()],
    );

    blocTest<FastCubit, FastState>(
      'FastCompleted has correct session data',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        final completed = Fixtures.completedSession(id: 'done-123');
        when(() => mockEnd()).thenAnswer((_) async => completed);
      },
      build: _buildCubit,
      act: (cubit) => cubit.endFast(),
      expect: () => [
        predicate<FastState>(
            (s) => s is FastCompleted && s.session.id == 'done-123'),
      ],
    );
  });

  group('dismissCompleted', () {
    blocTest<FastCubit, FastState>(
      'emits FastIdle from FastCompleted',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockEnd())
            .thenAnswer((_) async => Fixtures.completedSession());
      },
      build: _buildCubit,
      act: (cubit) async {
        await cubit.endFast();
        cubit.dismissCompleted();
      },
      expect: () => [
        isA<FastCompleted>(),
        isA<FastIdle>(),
      ],
    );
  });

  group('full fast lifecycle', () {
    blocTest<FastCubit, FastState>(
      'start → pause → resume → end emits correct sequence',
      setUp: () {
        when(() => mockGetActive()).thenAnswer((_) async => null);
        when(() => mockStart(any()))
            .thenAnswer((_) async => Fixtures.runningSession());
        when(() => mockPause())
            .thenAnswer((_) async => Fixtures.pausedSession());
        when(() => mockResume())
            .thenAnswer((_) async => Fixtures.runningSession());
        when(() => mockEnd())
            .thenAnswer((_) async => Fixtures.completedSession());
      },
      build: _buildCubit,
      act: (cubit) async {
        await cubit.startFast(FastProtocolEntity.sixteen8);
        await cubit.pauseFast();
        await cubit.resumeFast();
        await cubit.endFast();
      },
      expect: () => [
        isA<FastLoading>(),
        isA<FastActive>(),
        isA<FastActive>(),
        isA<FastActive>(),
        isA<FastCompleted>(),
      ],
    );
  });
}
