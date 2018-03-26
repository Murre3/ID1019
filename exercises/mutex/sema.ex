defmodule Semaphore do

  @n 5

  def test() do
    sem = spawn_link(fn -> semaphore(@n, []))

    
  end

  def semaphore(0) do
    receive do
      :release ->
        semaphore(1)
    end
  end

  def semaphore(n) do
    receive do
      {:request, from} ->
        send(from, :granted)
        semaphore(n-1)
      :release ->
        semaphore(n+1)
    end
  end

  def semaphore(n, waitlist) do
    case n do
      0 ->
        receive do
          :release ->
            semaphore(1, waitlist)
          {:request, from} ->
            semaphore(0, waitlist++[from])
        end
      _ ->
       case waitlist do
         [] ->
            receive do
              :release ->
                semaphore(n+1, waitlist)
              {:request, from} ->
                send(from, :granted)
                semaphore(n)
            end
         [p1 | t] ->
           send(p1, :granted)
           semaphore(n-1, t)
       end
    end
  end

  def request(semaphore) do
    send(semaphore, {:request, self()})
    receive do
      :granted ->
        IO.puts("Access granted to semaphore by ")
        IO.inspect(self())
        :ok
    end
  end



  def monitor(state) do
    receive do
      {:request, from} ->
        updated = critical(state)
        send(from, :ok)
        monitor(updated)
    end
  end

  def critical(state) do
    # do some critical stuff
    {:state, state, 5*5*5*5*5*5*5}
  end
end
