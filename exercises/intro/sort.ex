defmodule Sort do

  #INSERT - helper function for insertion sort
  defp insert(element, []), do: [element]
  defp insert(element, [h | t]) when element <= h do
    [element, h | t]
  end
  defp insert(element, [h | t]) do
    [h | insert(element, t)]
  end

  #INSERTION SORT
  def isort(l), do: isort(l, [])
  def isort([], sorted), do: sorted
  def isort([hdl | tll], sorted) do
    isort(tll, insert(hdl, sorted))
  end



  #MERGE SORT
  def msort([]), do: []
  def msort([h]), do: [h]
  def msort(l) do
    {first, second} = msplit(l)
    merge(msort(first), msort(second))
  end
  defp merge(f,[]), do: f
  defp merge([], s), do: s
  defp merge([fh | ft] = f, [sh | st] = s) do
    case sh <= fh do
    true -> [sh | merge(f, st)]
    false -> [fh | merge(ft, s)]
    end
  end

  defp msplit(l), do: msplit(l, [], [])
  defp msplit([], f, s) do
    {f, s}
  end
  defp msplit([h], f, s) do # case when only 1 element is left (odd len)
    {[h | f], s}
  end
  defp msplit([h | t], f, s) do
    msplit((tl t), [h | f], [(hd t) | s])
  end


  #QUICKSORT
  def qsort([h | []]), do: [h]
  def qsort([piv | t]) do
    {less, grtr} = qsplit(piv, t, [], [])
    qsort(less) ++ qsort(grtr)
  end

  defp qsplit(piv, [], [], grtr), do: {[piv], grtr}
  defp qsplit(piv, [], less, []), do: {less, [piv]}
  defp qsplit(piv, [], less, grtr), do: {less, [piv|grtr]}
  defp qsplit(piv, [h|t]=_unsort, less, grtr) do
    case h <= piv do
      true -> qsplit(piv, t, [h|less], grtr)
      false -> qsplit(piv, t, less, [h|grtr])
    end
  end


end
