defmodule MorphyDBWeb.Cldr do
  use Cldr,
    default_locale: "en",
    locales: ~w(en nl),
    providers: [Cldr.Number, Cldr.DateTime],
    gettext: MorphyDBWeb.Gettext
end
