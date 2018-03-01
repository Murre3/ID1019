defmodule Color do

  @type rgb :: {:rgb, red, green, blue}
  @type red :: 0..255
  @type green :: 0..255
  @type blue :: 0..255

  def convert(depth, max) do
    f = depth/max
    a = f*4
    x = trunc(a)
    y = trunc(255*(a-x))
    lookup(x, y)
  end

  def lookup(x, y) do
    case x do
      0 -> {:rgb, 25, 5, 20}        # background color
      1 -> {:rgb, 60, 10, y}
      2 -> {:rgb, 120, 30, 255-y}
      3 -> {:rgb, 110, 40, y}
      4 -> {:rgb, 60, 0, 180}        # details
      _ -> :error
    end
  end

end
