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
# participant C2 as ObserverClient
participant Client
participant Channel as GameChannel
participant Game
participant Supervisor as GameSupervisor
participant Logic as ReversiLogic

Client ->> +Channel : join(game_id)
Channel ->> Supervisor : start_child
Supervisor ->> +Game : start_child(game_id)
Game ->> Game : GenServer.start_link(game_id)
Game ->> Supervisor : {:ok, pid}
Supervisor ->> Channel : {:ok, child}
Channel -->> Game : Process.monitor(game_pid)
Channel ->> Client : joined

loop until game over
  Client ->> Channel : add_step(game_id)

  # turn 1
  Channel ->> Game : add_step(game_id)
  Game ->> Game : GenServer.whereis/1
  Game ->> Game : add_step
  Game ->> Channel : new_state
  Channel -->> Client : "state_updated" (broadcast)

  # turn 2
  Channel ->> Logic : Playable.make_step(...)
  Logic ->> Channel : step
  Channel ->> Game : add_step
  Game ->> -Channel : new_state
  Channel -->> -Client : "state_updated" (broadcast)
end
```