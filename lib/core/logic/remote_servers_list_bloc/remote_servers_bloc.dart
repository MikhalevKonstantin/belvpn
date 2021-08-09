import 'package:bloc/bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';

class RemoteServersBloc extends Bloc<RemoteServersEvent, RemoteServersState> {
  final ServersRepository repository;

  RemoteServersBloc()
      : repository = new ServersRepository(),
        super(RemoteServersLoading());

  List<ServerInfo> servers = [];

  fetch() => add(FetchServersEvent());

  @override
  Stream<RemoteServersState> mapEventToState(RemoteServersEvent event) async* {
    if (event is FetchServersEvent) {
      try {
        servers = await repository.fetchTopics();
      } catch (e) {
        print(e.toString());
        yield RemoteServersError(e.toString());
      }

      if (servers.length > 0) {
        servers = [
          _createAuto(
            servers[0],
          ),
          ...servers,
        ];
      }

      await _precachingMethodParallel(servers);

      yield RemoteServersLoaded(servers);
    }
  }

  precache(List<ServerInfo> servers) {
    // precache icons
    // await  DefaultCacheManager().emptyCache();
    // final start = DateTime.now();
    _precachingMethodParallel(servers);
    // final end = DateTime.now();
    // final delta = end.microsecondsSinceEpoch - start.microsecondsSinceEpoch;
    // print(' preloading images took : $delta');
  }

  Future _precachingMethodParallel(List<ServerInfo> servers) => Future.wait(
        [
          ...servers
              .map((server) => DefaultCacheManager().getSingleFile(server.flag))
        ],
      );

  Future _precachingMethodSequential(List<ServerInfo> servers) async {
    for (final ServerInfo server in servers) {
      await DefaultCacheManager().getSingleFile(server.flag);
    }
  }

  _createAuto(ServerInfo server) {
    return ServerInfo(
      country: server.country + ' (Auto)',
      config: server.config,
      flag: server.flag,
      ip: server.ip,
    );
  }
}

abstract class RemoteServersEvent {}

class FetchServersEvent extends RemoteServersEvent {}

abstract class RemoteServersState {
  RemoteServersState();
}

class RemoteServersLoading extends RemoteServersState {
  RemoteServersLoading();
}

class RemoteServersLoaded extends RemoteServersState {
  final List<ServerInfo> servers;

  RemoteServersLoaded(this.servers);
}

class RemoteServersError extends RemoteServersState {
  final message;

  RemoteServersError(this.message);
}
