module BeetCoin.Core.TypesTest where

import BeetCoin.Core.Types
import BeetCoin.Core.TestUtils

import Crypto.Hash (digestFromByteString)
import Crypto.Number.Serialize (i2ospOf)
import qualified Data.ByteString as BS (ByteString, pack, length)
import Data.ByteString.Base58 (encodeBase58, bitcoinAlphabet)
import Data.Maybe (fromJust)
import Data.Serialize (encode, decode)
import Data.Word (Word32)
import qualified Test.Tasty.Hspec as HS


spec_PrivKey :: HS.Spec
spec_PrivKey = do
  HS.describe "PrivKey Tests" $ do

    HS.describe "Encoding Tests" $ do
      -- Verify that an encoded private key is the same as its raw representation.
      HS.it "Encoding Works" $ do
        encode parsedPrivKey `HS.shouldBe` rawPrivKey

      -- Verify that encoded private keys are 32 bytes long.
      HS.it "Encoded Length" $ do
        (BS.length . encode $ parsedPrivKey) `HS.shouldBe` 32
    
    HS.describe "Decoding Tests" $ do
      -- Verify that a decoded raw private key is the same as its parsed representation.
      HS.it "Decoding Works" $ do
        decode rawPrivKey `HS.shouldBe` Right parsedPrivKey

      -- Verify that the lower bound for a private key is valid.
      HS.it "Decode Lower Bound" $ do
        decode (fromJust . i2ospOf 32 $ privKeyLowerBound) `HS.shouldBe` Right (mkPrivKey privKeyLowerBound)

      -- Verify that less than the lower bound for a private key is invalid.
      HS.it "Decode Less Than Lower Bound" $ do
        HS.shouldBe (decode . fromJust . i2ospOf 32 $ privKeyLowerBound - 1 :: Either String PrivKey)
                    (Left "Failed reading: Number for PrivKey is out of range!\nEmpty call stack\n")
       
      -- Verify that the upper bound for a private key is valid.
      HS.it "Decode Upper Bound" $ do
        decode (fromJust . i2ospOf 32 $ privKeyUpperBound) `HS.shouldBe` Right (mkPrivKey privKeyUpperBound)

      -- Verify that more than the upper bound for a private key is invalid.
      HS.it "Decode More Than Upper Bound" $ do
        HS.shouldBe (decode . fromJust . i2ospOf 32 $ privKeyUpperBound + 1 :: Either String PrivKey)
                    (Left "Failed reading: Number for PrivKey is out of range!\nEmpty call stack\n")
        
spec_PubKey :: HS.Spec
spec_PubKey = do
  HS.describe "PubKey Tests" $ do

    HS.describe "Encoding Tests" $ do
      -- Verify that an encoded public key is the same as its raw representation.
      HS.it "Encoding Works" $ do
        encode parsedPubKey `HS.shouldBe` rawPubKey

      -- Verify that encoded public keys are 65 bytes long.
      HS.it "Encoded Length" $ do
        (BS.length . encode $ parsedPubKey) `HS.shouldBe` 65
    
    HS.describe "Decoding Tests" $ do
      -- Verify that a decoded raw public key is the same as its parsed representation.
      HS.it "Decoding Works" $ do
        decode rawPubKey `HS.shouldBe` Right parsedPubKey

spec_PubKeyHash :: HS.Spec
spec_PubKeyHash = do
  HS.describe "PubKeyHash Tests" $ do

    HS.describe "Encoding Tests" $ do
      -- Verify that an encoded public key hash is the same as its raw representation.
      HS.it "Encoding Works" $ do
        encode parsedPubKeyHash `HS.shouldBe` rawPubKeyHash
      
      -- Makes sure that the encoded public key hash is 20 bytes long.
      HS.it "Encoded Length" $ do
        (BS.length . encode $ parsedPubKeyHash) `HS.shouldBe` 20

    HS.describe "Decoding Tests" $ do
      -- Verify that decoding a raw public key results in the correct internal representation.
      HS.it "Decode Works" $ do
        decode rawPubKeyHash `HS.shouldBe` Right parsedPubKeyHash

spec_BeetCoinAddress :: HS.Spec
spec_BeetCoinAddress = do
  HS.describe "BeetCoinAddress" $ do
    
    HS.describe "Encoding Tests" $ do
      -- Verify that an encoded tribe coin address is the same as its raw representation.
      HS.it "Encoding Works" $ do
        encode parsedBeetCoinAddress `HS.shouldBe` rawBeetCoinAddress

      -- Verify that an encoded tribe coin address has a length of 33 bytes.
      -- TODO: Make sure 33 is the correct number here. It should be 25 bytes before it is
      -- base58 encoded.
      HS.it "Encoded Length" $ do
        (BS.length . encode $ parsedBeetCoinAddress) `HS.shouldBe` 33
  
    HS.describe "Decoding Tests" $ do
      -- Verify that a decoded raw tribe coin address matches its internal representation.
      HS.it "Decode Works" $ do
        decode rawBeetCoinAddress `HS.shouldBe` Right parsedBeetCoinAddress 