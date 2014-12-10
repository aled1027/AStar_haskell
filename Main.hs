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
 - Make sure that it finds shortest path with a simple, 3x3 map of all Emptys. 
 -
 - change some if statements to when
 -
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
startSearchState = ([(1,2)],[],startMap)  -- starts with first node on it

startMap = Map.fromList $ map (\x -> (x, startValue)) allPoints
    where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
          startValue = worldSize * worldSize

getNeighbors p@(x,y) = 
    ((,) <$> xs <*> ys) DL.\\ [p]
    where delta = [-1, 0, 1]
          xs = map (+x) delta
          ys = map (+y) delta

exit = left
goal = (-10,-30)
heuristicDist u v = abs (fst u - fst v) + abs (snd u - snd v)

--go :: State SearchState Int
go = do
  -- we always assume that our Maps will work, since they are preloaded 
  (current:a, b, c) <- get
  -- remove current from openlist
  modify (\(a,b,c) -> (tail a,b,c))
  runEitherT $ forM (getNeighbors current) 
    (\neighbor ->  do
      modify (\(a,b,c) -> (a,neighbor:b,c))
      (openList, closedList, gScoreMap) <- get
      when (neighbor == goal) $ do
            modify (\(a,b,c) -> ([],[],Map.empty))
            liftInner $ exit ()
      -- TODO this is always true due to above
      if neighbor `elem` closedList
        then modify id
        else 
          let Just distFromOrigin = Map.lookup current gScoreMap in
          let tentative_score =  distFromOrigin + (heuristicDist current neighbor) in
          if (neighbor `elem` openList) == False || tentative_score < (fromJust ( Map.lookup neighbor gScoreMap))
            then do
              modify (\(a,b,c) -> (a,b, Map.insert neighbor tentative_score c))
              if (neighbor `elem` openList) == False
                then modify (\(a,b,c) -> (neighbor:a, b, c))
                else modify id
            else modify id
     )
  (openList,_,_) <- get
  if null openList
    then do return "hi"
    else do go
  where liftInner = id

g = runState go startSearchState

    
generateCells :: [Cell]
generateCells = 
    (take (size *  10) (repeat G)) ++ (take (size * 30) (repeat A)) ++ (take (size * 60) (repeat E))
    where size = n*n `quot` 100
          n = worldSize


        
main = do
    let cells = unsafePerformIO . shuffleIO $ generateCells
    let world = DLS.chunksOf worldSize cells
    return world





