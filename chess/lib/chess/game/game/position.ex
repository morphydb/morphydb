defmodule Game.Position do
  alias Chess.Bitboard
  alias Game.Square
  alias Game.Parsers.FenParser

  alias __MODULE__

  @enforce_keys [
    :position,
    :bitboards,
    :active_color,
    :castling_ability,
    :en_passant,
    :halfmove_clock,
    :fullmove_number,
    :highlight,
    :highlight_alt,
    :highlight_ctrl,
    :arrows
  ]
  defstruct [
    :position,
    :bitboards,
    :active_color,
    :castling_ability,
    :en_passant,
    :halfmove_clock,
    :fullmove_number,
    :highlight,
    :highlight_alt,
    :highlight_ctrl,
    :arrows
  ]

  @opaque t() :: %Position{
            position: list(list()),
            bitboards: %{
              P: Bitboard.t(),
              R: Bitboard.t(),
              N: Bitboard.t(),
              B: Bitboard.t(),
              Q: Bitboard.t(),
              K: Bitboard.t(),
              p: Bitboard.t(),
              r: Bitboard.t(),
              n: Bitboard.t(),
              b: Bitboard.t(),
              q: Bitboard.t(),
              k: Bitboard.t()
            },
            active_color: :w | :b,
            castling_ability: list(:K | :Q | :k | :q),
            en_passant: Square.t() | nil,
            halfmove_clock: non_neg_integer(),
            fullmove_number: non_neg_integer(),
            highlight: Bitboard.t(),
            highlight_alt: Bitboard.t(),
            highlight_ctrl: Bitboard.t(),
            arrows: list(%{from: integer(), to: integer()})
          }

  @type piece() :: :K | :Q | :R | :B | :N | :P | :k | :q | :r | :b | :n | :p

  def highlight(
        %Position{
          highlight: highlight,
          highlight_ctrl: highlight_ctrl,
          highlight_alt: highlight_alt
        } = position,
        square_index,
        :none
      ),
      do: %{
        position
        | highlight: highlight |> Bitboard.toggle(square_index),
          highlight_ctrl: highlight_ctrl |> Bitboard.clear(square_index),
          highlight_alt: highlight_alt |> Bitboard.clear(square_index)
      }

  def highlight(
        %Position{
          highlight: highlight,
          highlight_ctrl: highlight_ctrl,
          highlight_alt: highlight_alt
        } = position,
        square_index,
        :alt
      ),
      do: %{
        position
        | highlight: highlight |> Bitboard.clear(square_index),
          highlight_ctrl: highlight_ctrl |> Bitboard.clear(square_index),
          highlight_alt: highlight_alt |> Bitboard.toggle(square_index)
      }

  def highlight(
        %Position{
          highlight: highlight,
          highlight_ctrl: highlight_ctrl,
          highlight_alt: highlight_alt
        } = position,
        square_index,
        :ctrl
      ),
      do: %{
        position
        | highlight: highlight |> Bitboard.clear(square_index),
          highlight_ctrl: highlight_ctrl |> Bitboard.toggle(square_index),
          highlight_alt: highlight_alt |> Bitboard.clear(square_index)
      }

  def arrow(%Position{arrows: arrows} = position, arrow),
    do: arrow(position, arrow, Enum.member?(arrows, arrow))

  defp arrow(%Position{arrows: arrows} = position, arrow, true),
    do: %{
      position
      | arrows: Enum.filter(arrows, fn a -> arrow != a end)
    }

  defp arrow(%Position{arrows: arrows} = position, arrow, false),
    do: %{
      position
      | arrows: [arrow | arrows]
    }

  def clear_highlights(%Position{} = position),
    do: %{
      position
      | highlight: Bitboard.empty(),
        highlight_alt: Bitboard.empty(),
        highlight_ctrl: Bitboard.empty(),
        arrows: []
    }

  def piece(%Position{bitboards: bitboards}, square) do
    Map.filter(bitboards, fn {_piece, bitboard} -> Bitboard.set?(bitboard, square.index) end)
    |> Map.keys()
    |> Enum.at(0)
  end

  def squares(:w),
    do:
      7..0
      |> Enum.flat_map(fn rank ->
        0..7 |> Enum.map(fn file -> Square.new(%{file: file, rank: rank}) end)
      end)

  def squares(:b),
    do:
      0..7
      |> Enum.flat_map(fn rank ->
        7..0 |> Enum.map(fn file -> Square.new(%{file: file, rank: rank}) end)
      end)

  def to_fen(%Position{} = position) do
    [
      render_position(position),
      render_active_color(position.active_color),
      render_castling_ability(position.castling_ability),
      render_en_passant(position.en_passant),
      render_halfmove_clock(position.halfmove_clock),
      render_fullmove_number(position.fullmove_number)
    ]
    |> Enum.join(" ")
  end

  defp render_position(%Position{} = position) do
    squares(:b)
    |> Enum.map(fn square -> render_piece(piece(position, square)) end)
    |> Enum.chunk_every(8)
    |> Enum.map(fn rank -> render_rank(rank |> Enum.reverse(), 0) end)
    |> Enum.reverse()
    |> Enum.join("/")
  end

  defp render_rank([" "], empty_counter), do: Integer.to_string(empty_counter + 1)
  defp render_rank([element], 0), do: element
  defp render_rank([element], empty_counter), do: Integer.to_string(empty_counter) <> element
  defp render_rank([" " | tail], empty_counter), do: render_rank(tail, empty_counter + 1)

  defp render_rank([element | tail], empty_counter),
    do: render_rank([element], empty_counter) <> render_rank(tail, 0)

  defp render_piece(nil), do: " "
  defp render_piece(piece), do: Atom.to_string(piece)

  defp render_active_color(color), do: Atom.to_string(color)

  defp render_castling_ability([]), do: "-"
  defp render_castling_ability([side]), do: Atom.to_string(side)

  defp render_castling_ability([side | tail]),
    do: render_castling_ability([side]) <> render_castling_ability(tail)

  defp render_en_passant(nil), do: "-"
  defp render_en_passant(%Square{} = square), do: to_string(square)

  defp render_halfmove_clock(halfmove_clock), do: Integer.to_string(halfmove_clock)
  defp render_fullmove_number(fullmove_number), do: Integer.to_string(fullmove_number)
end
