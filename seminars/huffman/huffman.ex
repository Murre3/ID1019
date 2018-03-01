defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog this is a sample text that we will use when we build up a table we will only handle lower case letters and no punctuation symbols the frequency will of course not represent english but it is probably not that far off'
  end
  def text, do: 'this is something that we should encode'
  def test do
    sample = read("rsrcs/kallocain.txt", :all) # works - run with
                                               # List.to_string(Huffman.test)
    #sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = sample
    seq = encode(text, encode)
    decode_init(seq, decode)
  end

  defp freq(_sample = [h|t]) do
    freq(t, %{h => 1})
  end

  defp freq([], fmap) do
    # argument of keysort means the value at index 1 to sort by
    Map.to_list(fmap) |> List.keysort(1)
  end
  defp freq([char | rest], fmap) do
    case cf = Map.get(fmap, char) do
      nil -> freq(rest, Map.put(fmap, char, 1)) # not in map yet
      _   -> freq(rest, Map.put(fmap, char, cf+1)) # found in map
    end
  end


  #Construct the Huffman Tree
  def tree(sample) do
    freq(sample) |> buildtree()
  end

  defp buildtree([node|[]]) do
    [node]
  end
  defp buildtree([_mainLeaf = {mK, mFr}  | [_nextLeaf = {nK, nFr}  |t]]) do
    [{{mK, nK}, mFr+nFr} | t] |> List.keysort(1) |> buildtree()
  end


  # Create a table for encoding

  # init - makes sure the total length of the text (stored in the outermost
  # tuple) is not sent into the encoding table
  def encode_table([{node, _len} = _tree |_]), do: encode_table(%{}, node, [])

  # clause cases
  # a tuple
  defp encode_table(map, {left, right}, path) do
    encode_table(map, left, path++[0]) |> encode_table(right, path++[1])
  end
  # a leaf (char value)
  defp encode_table(map, leaf, path) do
    Map.put(map, leaf, path)
  end

  # Create a table for decoding (encoding inverse)

  # init
  def decode_table([{node, _len} = _tree | _]), do: decode_table(%{}, node, [])
  # a tuple
  def decode_table(map, {left, right}, path) do
    decode_table(map, left, path++[0]) |> decode_table(right, path++[1])
  end
  # a leaf (char value)
  def decode_table(map, leaf, path) do
    Map.put(map, path, leaf)
  end


  # Encode using the table

  # init
  def encode(text, table), do: encode(text, table, [])
  # base case, text is empty
  def encode([], _, encoded), do: encoded
  # recursion clause
  def encode([h|r], table, encoded) do
    encode(r, table, Map.get(table, h)++encoded)
  end

  # Decode using the table, table is a list
  # base case, the sequence is decoded
  def decode_init(seq, table) do
    Enum.reverse(decode(seq, table))
  end
  def decode([], _), do: []
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char|decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    #debug
    {code, rest} = Enum.split(seq, n) # get first n elements of enumerable seq
    #debug 2
    case Map.get(table, code) do
      nil -> decode_char(seq, n+1, table)
      char -> {char, rest}
    end
  end

  # read in file to process
  def read(file, n) do
    {:ok, file} = File.open(file, [:read])
    binary = IO.read(file, n)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list;
      list -> list
    end
  end




end
