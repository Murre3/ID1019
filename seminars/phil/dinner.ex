defmodule Dinner do

  def start(), do: spawn(fn -> init(5, 10) end)


  def init(hunger, seed) do
    start = :erlang.monotonic_time(:millisecond)
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    IO.puts("Chopsticks are on the table!")
    ctrl = self()
    Philosopher.start(hunger, 5, c1, c2, "Arendt", ctrl, seed+1)
    Philosopher.start(hunger, 5, c2, c3, "Hypatia", ctrl, seed+2)
    Philosopher.start(hunger, 5, c3, c4, "Simone", ctrl, seed+3)
    Philosopher.start(hunger, 5, c4, c5, "Elisabeth", ctrl, seed+4)
    Philosopher.start(hunger, 5, c5, c1, "Ayn", ctrl, seed+5)
    IO.puts("Dinner started, all five philosophers seated.")
    wait(5, start, [c1,c2,c3,c4,c5])
  end


  def wait(0, start, chopsticks) do
    stop = :erlang.monotonic_time(:millisecond)
    IO.puts("Dinner concluded in #{stop-start} milliseconds, terminating")
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end
  def wait(n, start, chopsticks) do
    receive do
      :done ->
        IO.puts(":done received, n decremented to #{n-1}")
        wait(n - 1, start, chopsticks)
      :abort ->
        IO.puts("abort sent, terminating process")
        Process.exit(self(), :kill)
    end
  end

end
