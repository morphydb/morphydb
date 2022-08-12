defmodule MorphyDbWeb.PageControllerTest do
  use MorphyDbWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Phoenix + Tailwind"
  end
end
