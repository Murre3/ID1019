defmodule Brot do
  require Cmplx;

  def mandelbrot(c, m) do
    z0 = Cmplx.new(0, 0)
    i = 0;
    test(i, z0, c, m)
  end


  def test(_i = m, _z, _c, m), do: 0
  def test(i, z, c, m) do
    z2 = Cmplx.sqr(z)
    case Cmplx.abs(z) > 2 do
      true -> i
      false -> test(i+1, Cmplx.add(z2, c), c, m)
    end
  end


end
