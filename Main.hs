import Util
import qualified Data.List.Split as DLS
import qualified Data.List as DL ((\\))
import Data.Maybe (fromJust)
import System.IO.Unsafe
import qualified Data.Map as Map 
import Control.Monad.State
import Control.Applicative

import Control.Error
import Control.Monad
import Control.Monad.Trans

{-
 - https://downloads.haskell.org/~ghc/latest/docs/html/libraries/containers/Data-Map-Lazy.html
 -  - docs on Data.Map are for some reason here and not at Data.Map
://downloads.haskell.org/~ghc/latest/docs/html/libraries/containers/Data-Map-Lazy.html
 - Make sure that it finds shortest path with a simple, 3x3 map of all Emptys. 
 -
 - change some if statements to when
 -
 - Add world to getNeighbors to make sure the neighbors are acceptable
 -
 - Add map aspect to it, need to check the map to make sure that a point is viable. 
 -  - could add 
 -  -- This will require editing the map prior for all all points of gravity. 
 -    -- because it will just ensure that position is an E
 -  validatePoints :: [Pos] Map.Map-> [Pos]
 -  validatePoints pts the_map= filter f pts
 -    where filter p  = if (spotOnMap p) == E then True else False
 -          spotOnMap p = Map.lookup p the_map
 -
 -
 -}

data Cell = O | G | A | E deriving (Show)

-- 0 - orbit
-- G - gravity
-- A - asteroid
-- E - empty

type World = [[Cell]]
type Pos = (Int,Int)
type SearchState = ([Pos],[Pos],Map.Map Pos Int) -- (openset, closedset, gScoreMap)

-- Input Settings
worldSize = 10 
startSearchState = ([(2,2)],[],startMap)  -- starts with first node on it

startMap = Map.fromList $ map (\x -> (x, startValue)) allPoints
    where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
          startValue = 0

getNeighbors p = [(1,1)]
getNeighbors' p@(x,y) = 
    ((,) <$> xs <*> ys) DL.\\ [p]
    where delta = [-1, 0, 1]
          xs = map (+x) delta
          ys = map (+y) delta

exit = left
goal = (10,10)

heuristicDist u v = max dx dy
    where dx = abs (fst u - fst v)
          dy = abs (snd u - snd v)

go :: [[Cell]] -> State SearchState String
go world = do
  -- we always assume that our Maps will work, since they are preloaded 
  (current:a, b, c) <- get
  -- remove current from openlist
  modify (\(a,b,c) -> (tail a,b,c))

  -- loop over the neighbors
  runEitherT $ forM (getNeighbors current) 
    (\neighbor ->  do

      modify (\(a,b,c) -> (a,current:b,c))
      (openList, closedList, gScoreMap) <- get
      when (neighbor == goal) $ do
            modify (\(a,b,c) -> ([],[],Map.empty))
            liftInner $ exit ()

      let Just distFromOrigin = Map.lookup current gScoreMap
      let Just neighbor_score = Map.lookup neighbor gScoreMap
      let tentative_score     = distFromOrigin + (heuristicDist current neighbor)
      let bool = ((neighbor `elem` openList) == False) || tentative_score < neighbor_score

      when bool $ do
        modify (\(a,b,c) -> (a,b, Map.insert neighbor tentative_score c))
        modify (\(a,b,c) -> (neighbor:a, b, c))
     )
  (openList,_,_) <- get
  if null openList
    then do return "hi"
    else do return "hi"
    --else do go world
  where liftInner = id

generateCells :: [Cell]
generateCells = 
    (take (size *  10) (repeat G)) ++ (take (size * 30) (repeat A)) ++ (take (size * 60) (repeat E))
    where size = n*n `quot` 100
          n = worldSize

-- returns a simple map of all empties
generateCells' :: [Cell]
generateCells' = take size $ repeat E
    where size = n*n 
          n = worldSize

m = main
        
main = do
    let cells = unsafePerformIO . shuffleIO $ generateCells'
    let world = DLS.chunksOf worldSize cells
    print $ runState (go [[E]]) startSearchState
    --x <- go world startSearchState
    return "exiting..."





