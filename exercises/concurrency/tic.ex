defmodule Tic do

  def first do
    receive do
      {:tic, x} -> IO.inspect(x)
      second()
    end
  end

  defp second do
    receive do
      {:tac, x} ->
        IO.inspect(x)
        last()
      {:toe, x} ->
          IO.inspect(x)
          last()
    end
  end

  defp last do
    receive do
      x ->
        IO.inspect(x)
    end
  end

end
