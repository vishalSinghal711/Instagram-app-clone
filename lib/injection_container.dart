import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone_app/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:instagram_clone_app/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:instagram_clone_app/features/data/repository/firebase_repository_impl.dart';
import 'package:instagram_clone_app/features/domain/repository/firebase_repository.dart';

import 'package:instagram_clone_app/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/credentail/credential_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/post/post_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone_app/features/presentation/cubit/user/user_cubit.dart';

import 'features/domain/usecases/firebase_usecases/comment/comment_usecases.dart';
import 'features/domain/usecases/firebase_usecases/post/post_usescases.dart';
import 'features/domain/usecases/firebase_usecases/replay/replay_usecases.dart';
import 'features/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'features/domain/usecases/firebase_usecases/user/user_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
        () => CredentialCubit(
          signUpUseCase: sl.call(),
          signInUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
        () => UserCubit(
          updateUserUseCase: sl.call(),
          getUsersUseCase: sl.call(),
          followUnFollowUseCase: sl.call()
    ),
  );

  sl.registerFactory(
        () => GetSingleUserCubit(
        getSingleUserUseCase: sl.call()
    ),
  );

  sl.registerFactory(
        () => GetSingleOtherUserCubit(
        getSingleOtherUserUseCase: sl.call()
    ),
  );

  // Post Cubit Injection
  sl.registerFactory(
        () => PostCubit(
      createPostUseCase: sl.call(),
          deletePostUseCase: sl.call(),
          likePostUseCase: sl.call(),
          readPostUseCase: sl.call(),
          updatePostUseCase: sl.call()
    ),
  );

  sl.registerFactory(
        () => GetSinglePostCubit(
          readSinglePostUseCase: sl.call()
    ),
  );

  // Comment Cubit Injection
  sl.registerFactory(
        () => CommentCubit(
          createCommentUseCase: sl.call(),
          deleteCommentUseCase: sl.call(),
          likeCommentUseCase: sl.call(),
          readCommentsUseCase: sl.call(),
          updateCommentUseCase: sl.call(),
    ),
  );

  // Replay Cubit Injection
  sl.registerFactory(
        () => ReplayCubit(
          createReplayUseCase: sl.call(),
          deleteReplayUseCase: sl.call(),
          likeReplayUseCase: sl.call(),
          readReplaysUseCase: sl.call(),
          updateReplayUseCase: sl.call()
    ),
  );

  // Use Cases
  // User
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => FollowUnFollowUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleOtherUserUseCase(repository: sl.call()));

  // Cloud Storage
  sl.registerLazySingleton(() => UploadImageToStorageUseCase(repository: sl.call()));


  // Post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));

  // Comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentsUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));

  // Replay
  sl.registerLazySingleton(() => CreateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadReplaysUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplayUseCase(repository: sl.call()));


  // Repository

  sl.registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() => FirebaseRemoteDataSourceImpl(firebaseFirestore: sl.call(), firebaseAuth: sl.call(), firebaseStorage: sl.call()));

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
