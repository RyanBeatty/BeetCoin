{-# LANGUAGE DeriveGeneric, GeneralizedNewtypeDeriving #-}
module TribeCoin.Types
    ( BlockHash (..)
    , Timestamp (..)
    , Difficulty (..)
    , Nonce (..)
    , BlockHeader (..)
    , Block (..)
    ) where

import Control.Monad.Fail as MF (fail)
import Crypto.Hash (Digest, SHA256, digestFromByteString)
import Data.ByteArray (ByteArrayAccess, convert)
import qualified Data.ByteString as BS (ByteString)
import Data.Serialize (Serialize, put, get, Get)
import Data.Word (Word32, Word8)
import GHC.Generics (Generic)

-- ^ The sha256 hash of a block header.
newtype BlockHash = BlockHash (Digest SHA256)
      deriving (Show, Eq)

instance Serialize BlockHash where
  put (BlockHash digest) = put $ (convert digest :: BS.ByteString)
  get = do
    byte_string <- get :: (Get BS.ByteString)
    case digestFromByteString byte_string of
      Nothing       -> MF.fail "Invalid BlockHash"
      (Just digest) -> return $ BlockHash digest

newtype Timestamp = Timestamp Word32
      deriving (Show, Eq, Ord)

-- ^ A 32 bit number which represents the number of leading 0's that should be in a block header hash.
-- ^ Is dynamically adjusted.
newtype Difficulty = Difficulty Word32
      deriving (Show, Integral, Real, Enum, Num, Ord, Eq, Generic)
instance Serialize Difficulty

newtype Nonce = Nonce Word32
      deriving (Show, Enum, Generic)
instance Serialize Nonce

data BlockHeader = BlockHeader
  { _previousBlockHash :: BlockHash
  , _difficulty :: Difficulty
  , _nonce :: Nonce
  } deriving (Show, Generic)
instance Serialize BlockHeader

newtype Amount = Amount Word8
      deriving (Show, Eq)

data Transaction = Transaction
  { _sender :: ()
  , _receiver :: ()
  , _amount :: Amount
  } deriving (Show)

data Block = Block
  { _blockHeader :: BlockHeader
  , _transactions :: [Transaction]
  , _timestamp :: Timestamp
  } deriving (Show)
