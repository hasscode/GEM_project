---
name: flutter-cubit
description: Create or update Flutter Cubits and state classes for Flutter projects. Use when adding *_cubit.dart, *_state.dart, or feature state management.
---

# Flutter Cubit And State

Follow [AGENTS.md](../../../AGENTS.md) and the feature skill. Preserve the nearby state structure and presentation/bloc or presentation/cubit folder naming.

Apply [Clarification Before Action](../../../AGENTS.md#clarification-before-action) when behavior, contracts, or concurrency requirements are uncertain; ask before the dependent change.

## Contracts And State

- Inject repository interfaces or small domain services through the constructor. Keep Dio/Firebase/storage/DTOs/mappers and navigation out of the Cubit.
- Follow the repository's actual contract: a Future that throws, a typed result, or Either when already used. Do not introduce a result package or a new use-case layer just to match an example.
- Use immutable fields and appropriate equality. With Equatable, include all fields that affect observable state in props.
- Take immutable snapshots of collections and protect nested mutable data. A final List/Map reference does not make its contents immutable; never mutate an emitted state's collections.
- Use sealed states for distinct alternatives, or an immutable snapshot for retained data and independent operations, following the feature's existing pattern.
- Initial loading may replace an empty screen. Refresh or background updates should retain useful data and represent their own progress/error unless the workflow requires clearing it.
- Keep controllers and secrets out of state. Expose safe domain failures or presentation error information; avoid raw exception strings.
- Keep state selection cheap and immutable; use BlocSelector/context.select for subtrees that need a specific value.

## Async Lifecycle And Concurrency

- Check whether the Cubit is closed before accepting work and before emitting a result after an asynchronous boundary, including error paths.
- Choose concurrency per intent. Search/filter loads often use latest-result-wins; a submit may block duplicate taps; operations whose order matters may be serialized. Do not apply one policy to every action.
- Ignore obsolete results using a generation/request ID or equivalent. This does not cancel the underlying network operation; use domain-compatible cancellation when supported and beneficial.
- Clean up owned subscriptions/timers and invalidate obsolete work on close or account changes. Longer-lived background delivery belongs to a service.
- Automatic transport retries follow [network_rules.md](../../../.agent/rules/network_rules.md). An explicit user retry method must not create a second automatic loop.
- Model one-time listener effects deliberately so repeated valid actions still produce their intended feedback; do not add arbitrary timestamps to every state.

## Example: Latest Load Wins And Refresh Retains Data

This example assumes an immutable domain ExampleModel and a safe error-message mapper. It illustrates a Future-returning repository; adapt error handling to the actual feature contract.

~~~dart
abstract interface class ExampleRepository {
  Future<ExampleModel> load();
}

final class ExampleState extends Equatable {
  const ExampleState({
    this.data,
    this.isLoading = false,
    this.errorMessage,
  });

  final ExampleModel? data;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [data, isLoading, errorMessage];
}

class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit(
    this._repository, {
    required String Function(Object) errorMessageFor,
  }) : _errorMessageFor = errorMessageFor,
       super(const ExampleState());

  final ExampleRepository _repository;
  final String Function(Object) _errorMessageFor;
  int _requestId = 0;

  Future<void> load() async {
    if (isClosed) return;
    final request = ++_requestId;
    final previousData = state.data;
    emit(ExampleState(data: previousData, isLoading: true));

    try {
      final data = await _repository.load();
      if (isClosed || request != _requestId) return;
      emit(ExampleState(data: data));
    } catch (error) {
      if (isClosed || request != _requestId) return;
      emit(ExampleState(
        data: previousData,
        errorMessage: _errorMessageFor(error),
      ));
    }
  }
}
~~~

## Verify

- Register dependencies in the existing DI setup where needed.
- Read [unit-testing.md](../flutter-feature/references/unit-testing.md) before writing tests. Cover closure, out-of-order results, duplicate-submit behavior, refresh retention, and retry where applicable using controlled Futures/time.
