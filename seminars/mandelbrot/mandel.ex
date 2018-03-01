defmodule Mandel do
  require Brot;

  def demo() do
    small(-0.254, -0.1323, -0.1240)
  end
  def small(x0, y0, xn) do
    width = 960
    height = 540
    depth = 80
    k = (xn - x0) /width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("out/#{to_string(:erlang.system_time())}", image)
  end

  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end

    rows(width, height, trans, depth, [])
  end

  def rows(_w, 0, _trans, _depth, rows), do: rows
  def rows(w, h, trans, depth, rows) do
    row = cells(w, h, trans, depth, [])
    rows(w, h-1, trans, depth, [row | rows])
  end

  def cells(0, _h, _trans, _depth, cells), do: cells
  def cells(w, h, trans, depth, cells) do
    z = trans.(w,h)
    d = Brot.mandelbrot(z, depth)
    color = Color.convert(d, depth)
    cells(w-1, h, trans, depth, [color | cells])
  end
end
