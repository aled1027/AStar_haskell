import Util
import qualified Data.List.Split as DLS
import qualified Data.List as DL ((\\))
import Data.Maybe (fromJust)
import System.IO.Unsafe
import qualified Data.Map as M
import Control.Monad.State
import Control.Applicative

import Control.Error
import Control.Monad
import Control.Monad.Trans
import Debug.Trace

{-
 - Why infinite loop????
 -  - change openList and closedList to priority queues based on fScoreMap as key
 -  - 
 -
 - https://downloads.haskell.org/~ghc/latest/docs/html/libraries/containers/Data-Map-Lazy.html
 -  - docs on Data.Map are for some reason here and not at Data.Map
://downloads.haskell.org/~ghc/latest/docs/html/libraries/containers/Data-Map-Lazy.html
 - Make sure that it finds shortest path with a simple, 3x3 map of all Emptys. 
nnn -
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
 -}


data Cell = O | G | A | E deriving (Show)

-- 0 - orbit
-- G - gravity
-- A - asteroid
-- E - empty
x = 3

type World = [[Cell]]
type Pos = (Int,Int)
type SearchState = ([Pos],[Pos],M.Map Pos Int, M.Map Pos Int) -- (openset, closedset, gScoreMap)

-- Input Settings
worldSize = 10 
startSearchState = ([start],[],startMap, startFScoreMap)  -- starts with first node on it

startMap = M.fromList $ map (\x -> (x, startValue)) allPoints
  where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
        startValue = 0

startFScoreMap = M.fromList $ map (\x -> (x, startValue)) allPoints
  where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
        startValue = 0

getNeighbors' p@(x,y) = [(x,y+1)]

getNeighbors p@(x,y) = filter (\(u,v) -> u > 0 && v > 0) possibleNeighbors 
    where delta = [-1, 0, 1]
          xs = map (+x) delta
          ys = map (+y) delta
          possibleNeighbors = ((,) <$> xs <*> ys) DL.\\ [p]

heuristicDist u v = max dx dy
    where dx = abs (fst u - fst v)
          dy = abs (snd u - snd v)

-- The real algorithm
preGo :: [[Cell]] -> State SearchState Int
preGo world = do
  let heuristic_score = heuristicDist start goal
  modify (\(a,b,c,d) -> (a,b, c,M.insert start heuristic_score d))
  go world


go :: [[Cell]] -> State SearchState Int
go world = do
  {-
   - This is the main loop of the a star program.
   - The things that happen before the loop happen in prego.
   -}
  (current:_, _, _, _) <- get
  modify (\(a,b,c,d) -> (tail a,current:b,c,d))
  if (current == goal) 
    then do
        (_, _, gScoreMap,_) <- get
        let Just distFromOrigin = M.lookup current gScoreMap
        modify (\(a,b,c,d) -> ([],[],c,d))
    else do
      -- loop over the neighbors
      let neighbors = getNeighbors current
      forM_ neighbors
        (\neighbor -> do
          (openList, closedList, gScoreMap,_) <- get
          when (neighbor `notElem` closedList) $ do

            let Just distFromOrigin       = M.lookup current gScoreMap
            let dist_current_to_neighbor  = 1
            let tentative_score           = distFromOrigin + dist_current_to_neighbor

            let Just neighbor_score       = M.lookup neighbor gScoreMap
            let bool = neighbor `notElem` openList || tentative_score < neighbor_score
            when bool $ do
              modify (\(a,b,c,d) -> (a,b
                            , M.insert neighbor tentative_score c
                            , M.insert neighbor (neighbor_score + (heuristicDist neighbor goal)) d))
              when (neighbor `notElem` openList) $ do
                modify (\(a,b,c,d) -> (neighbor:a, b, c,d))
         )
  (openList,_,gScoreMap, d) <- get
  if null openList
    then do return $ fromJust $ M.lookup goal gScoreMap
    else do return $ fromJust $ M.lookup goal gScoreMap 
    --else do go world

start = (1,1)
goal  = (1,2)

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
    let st = snd $ runState (preGo [[E]]) startSearchState
    print $ fst'  st
    print $ snd'  st
    print $ trd'  st 
    print $ frth' st 
    --x <- go world startSearchState
    return "exiting..."
