import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_fast_tracker/presentation/meal/cubit/meal_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helper/healper_test.dart';

void main() {
  late MockAddMealUseCase mockAdd;
  late MockUpdateMealUseCase mockUpdate;
  late MockDeleteMealUseCase mockDelete;
  late MockGetMealsByDateUseCase mockGetByDate;

  setUp(() {
    mockAdd = MockAddMealUseCase();
    mockUpdate = MockUpdateMealUseCase();
    mockDelete = MockDeleteMealUseCase();
    mockGetByDate = MockGetMealsByDateUseCase();
  });

  MealCubit _buildCubit() => MealCubit(
        add: mockAdd,
        update: mockUpdate,
        delete: mockDelete,
        getByDate: mockGetByDate,
      );

  group('loadMeals', () {
    blocTest<MealCubit, MealState>(
      'emits [MealLoading, MealLoaded] with meal list',
      setUp: () {
        when(() => mockGetByDate(any()))
            .thenAnswer((_) async => Fixtures.mealList());
      },
      build: _buildCubit,
      act: (cubit) => cubit.loadMeals(),
      expect: () => [
        isA<MealLoading>(),
        predicate<MealState>((s) => s is MealLoaded && s.meals.length == 3),
      ],
    );

    blocTest<MealCubit, MealState>(
      'emits MealLoaded with empty list when no meals',
      setUp: () {
        when(() => mockGetByDate(any())).thenAnswer((_) async => []);
      },
      build: _buildCubit,
      act: (cubit) => cubit.loadMeals(),
      expect: () => [
        isA<MealLoading>(),
        predicate<MealState>((s) => s is MealLoaded && s.meals.isEmpty),
      ],
    );

    blocTest<MealCubit, MealState>(
      'emits MealError when use case throws',
      setUp: () {
        when(() => mockGetByDate(any())).thenThrow(Exception('DB error'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.loadMeals(),
      expect: () => [
        isA<MealLoading>(),
        isA<MealError>(),
      ],
    );

    blocTest<MealCubit, MealState>(
      'MealLoaded totalCalories sums all meals',
      setUp: () {
        when(() => mockGetByDate(any())).thenAnswer((_) async => [
              Fixtures.meal(id: '1', calories: 300),
              Fixtures.meal(id: '2', calories: 400),
              Fixtures.meal(id: '3', calories: 300),
            ]);
      },
      build: _buildCubit,
      act: (cubit) => cubit.loadMeals(),
      expect: () => [
        isA<MealLoading>(),
        predicate<MealState>((s) => s is MealLoaded && s.totalCalories == 1000),
      ],
    );
  });

  group('addMeal', () {
    blocTest<MealCubit, MealState>(
      'adds meal and reloads list',
      setUp: () {
        when(() => mockAdd(
                name: any(named: 'name'), calories: any(named: 'calories')))
            .thenAnswer((_) async => Fixtures.meal());
        when(() => mockGetByDate(any()))
            .thenAnswer((_) async => [Fixtures.meal()]);
      },
      build: _buildCubit,
      act: (cubit) => cubit.addMeal(name: 'Frango', calories: 350),
      expect: () => [
        isA<MealLoading>(),
        isA<MealLoaded>(),
      ],
    );

    blocTest<MealCubit, MealState>(
      'emits MealError when add throws',
      setUp: () {
        when(() => mockAdd(
                name: any(named: 'name'), calories: any(named: 'calories')))
            .thenThrow(Exception('Save failed'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.addMeal(name: 'X', calories: 100),
      expect: () => [isA<MealError>()],
    );

    blocTest<MealCubit, MealState>(
      'calls AddMealUseCase with correct params',
      setUp: () {
        when(() => mockAdd(
                name: any(named: 'name'), calories: any(named: 'calories')))
            .thenAnswer((_) async => Fixtures.meal());
        when(() => mockGetByDate(any())).thenAnswer((_) async => []);
      },
      build: _buildCubit,
      act: (cubit) => cubit.addMeal(name: 'Pizza', calories: 800),
      verify: (_) {
        verify(() => mockAdd(name: 'Pizza', calories: 800)).called(1);
      },
    );
  });

  group('deleteMeal', () {
    blocTest<MealCubit, MealState>(
      'deletes meal and reloads list',
      setUp: () {
        when(() => mockDelete(any())).thenAnswer((_) async {});
        when(() => mockGetByDate(any())).thenAnswer((_) async => []);
      },
      build: _buildCubit,
      act: (cubit) => cubit.deleteMeal('meal-1'),
      expect: () => [
        isA<MealLoading>(),
        isA<MealLoaded>(),
      ],
    );

    blocTest<MealCubit, MealState>(
      'calls DeleteMealUseCase with correct id',
      setUp: () {
        when(() => mockDelete(any())).thenAnswer((_) async {});
        when(() => mockGetByDate(any())).thenAnswer((_) async => []);
      },
      build: _buildCubit,
      act: (cubit) => cubit.deleteMeal('abc-123'),
      verify: (_) {
        verify(() => mockDelete('abc-123')).called(1);
      },
    );
  });
}
