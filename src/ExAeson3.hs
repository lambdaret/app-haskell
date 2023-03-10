{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module ExAeson3 where

import           Data.Aeson
import           Data.Aeson.Types
import           Data.Vector      (fromList, toList)

-- 예제 JSON 배열
jsonData :: Value
jsonData = Array $ fromList [Number 1, Number 2, Number 3]

-- 배열을 파싱하는 함수
parseArray :: Value -> Parser [Integer]
parseArray = withArray "array" $ \arr -> do
  -- Vector를 리스트로 변환하고,
  -- 각 원소를 정수로 파싱한 뒤 리스트로 반환합니다.
  traverse parseJSON (toList arr)

newtype MyInteger = MyInteger {unMyInteger :: [Integer]} deriving (Show)

instance FromJSON MyInteger where
  parseJSON = withArray "array" $ \arr -> do
    MyInteger <$> traverse parseJSON (toList arr)

-- 파싱 결과를 출력합니다.
mainExAeson3 :: IO ()
mainExAeson3 = do
  let result = parseMaybe parseArray jsonData
  print result -- Just [1,2,3]
