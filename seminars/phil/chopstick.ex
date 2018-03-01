defmodule Chopstick do

  def start() do
    _stick = spawn_link(fn -> available() end)
  end


  defp available() do
    receive do
      {:request, from} -> send(from, :ok); gone()
      :quit -> :terminated
    end
  end

  defp gone(ref) do
    receive do
      {:return, ^ref} -> send(ref, :returned); available()
      :quit -> :terminated
    end
  end

  # Improved version
  def request(stick, ref, timeout) do
    send(stick, {:request, ref, self()})
    wait(ref, timeout)
  end

  def wait(ref, timeout) do
    receive do
      {:ok, ^ref} ->
        :granted
        {:ok, _} ->
          wait(ref, timeout)
        after timeout
          :no
    end
  end

  def return(stick, ref) do
    send(stick, {:return, ref})
  end

  def quit(stick) do
    Process.exit(stick, :kill)
  end


  # Old versions - synchronous
  def request(stick, timeout) do
    send(stick, {:request, self()})

    receive do
      :ok ->
        :granted
      after timeout ->
        :no
    end
  end
  def return(stick) do
    send(stick, :return)
  end

end
