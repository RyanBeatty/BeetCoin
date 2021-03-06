module BeetCoin.Core.Time
  (getCurrentTimsetamp
  , diffTimestamps
  ) where

import BeetCoin.Core.Types (Timestamp (..), TimestampDiff (..))

import Data.Time (diffUTCTime)
import Data.Time.Clock.POSIX (getPOSIXTime, posixSecondsToUTCTime)

-- | Get the current timestamp from the system time.
getCurrentTimsetamp :: IO Timestamp
getCurrentTimsetamp = Timestamp <$> getPOSIXTime

-- | Calculate the difference between two timestamps.
-- diffTimestamps a b = a - b.
diffTimestamps :: Timestamp -> Timestamp -> TimestampDiff
diffTimestamps (Timestamp timea) (Timestamp timeb) =
  let utca = posixSecondsToUTCTime timea
      utcb = posixSecondsToUTCTime timeb
  in TimestampDiff $ diffUTCTime utca utcb
