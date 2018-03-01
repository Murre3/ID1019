defmodule Lists do


  #NTH
  def nth(_, []) do :outofbounds end
  def nth(0, l) do hd l end
  def nth(n,l) do
    nth(n-1, tl l)
  end

  #LEN
  def len([]) do 0 end
  def len(l) do
    len(1, tl l)
  end
  defp len(n, []) do n end
  defp len(n, l) do
    len(n+1, tl l)
  end

  #SUM
  def sum([]) do 0 end #edge case
  def sum(l) do
    sum((tl l), hd l)
  end
  defp sum([], n) do n end #recursive helper
  defp sum(l, n) do
    sum((tl l), n+hd l)
  end

  #DUPLICATE
  def duplicate([]) do [] end
  def duplicate(l) do
      [(hd l), (hd l) | duplicate(tl l)]
  end


  #ADD
  def add(x, []) do [x] end
  def add(x, l) do
    if((hd l) == x) do
      l
    else
      [(hd l) | add(x, (tl l))]
    end
  end

  #REMOVE
  def remove(_, []), do: []
  def remove(x, l) when (hd l) == x do
    remove(x, (tl l))
  end
  def remove(x, l) do
    [(hd l) | remove(x, (tl l))]
  end


  #UNIQUE
  def unique(l) do
    unique((tl l), [hd l])
  end
  defp unique([], u) do u end
  defp unique(l, u) do
    u = add((hd l), u)
    unique((tl l), u)
  end


  #INSERT - helper function for pack
  defp addDupe(e, []), do: [[e]]
  defp addDupe(e, [[e | _] = head|tail]), do: [[e|head] | tail]
  defp addDupe(e, [head | tail]), do: [head | addDupe(e, tail)]



  #PACK
  def pack([]), do: []
  def pack([h|t]) do
    addDupe(h, pack(t))
  end

  #REVERSE
  def reverse(l) do
    reverse((tl l), [hd l])
  end
  defp reverse([], r) do r end
  defp reverse(l, r) do
    reverse((tl l), [(hd l) | r])
  end


end#defmodule
