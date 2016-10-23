module Main where

import System.Environment
import Lib

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "usage: command user-agent filename"
    [ua, fn] -> do
      c <- readFile fn
      let us = parseRedUrlPair <$> lines c in
        checkRedirects ua us
