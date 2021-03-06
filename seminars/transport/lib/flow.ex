defmodule Flow do

  def start(size) do
    {:ok, spawn(fn() -> init(size) end)}
  end

  def init(size) do
    :io.format("flow ~w started ~n", [self()])
    receive do
      {:connect, netw} ->
	:io.format("flow ~w connecting to ~w~n", [self(), netw])
	send(netw, {:send, %Syn{add: size}})
	flow(size, 0, [], netw)
    end
  end
    
  def flow(S, 0, buffer, netw) do
    receive do
      %Syn{add: t} ->
	flow(S, t, buffer, netw)
    end
  end
  def flow(s, t, [], netw) do
    receive do

      {:send, msg, pid} ->
	send(netw, {:send, %Msg{data: msg}})
	send(pid, :ok)
	flow(s, t-1, [], netw)

      %Msg{data: msg} ->
	flow(s-1, t, [msg], netw)

      %Syn{add: a} ->
	flow(s, t+a, [], netw)

    end
  end
  def flow(s, t, buffer, netw) do
    receive do

      {:send, msg, pid} ->
	send(netw, {:send, %Msg{data: msg}})
	send(pid, :ok)
	flow(s, t-1, buffer, netw)

      {:read, n, pid} ->
	{i, deliver, rest} = read(n, buffer)
	send(pid, {:ok, i, deliver})
	send(netw, {:send, %Syn{add: i}})
	flow(s+i, t, rest, netw)

      %Msg{data: msg} ->
	flow(s-1, t, buffer++[msg], netw)

      %Syn{add: a} ->
	flow(s, t+a, buffer, netw)

    end
  end

  def read(n, buffer) do
    l = length(buffer)
    if n <= l do
      {deliver, keep} = Enum.split(buffer, n)
      {n, deliver, keep}
    else
      {l, buffer, []}
    end
  end

end



