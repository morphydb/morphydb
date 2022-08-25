defmodule MorphyDb.Board do
  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  file = fn file_index when file_index in 0..7 ->
    0..7
    |> Enum.map(fn rank_index -> Square.to_square_index(file_index, rank_index) end)
    |> Enum.reduce(Bitboard.empty(), fn square_index, bitboard ->
      Bitboard.set_bit(bitboard, square_index)
    end)
  end

  @a_file file.(0)
  @b_file file.(1)
  @c_file file.(2)
  @d_file file.(3)
  @e_file file.(4)
  @f_file file.(5)
  @g_file file.(6)
  @h_file file.(7)

  def a_file, do: @a_file
  def b_file, do: @b_file
  def c_file, do: @c_file
  def d_file, do: @d_file
  def e_file, do: @e_file
  def f_file, do: @f_file
  def g_file, do: @g_file
  def h_file, do: @h_file
end
