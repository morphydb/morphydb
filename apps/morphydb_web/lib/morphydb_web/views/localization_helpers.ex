defmodule MorphyDBWeb.LocalizationHelpers do
  def format_number(number) do
    MorphyDBWeb.Cldr.Number.to_string! number
  end

  def language_class(lang, active_lang) do
    if active_lang == lang, do: "btn btn-xs btn-active", else: "btn btn-xs"
  end
end
