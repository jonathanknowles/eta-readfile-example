{-# LANGUAGE MagicHash #-}

module Main where

import Data.ByteString (ByteString)
import Java
import System.IO (BufferMode (..), hSetBuffering, stdout)

import qualified Data.ByteString as B

data {-# CLASS "java.net.URI" #-} URI = URI (Object# URI)
    deriving (Class, Show)

data {-# CLASS "java.nio.file.Path" #-} Path = Path (Object# Path)
    deriving (Class, Show)

foreign import java unsafe "@static java.net.URI.create"
    createURI :: String -> IO URI

foreign import java unsafe "@static java.nio.file.Paths.get"
    getPath :: URI -> IO Path

foreign import java unsafe "@static java.nio.file.Files.readAllBytes"
    readAllBytes :: Path -> IO JByteArray

toByteString :: JByteArray -> ByteString
toByteString ba = B.pack $ fromIntegral <$> bs
    where bs = fromJava ba :: [Byte]

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    putStrLn "Please enter a valid file URI:"
    bytes <- toByteString <$> (readAllBytes =<< getPath =<< createURI =<< getLine)
    putStrLn "Number of bytes read:"
    putStrLn $ show $ B.length bytes

