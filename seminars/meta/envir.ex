defmodule Env do

  def new() do
    []
  end


  def add(id, str, []), do: [{id, str}]
  def add(id, str, _env = [h|t]) do
    [h | add(id, str, t)]
  end


  def lookup(_id, []), do: nil
  def lookup(id, _env = [_h = {key, val} | t]) do
    case id === key do
      true -> {id, val}
      false -> lookup(id, t)
    end
  end

  def remove([], env), do: env
  def remove([id|ids], env) do
    case lookup(id, env) do
      nil -> remove(ids, env)
      {_k, _v} -> remove(ids, remove_all(id, env))
    end
  end
  def remove(id, env), do: remove([id], env) # when remove is called without list

  def remove_all(_id, []), do: []
  def remove_all(id, _env = [h = {key, _val} | t]) do
    case id === key do
      true -> remove_all(id, t)
      false -> [h | remove_all(id, t)]
    end
  end

end
