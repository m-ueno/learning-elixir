#!env ruby

# Usage
#
#   ruby ring.rb 2> /dev/null
#

require 'benchmark'
require 'json'
require 'thread'
require 'pp'

class Actor
  attr_accessor :actor_id, :neighbor, :msg_box, :thread

  def initialize(id)
    @actor_id = id
    @msg_box = Queue.new
  end

  def inspect
    "#<Actor:@id=#{@actor_id}, @neighbor=#{@neighbor.actor_id}>"
  end

  def proxy_message(msg)
    if @actor_id == 0
      # master node
      warn "0(master): #{msg}"
      if msg.count == 0
        # Process.kill('USR1', 0)   # current process group
        stop
      else
        msg.count -= 1
        @neighbor.receive(msg)
      end
    else
      # child node
      warn "#{@actor_id}: received msg"
      warn "#{@actor_id}: sending to #{@neighbor.inspect}"
      @neighbor.receive(msg)
    end
  end

  def start
    @thread = Thread.start do
      while msg = @msg_box.pop
        case msg
        when Struct::SetNeighbor
          @neighbor = msg.neighbor
        when Struct::Message
          proxy_message(msg)
        else
          raise "unhandled msg #{msg}"
        end
      end
    end
  end

  def stop
    warn "#{@actor_id}: stop"
    @thread && @thread.terminate
  end

  def receive(msg)
    @msg_box.push(msg)
  end
end

def snd(receiver, msg)
  receiver.receive msg
end

def make_ring(n, _m)
  actors = (0..n).map { |n| Actor.new(n) }
  neighbors = [actors.last] + actors[0, actors.size - 1]

  actors.zip(neighbors).each { |actor, n| actor.neighbor = n }

  _threads = actors.zip(neighbors).map { |actor, _n| actor.start }

  warn _threads
  actors
end

def bench_n_m(n, m)
  memo = {}
  memo_file = 'ring_cache'
  File.exist?(memo_file) && open(memo_file) { |f| memo = Marshal.load(f.read) }
  return memo[[n, m]] if memo[[n, m]]

  ring = make_ring(n, m)

  set_neighbor = Struct.new('SetNeighbor', :neighbor)
  message = Struct.new('Message', :msg, :count)

  t1 = Time.now
  ring.first.receive(message.new('hey', m))
  # ring.map {|actor| actor.thread.join}  # dead lock here?
  ring.first.thread.join
  t2 = Time.now

  elapsed = t2 - t1
  memo[[n, m]] = elapsed
  open('ring_cache', 'w') { |f| f.write Marshal.dump(memo) }
  elapsed
end

def bench
  (1..4).each do |i|
    (1..4).each do |j|
      n = 10**i
      m = 10**j
      puts [n, m, bench_n_m(n, m)].to_json
    end
  end
end

def main
  bench
end

main
