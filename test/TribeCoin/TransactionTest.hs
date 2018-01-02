module TribeCoin.TransactionTest where

import TribeCoin.Transaction
import TribeCoin.Types (PubKey (..))

import TribeCoin.Arbitrary (RandomPubKeyHash (..))
import TribeCoin.TestUtils (parsedPubKey, parsedPubKeyHash, parsedSig, parsedSigMsg)

import Test.Tasty.Hspec (Spec, it, describe)
import Test.Tasty.QuickCheck (Property, forAll, arbitrary, suchThat)


spec_VerifyPubKey :: Spec
spec_VerifyPubKey = do
  describe "verifyPubKey Tests" $ do
    -- Verify that a public key will hash to the correct public key hash.
    it "Public Key matches Public Key Hash" $ do
      verifyPubKey parsedPubKey parsedPubKeyHash == True

spec_VerifySig :: Spec
spec_VerifySig = do
  describe "verifySig Tests" $ do
    it "PubKey validates signed message" $ do
      verifySig parsedPubKey parsedSig parsedSigMsg == True

-- | Verifies that a public key will never hash to a public key hash that it doesn not match.
prop_pubKeyAndPubKeyHashMismatch :: Property
prop_pubKeyAndPubKeyHashMismatch =
  -- Make sure we generate a public key hash that does not match the hash of this public
  -- key.
  forAll (arbitrary `suchThat` \h -> (_unRandomPubKeyHash h) /= parsedPubKeyHash) $
    \hash -> verifyPubKey parsedPubKey (_unRandomPubKeyHash hash) == False


