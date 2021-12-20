defmodule MorphyDBWeb.PageController do
  use MorphyDBWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
