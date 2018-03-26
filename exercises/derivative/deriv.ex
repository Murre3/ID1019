defmodule Deriv do

  @type literal() ::  {:const, number()}
                    | {:const, atom()}
                    | {:var, atom()}

  @type expression() :: {:add, expression(), expression()}
                      | {:sub, expression(), expression()}
                      | {:mul, expression(), expression()}
                      | {:exp, base(), exp()}
                      | literal()

  @type base() :: expression()
  @type exp()  :: expression()

  # Completely untested and incomplete code, very bad idea

  def deriv({:const, _}, _), do: {:const, 0}

  def deriv({:var, v}, v), do: {:const, 1}

  def deriv({:var, _y}, _), do: {:const, 0}

  def deriv({:mul, e1, e2}, v), do: {:add, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}}

  def deriv({:add, e1, e2}, v), do: {:add, deriv(e1, v), deriv(e2, v)}

  def deriv({:sub, e1, e2}, v), do: {:sub, deriv(e1, v), deriv(e2, v)}

  def deriv({:exp, {:const, _}, {:var, _}}, _v), do: {:error, :toohard} # requires log-handling
  def deriv({:exp, {:const, _}, {:const, _}}, _v), do: {:const, 0}
  def deriv({:exp, {:var, v}, {:var, v}}, v), do: {:error, :whywouldyoudothis}
  def deriv({:exp, e1, {:const, c}}, v) do
    {:mul, {:const, c}, {:mul, deriv(e1, v), {:exp, e1, {:sub, {:const, c}, {:const, 1}}}}}
  end
  def deriv({:exp, {:var, _v}, _, _}), do: {:const, 0}



  def simplify({:mul, e1, e2}) do
    case simplify(e1) do
      {:const, 0} ->
        {:const, 0}
      {:const, 1} ->
          simplify(e2)
      {:var, v} ->
          case simplify(e2) do
            {:const, 0} ->
              {:const, 0}
            {:const, 1} ->
              {:var, v}
            {:var, ^v} ->
              {:exp, {:var, v}, {:const, 2}}
          end
      sim1 ->
        case simplify(e2) do
          {:const, 0} ->
            {:const, 0}
          {:const, 1} ->
            sim1
          sim2 ->
              {:mul, sim1, sim2} # no outer simplification made
        end
    end
  end

  def simplify({:add, e1, e2}) do
    case simplify(e1) do
      {:const, 0} -> simplify(e2)
      {:const, c} when is_number(c) ->
        case simplify(e2) do
          {:const, c2} when is_number(c2) ->
            {:const, c+c2} # 2 numbers that can be added, c2 0-case covered
          sim2 -> {:add, {:const, c}, sim2}
        end
      sim1 -> case simplify(e2) do
        {:const, 0} -> sim1
        sim2 -> {:add, sim1, sim2}
        end
    end
  end

  def simplify({:exp, e1, e2}) do
    case simplify(e1) do
      {:const, 0} ->
        {:const, 0}
      {:const, 1} ->
          {:const, 1}
      sim1 -> case simplify(e2) do
        {:const, 0} ->
          {:const, 1}
        {:const, 1} ->
          sim1
        sim2 ->
            {:exp, sim1, sim2}
      end
    end
  end




end
