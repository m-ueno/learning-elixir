#!env ruby

# Usage
#
#   ruby ring.rb 2> /dev/null
#

require 'thread'

class Actor
  attr_accessor :actor_id, :neighbor, :msg_box, :thread

  def initialize(id)
    @actor_id = id
    @msg_box = Queue.new
  end

  def inspect
    "#<Actor:@id=#{@actor_id}, @neighbor=#{@neighbor.actor_id}>"
  end

  def forward_message(msg)
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
      while (msg = @msg_box.pop)
        case msg
        when Struct::SetNeighbor
          @neighbor = msg.neighbor
        when Struct::Message
          forward_message(msg)
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

def make_ring(n)
  actors = (0..n).map { |i| Actor.new(i) }
  neighbors = [actors.last] + actors[0, actors.size - 1]

  actors.zip(neighbors).each { |actor, neighbor| actor.neighbor = neighbor }

  threads = actors.zip(neighbors).map { |actor, _n| actor.start }

  warn threads

  actors
end

def bench_n_m(n, m)
  ring = make_ring(n)

  Struct.new('SetNeighbor', :neighbor)
  message = Struct.new('Message', :msg, :count)

  t1 = Time.now
  ring.first.receive(message.new('hey', m))
  ring.first.thread.join
  t2 = Time.now

  elapsed = t2 - t1
  [n, m, elapsed.round(4)]
end

def bench
  puts 'n,m,seconds'
  (0..3).each do |i|
    (0..3).each do |j|
      n = 10**i
      m = 10**j
      puts [bench_n_m(n, m)].join(',')
    end
  end
end

def main
  bench
end

main
