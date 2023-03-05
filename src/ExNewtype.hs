module ExNewtype where

-- newtype PositiveInt = PositiveInt Int
-- mkPositiveInt :: Int -> Maybe PositiveInt
-- mkPositiveInt i
--   | i > 0     = Just (PositiveInt i)
--   | otherwise = Nothing

-- newtype Meter = Meter Double
-- meterToFeet :: Meter -> Double
-- meterToFeet (Meter m) = m * 3.28084


-- newtype PositiveInt = PositiveInt Int

-- mkPositiveInt :: Int -> Maybe PositiveInt
-- mkPositiveInt i
--   | i > 0     = Just (PositiveInt i)
--   | otherwise = Nothing

import Data.Word (Word8)
import Data.Bits (testBit)
newtype Bit = Bit Word8

getBit :: Bit -> Int -> Bool
getBit (Bit b) i = testBit b i