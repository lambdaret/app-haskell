{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module ExAeson5 where

import           Data.Aeson
import           Data.Aeson.Types
import           Data.Vector      (fromList, toList)
import           GHC.Generics

-- 예제 JSON 배열
jsonData :: Value
jsonData =
  Array $
    fromList
      [ object ["name" .= ("John Doe" :: String), "age" .= (30 :: Int)],
        object ["name" .= ("Jane Doe" :: String), "age" .= (25 :: Int)]
      ]

-- 구조체를 파싱하는 함수
data Person = Person
  { name :: String,
    age  :: Int
  }
  deriving (Show, Generic)

instance FromJSON Person

-- 배열을 파싱하는 함수
parseArray :: Value -> Parser [Person]
parseArray = withArray "array" $ \arr -> do
  -- Vector를 리스트로 변환하고,
  -- 각 원소를 Person 타입으로 파싱한 뒤 리스트로 반환합니다.
  traverse parseJSON (toList arr)

-- 파싱 결과를 출력합니다.
mainExAeson5 :: IO ()
mainExAeson5 = do
  let result = parseMaybe parseArray jsonData
  print result -- Just [Person {name = "John Doe", age = 30},Person {name = "Jane Doe", age = 25}]
