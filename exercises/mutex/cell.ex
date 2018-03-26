defmodule Cell do
  def new(), do: spawn_link(fn -> cell(:open) end)


  defp cell(state) do
    receive do
      {:swap, value, from} ->
        send(from, {:ok, state})
        cell(value)
      {:set, value, from} ->
        send(from, :ok)
        cell(value)
    end
  end

  def swap(cell, val) do
    send(cell, {:swap, val, self()})
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
    case Cell.swap(lock, :taken) do
      :taken ->
        IO.puts("Lock was taken, trying again")
        do_it(thing, lock)
      :open ->
        thing
        Cell.set(lock, :open)
    end
  end


end


defmodule OldCell do
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
    case OldCell.get(lock) do
      :taken ->
        IO.puts("Lock was taken, trying again")
        do_it(thing, lock)
      :open ->
        thing.(5)
        OldCell.set(lock, :open)
    end
  end



end
