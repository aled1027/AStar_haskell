import Util
import qualified Data.List.Split as DLS
import qualified Data.List as DL ((\\))
import Data.Maybe (fromJust)
import System.IO.Unsafe
import qualified Data.Map as Map 
import Control.Monad.State
import Control.Applicative


data Cell = O | G | A | E deriving (Show)

-- 0 - orbit
-- G - gravity
-- A - asteroid
-- E - empty

type World = [[Cell]]
type Pos = (Int,Int)
type SearchState = ([Pos],[Pos],Map.Map Pos Int, Int) -- (openset, closedset, gScoreMap)

-- Input Settings
worldSize = 10 
startSearchState = ([(1,2)],[],startMap, 0)  -- starts with first node on it
goal = (2,3)

startMap = Map.fromList $ map (\x -> (x, startValue)) allPoints
    where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
          startValue = worldSize * worldSize

getNeighbors p@(x,y) = 
    ((,) <$> xs <*> ys) DL.\\ [p]
    where delta = [-1, 0, 1]
          xs = map (+x) delta
          ys = map (+y) delta


heuristicDist _ _ = 1

-- evalState/execState go startSearchState
-- returns int + state monad (of type SearchState)

go :: State SearchState Int
go = do
  {- we always assume that our Maps will work, since they are preloaded -}
  (current:a, b, c, d) <- get
  -- remove current from openlist
  modify (\(a,b,c,d) -> (tail a,b,c,d))
  forM (getNeighbors current) 
    (\neighbor ->  do
      modify (\(a,b,c,d) -> (a,neighbor:b,c,d))
      (openList, closedList, gScoreMap, _) <- get
      if neighbor == goal
        then
          modify (\(a,b,c,d) -> (a,b,c,1))
        else
          -- TODO this is always true due to above
          if neighbor `elem` closedList
            then modify id
            else 
              let Just distFromOrigin = Map.lookup current gScoreMap in
              let tentative_score =  distFromOrigin + (heuristicDist current neighbor) in
              if (neighbor `elem` openList) == False || tentative_score < (fromJust ( Map.lookup neighbor gScoreMap))
                then do
                  modify (\(a,b,c,d) -> (a,b, Map.insert neighbor tentative_score c,d))
                  if (neighbor `elem` openList) == False
                    then modify (\(a,b,c,d) -> (neighbor:a, b, c, d))
                    else modify id
                else modify id
    )
  (openList,_,_,isOver) <- get
  if null openList
    then return 1
    else do go

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





