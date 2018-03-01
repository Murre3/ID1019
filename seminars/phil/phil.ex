defmodule Philosopher do

  @dream    20
  @eat      20
  @timeout  5000

  def start(hunger, strength, right, left, name, ctrl, seed) do
    _phil = spawn_link(fn -> wait(hunger, strength, right, left, name, ctrl, seed) end)
  end

  def eat(hunger, strength, ref, right, left, name, ctrl, seed) do
    IO.puts("#{name} started eating...")
    sleep(@eat*seed)
    IO.puts("#{name} finished eating, her hunger is now #{hunger-1}")
    Chopstick.return(left, ref)
    IO.puts("#{name} put down her left chopstick")
    Chopstick.return(right, ref)
    IO.puts("#{name} put down her right chopstick")
    dream(hunger-1, strength, right, left, name, ctrl, seed)
  end



  def wait(hunger, strength, right, left, name, ctrl, seed) do
    case Chopstick.request(left, @timeout) do
      :no -> IO.puts("#{name} got a timeout, returning left")
             Chopstick.return(left)
             dream(hunger, strength-1, right, left, name, ctrl, seed)
      :granted -> IO.puts("#{name} picked up her left chopstick");
                  case Chopstick.request(right, @timeout) do
                    :no -> IO.puts("#{name} got a timeout, returning left and right")
                           Chopstick.return(left)
                           Chopstick.return(right)
                           IO.puts("#{name} put down her left chopstick")
                           dream(hunger, strength-1, right, left, name, ctrl, seed)
                    :granted -> IO.puts("#{name} picked up her right chopstick")
                                eat(hunger, strength, right, left, name, ctrl, seed)
                  end
    end

  end

  def dream(0, _strength, _right, _left, name, ctrl, _seed) do
    IO.puts("#{name} finished eating.")
    send(ctrl, :done)
  end
  def dream(hunger, 0, _right, _left, name, ctrl, _seed) do
    IO.puts("#{name} starved to death with #{hunger} remaining hunger")
    send(ctrl, :done)
  end
  def dream(hunger, strength, right, left, name, ctrl, seed) do
    IO.puts("#{name} is dreaming..")
    sleep(@dream*seed)
    IO.puts("#{name} woke up and is now waiting to eat")
    wait(hunger, strength, right, left, name, ctrl, seed)
  end


  def sleep(0), do: :ok
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end
end
