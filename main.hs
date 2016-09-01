module Main where

import System.IO
import Data.Aeson

main :: IO ()
main = do
  ln <- readFile "testevent.txt"
  putStrLn $ "Got: " ++ ln
