module Lib (
    parseRedUrlPair,
    checkRedirects
  ) where

import Network.Curl
import Data.Monoid

data RedUrlPair = RedUrlPair {
    from :: String,
    to :: String
  } deriving Show

type HeaderInfo = (String, String)


parseRedUrlPair :: String -> RedUrlPair
parseRedUrlPair s = RedUrlPair from to
  where [from, to] = words s

checkRedirects :: String -> [RedUrlPair] -> IO ()
checkRedirects ua us = do
  rs <- mapM (isCorrect ua) us
  let es = [snd r | r <- rs, not (fst r)] in
    if null es
      then putStrLn "All OK!"
      else mapM_ print es

isCorrect :: String -> RedUrlPair -> IO (Bool, String)
isCorrect ua up = do
  u <- getRedirUrl ua uf
  case u of
    Nothing -> return (False, "Broken link: " `mappend` uf)
    Just loc
      | loc == uf -> return (True, "No redirect: " `mappend` uf)
      | loc == ut -> return (True, "Correct redirect: " `mappend` uf `mappend` " -> " `mappend` loc)
      | otherwise -> return (False, "Incorrect redirect: " `mappend` uf `mappend` " -> " `mappend` loc `mappend` " is not " `mappend` ut)
  where
    uf = from up
    ut = to up

getRedirUrl :: String -> String -> IO (Maybe String)
getRedirUrl ua u = do
  hr <- curlHead u opts
  let hs = snd hr in
    case hs of
      [] -> return Nothing
      _ -> case getAttrLocation hs of
        Nothing -> return $ Just u
        Just loc -> return . Just $ remSpace loc
  where
    opts = [CurlFollowLocation True, CurlMaxRedirs 10, CurlNoBody True, CurlTimeout 5, CurlUserAgent ua]
    remSpace = tail

getAttrLocation :: [HeaderInfo] -> Maybe String
getAttrLocation = lookup "Location" . reverse
