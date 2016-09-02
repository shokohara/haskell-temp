{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Aeson.Lens
import Data.Aeson (decode, encode)
import Data.Aeson.TH (deriveJSON, defaultOptions, Options(..))
import Data.Char (toLower)
import System.IO.Unsafe

main :: IO ()
main = do
  let json = unsafePerformIO $ readFile "event.json"
  print $ json ^.. key "Records" . _Array . traverse . to ( \o -> ( o^?! key "EventSubscriptionArn" . _String, o^?! key "EventSource" . _String, o^?! key "EventVersion" . _String, o ^.. key "Sns" . key "Subject" . _String ))
