defmodule DNS do

  @server {8,8,8,8}
  @port 53
  @local 5300

  def start() do
    start(@local, @server, @port)
  end

  def start(local, server, port) do
    spawn(fn() -> init(local, server, port) end)
  end

  def init(local, server, port) do
    case :gen_udp.open(local, [{:active, true}, :binary]) do
      {:ok, local} ->
        case :gen_udp.open(0, [{:active, true}, :binary]) do
          {:ok, remote} ->
            dns(local, remote, server, port)
            error ->
              :io.format("DNS error opening remote socket: ~w~n", [error])
        end
        error ->
          :io.format("DNS error opening local socket: ~w~n", [error])
    end
  end

  def dns(local, remote, server, server_port) do
    receive do
      {:udp, ^local, client, client_port, query} ->
        :io.format("request from ~w ~w ~n", [client, client_port])
        decoded = MSG.decode(query)
        :io.format("decoded: ~w ~n", [decoded])
        :gen_udp.send(remote, server, server_port, query)
        dns(local, remote, server, server_port)

      {:udp, ^remote, server, server_port, reply} ->
        :io.format("reply from: ~w ~w ~n", [server, server_port])
        decoded = MSG.decode(reply)
        :io.format("Reply from ext server decoded: ~w ~n", [decoded])
        dns(local, remote, server, server_port)
      :update ->
        DNS.dns(local, remote, server, server_port)
      :quit ->
        :ok
      strange ->
        :io.format("strange message ~w~n", [strange])
        dns(local, remote, server, server_port)
    end
  end


end
