defmodule Cmplx do
  @type z :: {re, im}
  @type re :: float
  @type im :: float

  def new(re, im) do
    {re, im}
  end

  def add(_a = {r1, i1}, _b = {r2, i2}) do
    {r1+r2, i1+i2}
  end

  def sqr(_a = {r, i}) do
    {r*r-i*i, 2*r*i}
  end

  def abs(_a = {r, i}) do
    c = (r*r+i*i)
    :math.sqrt(c);
  end

end
