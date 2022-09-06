defmodule MorphyDb.MagicBitboard do
  def bishops(),
    do: [
      452_049_087_547_613_188,
      432_627_314_239_669_280,
      9_234_103_270_341_869_572,
      9_713_085_719_775_252,
      1_337_006_139_899_904,
      576_619_081_994_600_456,
      144_120_762_977_091_593,
      9_547_666_395_505_901_568,
      72_374_717_788_454_914,
      144_273_554_161_043_976,
      144_484_651_902_257_184,
      4_611_758_655_723_831_296,
      4_683_744_780_730_040_360,
      9_223_376_435_980_673_028,
      2_251_877_123_900_433,
      36_310_289_188_129_440,
      3_539_829_307_348_101_129,
      147_563_325_266_878_488,
      12_422_869_271_183_360,
      4_627_659_740_814_508_053,
      721_701_849_147_637_776,
      148_689_208_037_474_306,
      9_189_168_563_359_808,
      1_152_921_793_325_957_120,
      18_691_732_291_840,
      71_193_552_490_498,
      9_295_572_706_068_004_868,
      1_297_177_430_206_717_952,
      2_526_528_255_767_617_539,
      9_296_837_044_500_168_848,
      4_611_836_652_091_359_272,
      141_976_855_941_388,
      2_323_868_420_024_045_184,
      2_400_423_557_780_771_328,
      9_223_380_841_575_695_392,
      36_028_805_617_565_712,
      9_042_798_125_781_249,
      1_107_853_344,
      10_377_017_020_113_356_800,
      1_801_514_701_558_513_664,
      72_064_740_870_406_912,
      4_904_782_837_424_587_808,
      1_179_054_422_098_946,
      1_157_460_357_326_839_944,
      2_324_367_582_169_248,
      2_534_674_954_720_512,
      11_529_497_629_956_244_736,
      9_223_381_937_828_151_560,
      572_022_098_771_968,
      72_092_790_221_881_472,
      1_171_500_227_466_625_024,
      4_645_442_600_714_240,
      18_023_194_661_224_448,
      289_356_467_188_838_400,
      1_748_113_537_010_502_945,
      1_159_758_267_912_618_112,
      1_152_956_693_542_412_288,
      2_332_866_815_130_371_072,
      144_185_602_990_999_072,
      9_224_498_067_029_574_144,
      2_883_439_027_177_406_464,
      1_730_514_899_987_152_896,
      2_305_843_290_601_752_834,
      1_161_101_492_359_357
    ]

  def rooks(),
    do: [
      70_628_590_755_857,
      1_302_244_117_232_836_684,
      2_251_821_959_676_032,
      360_446_446_432_158_856,
      54_747_041_951_128_656,
      2_534_649_318_343_712,
      73_328_698_744_702_992,
      619_616_223_776,
      9_223_372_106_648_535_360,
      297_237_618_528_624_656,
      1_153_203_123_468_140_592,
      11_543_791_808,
      9_511_673_918_843_256_832,
      144_115_261_158_523_024,
      2_922_976_895_724_422_212,
      9_817_869_178_472_301_056,
      2_305_845_209_178_705_984,
      1_454_664_878_957_531_408,
      3_466_788_750_216_953_924,
      13_835_058_643_693_273_096,
      70_510_905_917_440,
      580_999_536_453_883_016,
      576_601_765_768_992_384,
      9_223_728_347_396_179_984,
      162_865_447_442_496,
      742_469_420_207_116_554,
      1_224_997_790_342_525_440,
      2_308_377_392_242_102_304,
      216_172_831_514_493_985,
      8_214_671_274_120_183_808,
      46_162_325_694_119_958,
      144_343_886_632_978_432,
      2_256_525_351_715_088,
      1_126_038_222_472_384,
      586_879_725_561_970_881,
      189_151_639_616_114_705,
      424_428_668_191_364,
      914_240_896_717_881_424,
      146_376_883_896_909_832,
      5_260_785_052_937_095_232,
      9_511_615_333_442_586_624,
      4_539_077_970_034_688,
      9_299_968_694_201_352_344,
      9_011_598_141_194_368,
      162_130_276_070_195_200,
      27_044_212_914_938_129,
      455_449_876_942_361_608,
      76_152_244_076_021_280,
      1_175_546_241_543_602_176,
      649_081_324_254_035_968,
      4_625_196_886_030_553_600,
      8_090_225_248_876_790_810,
      9_367_487_363_716_096_032,
      36_627_154_817_028_096,
      5_348_282_301_956_420,
      669_347_511_806_853_120,
      4_504_909_594_492_936,
      1_155_190_896_616_020_100,
      649_085_694_343_516_432,
      76_600_776_102_129_689,
      4_611_862_582_671_048_728,
      285_873_027_418_402,
      705_914_383_106_060,
      2_810_424_289_436_898_180
    ]

  defmodule Calculator do
    # Elixir version of Tord Romstad's method

    use Bitwise

    @bit_table Code.eval_string("""
      [
        63, 30, 3, 32, 25, 41, 22, 33, 15, 50, 42, 13, 11, 53, 19, 34, 61, 29, 2,
        51, 21, 43, 45, 10, 18, 47, 1, 54, 9, 57, 0, 35, 62, 31, 40, 4, 49, 5, 52,
        26, 60, 6, 23, 44, 46, 27, 56, 16, 7, 39, 48, 24, 59, 14, 12, 55, 38, 28,
        58, 20, 37, 17, 36, 8
      ]
      """)

    @rook_bits Code.eval_string("""
    [
      12, 11, 11, 11, 11, 11, 11, 12,
      11, 10, 10, 10, 10, 10, 10, 11,
      11, 10, 10, 10, 10, 10, 10, 11,
      11, 10, 10, 10, 10, 10, 10, 11,
      11, 10, 10, 10, 10, 10, 10, 11,
      11, 10, 10, 10, 10, 10, 10, 11,
      11, 10, 10, 10, 10, 10, 10, 11,
      12, 11, 11, 11, 11, 11, 11, 12
    ]
    """)

    @bishop_bits Code.eval_string("""
    [
      6, 5, 5, 5, 5, 5, 5, 6,
      5, 5, 5, 5, 5, 5, 5, 5,
      5, 5, 7, 7, 7, 7, 5, 5,
      5, 5, 7, 9, 9, 7, 5, 5,
      5, 5, 7, 9, 9, 7, 5, 5,
      5, 5, 7, 7, 7, 7, 5, 5,
      5, 5, 5, 5, 5, 5, 5, 5,
      6, 5, 5, 5, 5, 5, 5, 6
    ]
    """)

    def random(), do: :rand.uniform(65536) &&& 0xFFFF

    def random_uint64() do
      random()
      |> bor(random() <<< 16)
      |> bor(random() <<< 32)
      |> bor(random() <<< 48)
    end

    def random_uint64_few_bits(), do: random_uint64() &&& random_uint64() &&& random_uint64()

    def count_ones(0), do: 0
    def count_ones(bitboard), do: 1 + count_ones(bitboard &&& bitboard - 1)

    def pop_first_bit(bitboard) do
      b = bxor(bitboard, bitboard - 1)
      fold = bxor(band(b, 0xFFFFFFFF), b >>> 32)
      value = Enum.at(@bit_table, fold)

      {value, band(bitboard, bitboard - 1)}
    end

    def index_to_uint64(index, bits, mask) do
      0..bits
      |> Enum.map(fn i ->
        {value, _} = pop_first_bit(mask)

        {i, value}
      end)
      |> Enum.reduce(0, fn {i, j}, result ->
        if j != nil and band(index, 1 <<< i) > 0, do: bor(result, 1 <<< j), else: result
      end)
    end

    def rook_mask(square) do
      rank = div(square, 8)
      file = rem(square, 8)

      r1 =
        (rank + 1)..6//1
        |> Enum.to_list()
        |> List.foldl(0, fn r, result -> bor(result, 1 <<< (file + r * 8)) end)

      r2 =
        (rank - 1)..1//-1
        |> Enum.to_list()
        |> List.foldl(r1, fn r, result -> bor(result, 1 <<< (file + r * 8)) end)

      r3 =
        (file + 1)..6//1
        |> Enum.to_list()
        |> List.foldl(r2, fn f, result -> bor(result, 1 <<< (f + rank * 8)) end)

      r4 =
        (file - 1)..1//-1
        |> Enum.to_list()
        |> List.foldl(r3, fn f, result -> bor(result, 1 <<< (f + rank * 8)) end)

      r4
    end

    def bishop_mask(square) do
      rank = div(square, 8)
      file = rem(square, 8)

      b1 =
        Enum.zip((rank + 1)..6//1, (file + 1)..6//1)
        |> Enum.to_list()
        |> List.foldl(0, fn {r, f}, result -> bor(result, 1 <<< (f + r * 8)) end)

      b2 =
        Enum.zip((rank + 1)..6//1, (file - 1)..1//-1)
        |> Enum.to_list()
        |> List.foldl(b1, fn {r, f}, result -> bor(result, 1 <<< (f + r * 8)) end)

      b3 =
        Enum.zip((rank - 1)..1//-1, (file + 1)..6//1)
        |> Enum.to_list()
        |> List.foldl(b2, fn {r, f}, result -> bor(result, 1 <<< (f + r * 8)) end)

      b4 =
        Enum.zip((rank - 1)..1//-1, (file - 1)..1//-1)
        |> Enum.to_list()
        |> List.foldl(b3, fn {r, f}, result -> bor(result, 1 <<< (f + r * 8)) end)

      b4
    end

    def rook_attack(square, block) do
      rank = div(square, 8)
      file = rem(square, 8)

      r1 =
        (rank + 1)..7//1
        |> Enum.reduce_while(0, fn r, result ->
          s = 1 <<< (file + r * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      r2 =
        (rank - 1)..0//-1
        |> Enum.reduce_while(r1, fn r, result ->
          s = 1 <<< (file + r * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      r3 =
        (file + 1)..7//1
        |> Enum.reduce_while(r2, fn f, result ->
          s = 1 <<< (f + rank * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      r4 =
        (file - 1)..0//-1
        |> Enum.reduce_while(r3, fn f, result ->
          s = 1 <<< (f + rank * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      r4
    end

    def bishop_attack(square, block) do
      rank = div(square, 8)
      file = rem(square, 8)

      b1 =
        Enum.zip((rank + 1)..7//1, (file + 1)..7//1)
        |> Enum.reduce_while(0, fn {r, f}, result ->
          s = 1 <<< (f + r * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      b2 =
        Enum.zip((rank + 1)..7//1, (file - 1)..0//-1)
        |> Enum.reduce_while(b1, fn {r, f}, result ->
          s = 1 <<< (f + r * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      b3 =
        Enum.zip((rank - 1)..0//-1, (file + 1)..7//1)
        |> Enum.reduce_while(b2, fn {r, f}, result ->
          s = 1 <<< (f + r * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      b4 =
        Enum.zip((rank - 1)..0//-1, (file - 1)..0//-1)
        |> Enum.reduce_while(b3, fn {r, f}, result ->
          s = 1 <<< (f + r * 8)

          while = if band(block, s) === 0, do: :cont, else: :halt
          {while, bor(result, s)}
        end)

      b4
    end

    def transform(board, magic, number_of_moves), do: (board * magic) >>> (64 - number_of_moves)

    defp check_magic(magic, 0, _, _, _) do
      {:ok, magic}
    end

    defp check_magic(magic, i, init, number_of_moves, used) do
      {board, attack} = Enum.at(init, i)
      j = transform(board, magic, number_of_moves)

      current = Enum.at(used, j, attack)

      if current !== attack do
        {:fail}
      else
        check_magic(magic, i - 1, init, number_of_moves, List.insert_at(used, j, attack))
      end
    end

    defp is_valid_magic(magic, number_of_ones_in_mask, init, number_of_moves) do
      case check_magic(magic, 1 <<< number_of_ones_in_mask, init, number_of_moves, []) do
        {:ok, magic} -> magic
        {:fail} -> false
      end
    end

    def find_magic(square, for_bishop) do
      mask = if for_bishop, do: bishop_mask(square), else: rook_mask(square)
      number_of_ones_in_mask = count_ones(mask)

      number_of_moves =
        if for_bishop, do: Enum.at(@bishop_bits, square), else: Enum.at(@rook_bits, square)

      init =
        0..(1 <<< number_of_ones_in_mask)
        |> Enum.map(fn i ->
          b = index_to_uint64(i, number_of_ones_in_mask, mask)
          a = if for_bishop, do: bishop_attack(square, b), else: rook_attack(square, b)

          {b, a}
        end)

      0..100_000
        |> Stream.map(fn _ -> random_uint64_few_bits() end)
        |> Stream.filter(fn possible_magic ->
          count_ones(mask * possible_magic &&& 0xFF00000000000000) >= 6
        end)
        |> Stream.filter(fn possible_magic ->
          is_valid_magic(possible_magic, number_of_ones_in_mask, init, number_of_moves)
        end)
        |> Enum.at(0)
    end

    def main() do
      IO.puts(" --- ROOKS ---")

      0..63
      |> Enum.map(fn square ->
        magic = find_magic(square, :r)
        IO.puts("#{magic},")
      end)

      IO.puts(" --- BISHOPS ---")

      0..63
      |> Enum.map(fn square ->
        magic = find_magic(square, :b)
        IO.puts("#{magic},")
      end)
    end
  end
end
