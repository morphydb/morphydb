defmodule MorphyDBWeb.PageLive do
  use MorphyDBWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, locale} = MorphyDBWeb.Cldr.validate_locale(Map.get(session, "locale"))

    MorphyDBWeb.Cldr.put_locale(locale)
    Gettext.put_locale(locale.language)

    {:ok,
      socket
      |> assign(:now, DateTime.utc_now())
      |> assign(:locale, MorphyDBWeb.Cldr.get_locale().language)
    }
  end

  def handle_event("change_language", %{"lang" => language}, socket) do
    {:ok, locale} = MorphyDBWeb.Cldr.validate_locale(language)

    MorphyDBWeb.Cldr.put_locale(locale)
    Gettext.put_locale(locale.language)

    {:noreply,
      socket
      |> assign(:now, DateTime.utc_now())
      |> assign(:locale, locale.language)
      |> push_event("language_changed", %{lang: language})
    }
  end
end
