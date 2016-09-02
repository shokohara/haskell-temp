-- Aeson は ByteString から生成するのでこのプラグマを使用する
{-# LANGUAGE OverloadedStrings #-}
-- Data.Aeson.TH を利用するとはかどるのでこのプラグマを使用する
{-# LANGUAGE TemplateHaskell #-}

import Data.Aeson (decode, encode)
import Data.Aeson.TH (deriveJSON, defaultOptions, Options(..))
import Data.Char (toLower)
import System.IO.Unsafe

data Foo a = Foo { fooId :: a } deriving (Show, Read, Eq)
-- ここ重要！
-- TH を使っているので初見では読めないが、こんな書き方なんだ〜、ぐらいで OK。
-- ポイントは defaultOptions を元に fieldLabelModifier を
-- 先頭 3 文字を削除して小文字に置き換えるようにしていること。
-- こうすると {"fooId":1} という JSON が {"id":1} という JSON になる。
deriveJSON defaultOptions { fieldLabelModifier = map toLower . drop 3 } ''Foo

data Bar = Bar {} deriving (Show, Read, Eq)
deriveJSON defaultOptions ''Bar

data Baz = Baz | Qux  deriving (Show, Read, Eq)
deriveJSON defaultOptions ''Baz

data Help a = Help {fooId2 :: a} deriving (Show, Read, Eq)
deriveJSON defaultOptions ''Help

data Record = { eventVersion :: String } deriving (Show, Read, Eq, Generic)
instance FromJson Record
instance ToJson Record

data Records = { records :: Maybe Record } deriving (Show, Read, Eq, Generic)
instance FromJson Records
instance ToJson Records

main :: IO ()
main = do
  let json0 = unsafePerformIO $ readFile "event.json"
      decoded0 = decode json0 :: Records
  print decoded0

