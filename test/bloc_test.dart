import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/repositories/auth_repository.dart';
import 'package:task_manager/data/repositories/task_details_repository.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/data/models/auth_model.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/logic/task_details/task_details_bloc.dart';

// Generate mocks
@GenerateMocks(
    [TaskRepository, AuthRepository, TaskDetailsRepository, InternetCubit])
import 'bloc_test.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockInternetCubit mockInternetCubit;
  late MockTaskRepository mockTaskRepository;
  late TaskBloc taskBloc;
  late MockTaskDetailsRepository mockTaskDetailsRepository;
  late TaskDetailsBloc taskDetailsBloc;

  setUpAll(() {
    provideDummy<InternetState>(InternetConnected());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockInternetCubit = MockInternetCubit();
    mockTaskRepository = MockTaskRepository();
    mockTaskDetailsRepository = MockTaskDetailsRepository();

    when(mockInternetCubit.stream)
        .thenAnswer((_) => Stream.value(InternetConnected()));
    when(mockInternetCubit.state).thenReturn(InternetConnected());

    authBloc = AuthBloc(
      authRepository: mockAuthRepository,
      internetCubit: mockInternetCubit,
    );

    taskBloc = TaskBloc(
      taskRepository: mockTaskRepository,
      internetCubit: mockInternetCubit,
    );

    taskDetailsBloc = TaskDetailsBloc(
      internetCubit: mockInternetCubit,
      taskDetailsRepository: mockTaskDetailsRepository,
    );
  });

  tearDown(() {
    authBloc.close();
    taskBloc.close();
  });

  group(
    "InternetCubit",
    () {
      test('initial state is InternetConnected', () {
        when(mockInternetCubit.state).thenReturn(InternetConnected());
        expect(mockInternetCubit.state, isA<InternetConnected>());
      });

      test('emits InternetDisConnected state', () {
        when(mockInternetCubit.state).thenReturn(InternetDisconnected());
        expect(mockInternetCubit.state, isA<InternetDisconnected>());
      });
    },
  );

  group(
    "AuthBloc",
    () {
      test('initial state is AuthInitial', () {
        expect(authBloc.state, isA<AuthInitial>());
      });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoadingState, AuthLoggedInState] when LoginEvent is added and login is successful',
        build: () {
          when(mockAuthRepository.login(any, any)).thenAnswer(
              (_) async => Auth(accessToken: 'token', refreshToken: 'refresh'));
          return authBloc;
        },
        act: (bloc) =>
            bloc.add(const LoginEvent(email: 'username', password: 'password')),
        expect: () => [
          isA<AuthLoadingState>(),
          isA<AuthLoggedInState>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.login('username', 'password')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoadingState, AuthLoginErrorState] when LoginEvent is added and login fails',
        build: () {
          when(mockAuthRepository.login(any, any))
              .thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) =>
            bloc.add(const LoginEvent(email: 'username', password: 'password')),
        expect: () => [
          isA<AuthLoadingState>(),
          isA<AuthLoginErrorState>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.login('username', 'password')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoadingState, AuthLoggedInState] when CheckAuthState is added and auth is valid',
        build: () {
          when(mockAuthRepository.getAccessToken())
              .thenAnswer((_) async => 'validToken');
          when(mockAuthRepository.getRefreshToken())
              .thenAnswer((_) async => 'validRefreshToken');
          when(mockAuthRepository.checkAuth(any)).thenAnswer((_) async => true);
          // when(mockInternetCubit.stream)
          //     .thenAnswer((_) => Stream.value(InternetConnected()));
          return authBloc;
        },
        act: (bloc) => bloc.add(CheckAuthState()),
        expect: () => [
          isA<AuthLoadingState>(),
          isA<AuthLoggedInState>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoadingState, AuthLoggedoutState] when LogoutEvent is added',
        build: () {
          when(mockAuthRepository.deleteTokens()).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutEvent()),
        expect: () => [
          isA<AuthLoggedoutState>(),
        ],
      );
    },
  );

  group('TaskBloc', () {
    test('initial state is TaskInitial', () {
      expect(taskBloc.state, isA<TaskInitial>());
    });

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoaded] when GetTasksEvent is added and cache is valid',
      build: () {
        when(mockTaskRepository.isCacheValid(any))
            .thenAnswer((_) async => true);
        when(mockTaskRepository.getTasksFromCache(any))
            .thenAnswer((_) async => []);
        when(mockTaskRepository.getTotalPages()).thenAnswer((_) async => 2);
        return taskBloc;
      },
      act: (bloc) => bloc.add(const GetTasksEvent(skip: 0)),
      expect: () => [
        isA<TasksLoaded>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoaded] when GetTasksEvent is added and cache is invalid',
      build: () {
        when(mockTaskRepository.isCacheValid(any))
            .thenAnswer((_) async => false);
        when(mockTaskRepository.getTotalTasksNumber())
            .thenAnswer((_) async => 20);
        when(mockTaskRepository.getTasksFromApi(any))
            .thenAnswer((_) async => []);
        return taskBloc;
      },
      act: (bloc) => bloc.add(const GetTasksEvent(skip: 0)),
      expect: () => [
        isA<TasksLoaded>(),
      ],
    );

    // blocTest<TaskBloc, TaskState>(
    //   'emits [TasksLoading, TaskAdded] when AddTaskEvent is added',
    //   build: () {
    //     when(mockTaskRepository.addTask(any)).thenAnswer((_) async => true);
    //     return taskBloc;
    //   },
    //   act: (bloc) => bloc.add(const AddTaskEvent(task: Task())),
    //   expect: () => [
    //     isA<TasksLoading>(),
    //     isA<TaskAdded>(),
    //   ],
    // );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoading, TaskAdded, TasksLoaded] when task is added successfully',
      build: () {
        // Mock successful task addition
        when(mockTaskRepository.addTask(any)).thenAnswer((_) async => true);
        when(mockTaskRepository.isCacheValid(any))
            .thenAnswer((_) async => true);
        when(mockTaskRepository.getTasksFromCache(any))
            .thenAnswer((_) async => []);
        when(mockTaskRepository.getTotalPages()).thenAnswer((_) async => 2);
        return taskBloc;
      },
      act: (bloc) => bloc.add(AddTaskEvent(task: Task())),
      expect: () => [
        TasksLoading(), // First state is loading
        const TaskAdded(message: 'Task Added Successfully'), // Then success
        isA<TasksLoaded>(), // Followed by loading when the GetTasksEvent is triggered
      ],
      verify: (_) {
        // Verify that the taskRepository's addTask method was called
        verify(mockTaskRepository.addTask(Task())).called(1);
        // Verify that GetTasksEvent was added after the task is added
        // Assuming GetTasksEvent fetches the tasks after adding
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoading, TasksError] when task addition fails',
      build: () {
        // Mock failure to add task
        when(mockTaskRepository.addTask(any)).thenAnswer((_) async => false);
        return taskBloc;
      },
      act: (bloc) => bloc.add(AddTaskEvent(task: Task())),
      expect: () => [
        TasksLoading(), // First state is loading
        const TasksError(message: 'Error Adding Task'), // Then failure
      ],
      verify: (_) {
        // Verify that the taskRepository's addTask method was called
        verify(mockTaskRepository.addTask(Task())).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoading, TasksError] when an exception is thrown',
      build: () {
        // Mock an exception being thrown
        when(mockTaskRepository.addTask(any))
            .thenThrow(Exception('Failed to add task'));
        return taskBloc;
      },
      act: (bloc) => bloc.add(AddTaskEvent(task: Task())),
      expect: () => [
        TasksLoading(), // First state is loading
        const TasksError(message: 'Error Adding Task'), // Then error
      ],
      verify: (_) {
        // Verify that the taskRepository's addTask method was called
        verify(mockTaskRepository.addTask(Task())).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoading, TaskUpdated] when UpdateTaskEvent is added',
      build: () {
        when(mockTaskRepository.updateTask(any)).thenAnswer((_) async => {});
        when(mockTaskRepository.isCacheValid(any))
            .thenAnswer((_) async => true);
        when(mockTaskRepository.getTasksFromCache(any))
            .thenAnswer((_) async => []);
        when(mockTaskRepository.getTotalPages()).thenAnswer((_) async => 2);
        return taskBloc;
      },
      act: (bloc) => bloc.add(const UpdateTaskEvent(task: Task())),
      expect: () => [
        isA<TasksLoading>(),
        isA<TaskUpdated>(),
        isA<TasksLoaded>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoading, TaskDeleted] when DeleteTaskEvent is added',
      build: () {
        when(mockTaskRepository.deleteTask(any)).thenAnswer((_) async => {});
        when(mockTaskRepository.isCacheValid(any))
            .thenAnswer((_) async => true);
        when(mockTaskRepository.getTasksFromCache(any))
            .thenAnswer((_) async => []);
        when(mockTaskRepository.getTotalPages()).thenAnswer((_) async => 2);
        return taskBloc;
      },
      act: (bloc) => bloc.add(const DeleteTaskEvent(taskID: 1)),
      expect: () => [
        isA<TasksLoading>(),
        isA<TaskDeleted>(),
        isA<TasksLoaded>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoaded] when RefreshEvent is added',
      build: () {
        when(mockTaskRepository.clearCache()).thenAnswer((_) async => {});
        when(mockTaskRepository.isCacheValid(any))
            .thenAnswer((_) async => false);
        when(mockTaskRepository.getTotalTasksNumber())
            .thenAnswer((_) async => 20);
        when(mockTaskRepository.getTasksFromApi(any))
            .thenAnswer((_) async => []);
        when(mockInternetCubit.stream)
            .thenAnswer((_) => Stream.value(InternetConnected()));
        return taskBloc;
      },
      act: (bloc) => bloc.add(RefreshEvent()),
      expect: () => [
        isA<TasksLoaded>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'does not emit when internet is disconnected',
      build: () {
        when(mockTaskRepository.isCacheValid(any))
            .thenAnswer((_) async => false);
        when(mockInternetCubit.stream)
            .thenAnswer((_) => Stream.value(InternetDisconnected()));
        taskBloc.isInternetConnected = false;
        return taskBloc;
      },
      act: (bloc) => bloc.add(const GetTasksEvent(skip: 0)),
      expect: () => [],
      verify: (_) {
        verifyNever(mockTaskRepository.getTotalTasksNumber());
        verifyNever(mockTaskRepository.getTasksFromApi(any));
      },
    );
  });

  group('TaskDetailsBloc', () {
    test('initial state is TaskDetailsInitial', () {
      expect(taskDetailsBloc.state, isA<TaskDetailsInitial>());
    });

    blocTest<TaskDetailsBloc, TaskDetailsState>(
      'emits [TaskDetailsLoading, TaskDetailsLoaded] when GetUserInfo is added and internet is connected',
      build: () {
        when(mockInternetCubit.state).thenReturn(InternetConnected());
        when(mockTaskDetailsRepository.getUserInfo(any))
            .thenAnswer((_) async => createSampleUser(id: 1));
        return taskDetailsBloc;
      },
      act: (bloc) => bloc.add(const GetUserInfo(id: 1)),
      expect: () => [
        isA<TaskDetailsLoading>(),
        isA<TaskDetailsLoaded>(),
      ],
    );

    blocTest<TaskDetailsBloc, TaskDetailsState>(
      'emits [TaskDetailsLoading, TaskDetailsError] when GetUserInfo is added and internet is disconnected',
      build: () {
        when(mockInternetCubit.state).thenReturn(InternetDisconnected());
        taskDetailsBloc.isInternetConnected = false;
        return taskDetailsBloc;
      },
      act: (bloc) => bloc.add(const GetUserInfo(id: 1)),
      expect: () => [
        isA<TaskDetailsLoading>(),
        isA<TaskDetailsError>(),
      ],
    );

    blocTest<TaskDetailsBloc, TaskDetailsState>(
      'emits [TaskDetailsLoading, TaskDetailsError] when GetUserInfo is added and repository throws an error',
      build: () {
        when(mockInternetCubit.state).thenReturn(InternetConnected());
        when(mockTaskDetailsRepository.getUserInfo(any))
            .thenThrow(Exception('Test error'));
        return taskDetailsBloc;
      },
      act: (bloc) => bloc.add(const GetUserInfo(id: 1)),
      expect: () => [
        isA<TaskDetailsLoading>(),
        isA<TaskDetailsError>(),
      ],
    );
  });
}
