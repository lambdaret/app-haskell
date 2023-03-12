{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Etc.ExNewtype where

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

import           Data.Bits (testBit)
import           Data.Word (Word8)
newtype Bit = Bit Word8

getBit :: Bit -> Int -> Bool
getBit (Bit b) = testBit b
