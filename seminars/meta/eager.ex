defmodule Eager do

  # EXPRESSION EVALUATION
  def eval_expr({:atm, id}, _), do: {:ok, id}

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil -> :error
      {_, str} -> {:ok, str}
    end
  end

  def eval_expr({:cons, head, tail}, env) do
    case eval_expr(head, env) do
      :error -> :error
      {:ok, id} ->
        case eval_expr(tail, env) do
          :error -> :error
          {:ok, id2} -> {:ok, {:cons, id, id2}}
        end
    end
  end

  # PATTERN MATCHING EVALUATION
  def eval_match(:ignore, _val, env) do
    {:ok, env}
  end

  def eval_match({:atm, _id}, _str, env) do
    {:ok, env}
  end

  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, str, env)}
      {_, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end

  def eval_match({:cons, hp, tp}, {:cons, hs, ts}, env) do
    case eval_match(hp, hs, env) do # check if the head matches
      :fail -> :fail
      {:ok, env2} -> eval_match(tp, ts, env2) # check if the tail matches as well
    end
  end
  def eval_match(_, _, _), do: :fail


  # SEQUENCE EVALUATION
  def eval_seq([expr], env) do
    eval_expr(expr, env)
  end

  def eval_seq([{:match, pattern, expr} | seq], env) do
    case eval_expr(expr, env) do
      :error -> :error
      {_, str} ->
        vars = extract_vars(pattern)
        env = Env.remove(vars, env)

        case eval_match(pattern, str, env) do
          :fail -> {:error, pattern, str, env}
          {:ok, env2} ->
            eval_seq(seq, env2)
        end
    end
  end

  # init function
  def extract_vars(pattern), do: extract_vars(pattern, [])

  def extract_vars({:var, id}, vars), do: [id | vars]
  def extract_vars([{:var, id} | rest], vars) do
    extract_vars(rest, [id | vars])
  end
  def extract_vars([_ | rest], vars) do
    extract_vars(rest, vars)
  end
  def extract_vars(_, vars), do: vars



  # Default evaluation
  def eval(sequence) do
    eval_seq(sequence, [])
  end

  def test() do
    # For testing sequence
    seq =  [{:match, {:var, :x}, {:atm,:a}}, {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}}, {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}}, {:var, :z}]
    eval(seq)
  end


end
