defmodule MorphyDbWeb.PageController do
  use MorphyDbWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
