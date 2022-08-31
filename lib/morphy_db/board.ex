defmodule MorphyDb.Board do
  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  calculate_file = fn file_index when file_index in 0..7 ->
    0..7
    |> Enum.map(fn rank_index -> Square.to_square_index(file_index, rank_index) end)
    |> Enum.reduce(Bitboard.empty(), fn square_index, bitboard ->
      Bitboard.set_bit(bitboard, square_index)
    end)
  end

  calculate_rank = fn rank_index when rank_index in 0..7 ->
    0..7
    |> Enum.map(fn file_index -> Square.to_square_index(file_index, rank_index) end)
    |> Enum.reduce(Bitboard.empty(), fn square_index, bitboard ->
      Bitboard.set_bit(bitboard, square_index)
    end)
  end

  @file_a calculate_file.(0)
  @file_b calculate_file.(1)
  @file_c calculate_file.(2)
  @file_d calculate_file.(3)
  @file_e calculate_file.(4)
  @file_f calculate_file.(5)
  @file_g calculate_file.(6)
  @file_h calculate_file.(7)

  @rank_1 calculate_rank.(0)
  @rank_2 calculate_rank.(1)
  @rank_3 calculate_rank.(2)
  @rank_4 calculate_rank.(3)
  @rank_5 calculate_rank.(4)
  @rank_6 calculate_rank.(5)
  @rank_7 calculate_rank.(6)
  @rank_8 calculate_rank.(7)

  def rank(0), do: @rank_1
  def rank(1), do: @rank_2
  def rank(2), do: @rank_3
  def rank(3), do: @rank_4
  def rank(4), do: @rank_5
  def rank(5), do: @rank_6
  def rank(6), do: @rank_7
  def rank(7), do: @rank_8

  def file(0), do: @file_a
  def file(1), do: @file_b
  def file(2), do: @file_c
  def file(3), do: @file_d
  def file(4), do: @file_e
  def file(5), do: @file_f
  def file(6), do: @file_g
  def file(7), do: @file_h

  def files(f1, f2), do: Bitboard.union(file(f1), file(f2))
end
