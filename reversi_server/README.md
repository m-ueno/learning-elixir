# ReversiServer

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Sequence diagram (written in mermaid.js)

```mermaid
sequenceDiagram
participant C2 as ObserverClient
participant Client
participant Channel as handler Fns for "game:game_id"
participant Game
participant Supervisor as GameSupervisor
participant Logic as ReversiLogic

Client ->> Channel : join(game_id)
Channel ->> Supervisor : start_child
Supervisor -->> Game : start_child(game_id)
Game ->> Game : GenServer.start_link(game_id)
Supervisor ->> Channel : {:ok, _game_pid}
Channel ->> Client : created

Client ->> Channel : make_step
Channel -->> Game :  (Process.whereis/1で探す)
Channel ->> Game : update_state
Game ->> Channel : new_state
Channel -->> Client : broadcast(update)
Channel ->> Logic : _
Logic ->> Channel : step
Channel ->> Game : update_state
Game ->> Channel : new_state
Channel -->> Client : broadcast(update)

C2 ->> Channel : join
Channel -->> C2 : state
```

### Another way of communication: pub/sub channel internally

See <https://hexdocs.pm/phoenix/Phoenix.Channel.html#module-subscribing-to-external-topics>

```mermaid
sequenceDiagram

  participant Client
  participant Web
  participant Game as GameStatefulServerProc
  participant Worker?

Client -->> Web : join(gid, player_id)
Web -->> Game : init(gid, player_id, channel_pid)
Game -->> Worker? : spawn(channel_pid)
Worker? -->> Game: join

Game -->> Client : broadcast（observerできないのか？？）

Client -->> Web : gid, @step
Web -->> Game : gid, @step
Game -->> Game : check/update
Game -->> Client : broadcast
Game -->> Worker? : broadcast

Worker? -->> Game : @step
Game -->> Game : check/update
Game -->> Client : broadcast
Game -->> Worker? : broadcast
```