import 'package:bloc/bloc.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';

class RemoteServersBloc extends Bloc<RemoteServersEvent, RemoteServersState> {

  final ServersRepository repository;

  RemoteServersBloc()
      : repository = new ServersRepository(),
        super(RemoteServersLoading());


  List<ServerInfo> servers;

  fetch() => add(FetchServersEvent());


  @override
  Stream<RemoteServersState> mapEventToState(RemoteServersEvent event) async* {
    if (event is FetchServersEvent) {
      try {
        servers = await repository.fetchTopics();
        print(servers[1].flag);
      } catch (e) {
        yield RemoteServersError(e.toString());
      }

      yield RemoteServersLoaded(servers);
    }
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

