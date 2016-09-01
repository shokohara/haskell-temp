module Main where

import System.IO

main :: IO ()
main = do
  ln <- Just "a"
  putStrLn $ "Got: " ++ ln
