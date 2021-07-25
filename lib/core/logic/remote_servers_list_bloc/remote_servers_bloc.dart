import 'package:bloc/bloc.dart';
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
      yield RemoteServersLoaded(servers);
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
