defmodule Mutex do
  # Peterson's algorithm

  @type state() :: boolean() | id()
  @type id() :: 1..2


  def test do
    c1 = spawn_link(fn -> cell(false) end)
    c2 = spawn_link(fn -> cell(false) end)
    q = spawn_link(fn -> cell(0) end)

    p1 = spawn(fn -> lock(0, c1, c2, q, self()) end)
    p2 = spawn(fn -> lock(1, c2, c1, q, self()) end)
    # Gets stuck on p2's lock
    wait(p1, p2, q)
  end
  def wait(p1, p2, q) do
    receive do
      {0, :done} ->
        unlock(0, p1, p2, q, self())
        wait(p1, p2, q)
      {1, :done} ->
        unlock(1, p2, p1, q, self())
        wait(p1,p2, q)

      _ -> wait(p1, p2, q)
    end
  end

  def lock(id, m, p, q, from) do
    IO.puts("Process #{id} set itself to true")
    Mutex.set(m, true)
    other = rem(id+1, 2)
    IO.puts("Process #{id} set the control process to prioritize the other")
    Mutex.set(q, other)
    IO.puts("Checking other process in process: #{id}")
    case get(p) do
      :false ->
        send(from, {id, :done})
        :locked
      :true ->
        IO.puts("Checking the control process in process: #{id}")
        case Mutex.get(q) do
          ^id ->
            send(from, {id, :done})
            :locked
          ^other ->
            lock(id, m, p, q, from)
        end
    end
  end

  def unlock(_id, m, _p, _q, _from) do
    Mutex.set(m, false)
  end


  defp cell(state) do
    receive do
      {:get, from} ->
        send(from, {:ok, state})
        cell(state)
      {:set, value, from} ->
        send(from, :ok)
        cell(value)
    end
  end

  def get(cell) do
    send(cell, {:get, self()})
    receive do
      {:ok, value} -> value
    end
  end

  def set(cell, val) do
    send(cell, {:set, val, self()})
    receive do
      :ok -> :ok
    end
  end

  def do_it(thing, lock) do
    case Mutex.get(lock) do
      :taken ->
        IO.puts("Lock was taken, trying again")
        do_it(thing, lock)
      :open ->
        thing.(5)
        Mutex.set(lock, :open)
    end
  end


end
