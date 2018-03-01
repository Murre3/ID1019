defmodule Rudy do


  def start(port) do
    Process.register(spawn(fn -> init(port) end), :rudy)
  end

  def stop() do
    Process.exit(Process.whereis(:rudy), "Time to die!")
  end

  def init(port) do
    opt = [:list, active: false, reuseaddr: true]

    case :gen_tcp.listen(port, opt) do
      {:ok, listen} ->
        handler(listen)
        :gen_tcp.close(listen)
        :ok
      {:error, error} ->
          error
    end
  end

def handelrs(0, listen) do
  receive do
    {:DOWN, _ref, :process, _pid, _reason} ->
      spawn_link(fn()-> handler(listen) end)
      handlers(0, listen)
  end
end
def handlers(n, listen) do
  spawn_link(fn() -> handler(listen) end)
  handlers(n-1, listen)
end


  def handler(listen) do
    case :gen_tcp.accept(listen) do
      {:ok, client} ->
        spawn(fn() ->
        request(client)
        :gen_tcp.close(client)
        end)
      {:error, error} ->
          error
    end
    handler(listen)
  end


  def request(client) do
    recv = :gen_tcp.recv(client, 0)
    case recv do
      {:ok, str} ->
        req = HTTP.parse_request(str)
        response = reply(req)
        :gen_tcp.send(client, response)
      {:error, error} ->
        IO.puts("RUDY ERROR: #{error}")
    end
    :gen_tcp.close(client)
  end

  def reply({{:get, uri, _}, _, _}) do
    :timer.sleep(10) # artificial file handling delay
    HTTP.ok("Hello");
  end

end
