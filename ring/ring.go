package main

import (
	"fmt"
	"math"
	"time"
)

type Message struct {
	msg   string
	count int
}

type Actor struct {
	id       int
	mailBox  chan Message
	neighbor *Actor
	toMain   chan Message
}

func NewActor(id int) *Actor {
	a := new(Actor)
	a.id = id
	a.mailBox = make(chan Message)
	return a
}

func (actor *Actor) ProcessMessage(msg Message) {
	if actor.id == 0 {   // master node
		msg.count -= 1
		if msg.count <= 0 {
			actor.Stop()
		}
	}

	send(actor.neighbor, msg)
}

func (actor *Actor) Stop() {
	// something
	actor.toMain <- Message{"done", -1}
}

func (actor *Actor) Loop() {
	for {
		msg := <-actor.mailBox
		actor.ProcessMessage(msg)
	}
}

func (actor *Actor) SetNeighbor(neighbor *Actor) {
	actor.neighbor = neighbor
}

func send(actor *Actor, msg Message) {
	actor.mailBox <- msg
}

func makeRing(n int) []*Actor {
	actors := make([]*Actor, n)
	for i := 0; i < n; i++ {
		actors[i] = NewActor(i)
	}

	neighbors := append([]*Actor(nil), actors...)
	neighbors = append(neighbors, neighbors[0])
	neighbors = neighbors[1:]

	for i := 0; i < n; i++ {
		actors[i].SetNeighbor(neighbors[i])
		go actors[i].Loop()
	}

	return actors
}

func benchNM(n int, m int, timeout time.Duration) {
	ring := makeRing(n)
	head := ring[0]
	head.toMain = make(chan Message)

	msg := new(Message)
	msg.count = m
	msg.msg = "hey"

	var reason string
	start := time.Now()
	send(head, *msg)
	select {
	case <-head.toMain:
		reason = "succeeded"
	case <-time.After(timeout):
		reason = "timeout"
	}
	elapsed := time.Since(start)
	fmt.Printf("%d,%d,%.4f,%s\n", n, m, elapsed.Seconds(), reason)
}

func main() {
	var n, m int
	timeout := time.Second * 3 * 60

	fmt.Println("n,m,elapsed(s),reason")

	for i := 1; i < 6; i++ {
		for j := 1; j < 6; j++ {
			n = int(math.Pow10(i))
			m = int(math.Pow10(j))
			benchNM(n, m, timeout)
		}
	}
}
