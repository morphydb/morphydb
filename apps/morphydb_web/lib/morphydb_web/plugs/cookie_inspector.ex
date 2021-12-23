defmodule MorphyDBWeb.CookieInspector do
  import Plug.Conn

  def init(opts) do
    opts
  end

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    conn = fetch_cookies(conn)

    cookie = conn.cookies["locale"] || "en"

    {:ok, locale} = MorphyDBWeb.Cldr.validate_locale(cookie)

    MorphyDBWeb.Cldr.put_locale(locale)
    Gettext.put_locale(locale.language)

    conn
      |> put_resp_cookie("locale", locale.language, [max_age: 365 * 24 * 60 * 60, http_only: false])
      |> put_session("locale", locale.language)
  end

end
