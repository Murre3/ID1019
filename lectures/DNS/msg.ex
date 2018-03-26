defmodule MSG do


  def decode(<<id::16, flag::16, qdc::16, anc::16, nsc::16, arc::16, body::binary >>) do
    {id, flag, qdc, anc, nsc, arc, body}
  end
  def _decode(<<id::16, flag::16, qdc::16, anc::16, nsc::16, arc::16, body::binary >>) do
    <<qr::1, op::4, aa::1, tc::1, rd::1, ra::1, _::3, resp::4>> = flag
  end

  def decode_body(qdc, anc, nsc, arc, body, raw) do
    {query, rest} = decode_query(qdc, body, raw)
    {answer, rest} = decode_answer(anc, rest, raw)
    {authority, rest} = decode_answer(nsc, rest, raw)
    {additional, _} = decode_answer(arc, rest, raw)
    {query, answer, authority, additional}
  end
  def decode_query(_type, _body, _raw) do
    :ok
  end
  def decode_answer(_type, _rest, _raw) do
    :ok
  end

  def decode_name(label, raw) do

  end

end
