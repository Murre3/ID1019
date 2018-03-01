defmodule RemoveWeb.PageController do
  use RemoveWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
