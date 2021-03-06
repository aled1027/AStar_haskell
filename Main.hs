import Util
import qualified Data.List.Split as DLS
import qualified Data.List as DL ((\\), sortBy)
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
 -
 - Problem: it is infite looping because the openList is not implemented as a priority queue
 -  --> so it never grabs the best. It just grabs the one on the head, finds that it isn't the goal, 
 -      adds its neighbors to the list, and now the head of the list is one of the new neighbors. 
 -      Then the process repeats. 
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
type SearchState = (PQ,[Pos],M.Map Pos Int, M.Map Pos Int) -- (openset, closedset, gScoreMap, fScoreMap)
type Key = Double
type Value = Pos
type PQPair = (Key,Value)
type PQ = [PQPair]

-- Priority Queue functions
headPQ    :: PQ -> Value
popPQ     :: PQ -> PQ
pushPQ    :: Key -> Value -> PQ -> PQ
sortKV    :: PQPair -> PQPair -> Ordering
elemPQ    :: Value -> PQ -> Bool
notElemPQ :: Value -> PQ -> Bool
headPQ ((a,p):_)      = p
popPQ (_:xs)          = xs
pushPQ k v xs         = sortPQ ((k,v):xs)
sortKV (k1,_) (k2,_)  = compare k1 k2
sortPQ xs             = DL.sortBy sortKV xs
elemPQ x xs           = x `elem` values where values = map (\(_,p) -> p) xs
notElemPQ x xs        = not $ x `elemPQ` xs

-- Input Settings
worldSize = 10 
start = (1,1)
goal  = (10,10)
startSearchState = (pushPQ 0 start [],[],startMap, startFScoreMap)  -- starts with first node on it
startMap = M.fromList $ map (\x -> (x, startValue)) allPoints
  where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
        startValue = 0
startFScoreMap = M.fromList $ map (\x -> (x, startValue)) allPoints
  where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
        startValue = 0

getNeighbors' p@(x,y) = [(x,y+4)]
getNeighbors p@(x,y) = filter (\(u,v) -> u > 0 && v > 0) possibleNeighbors 
    where delta = [-1, 0, 1]
          xs = map (+x) delta
          ys = map (+y) delta
          possibleNeighbors = ((,) <$> xs <*> ys) DL.\\ [p]

heuristicDist u v = max dx dy
    where dx = abs (fst u - fst v)
          dy = abs (snd u - snd v)

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
   -
   - (openList,closedList,gMap,fMap)
   - openlist is a priority queue of the nodes to check
   - closedList is a list of the nodes which have already been checked
   - gMap maps Node -> distance and represents the calculated, real distance from origin to the node origin
   - fMap maps Node -> distance and represents the distance 
   -
   -
   -}
  (c, _, _, _) <- get
  let current = headPQ c
  modify (\(a,b,c,d) -> (popPQ a,current:b,c,d))
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
            modify id
            let Just distFromOrigin       = M.lookup current gScoreMap
            let dist_current_to_neighbor  = 1
            let tentative_score           = distFromOrigin + dist_current_to_neighbor
            let Just neighbor_score       = M.lookup neighbor gScoreMap
            let bool = neighbor `notElemPQ` openList || tentative_score < neighbor_score
            when bool $ do
              modify (\(a,b,c,d) -> (a,b
                            , M.insert neighbor tentative_score c
                            , M.insert neighbor (neighbor_score + (heuristicDist neighbor goal)) d))
              when (neighbor `notElemPQ` openList) $ do
                let n_score = fromIntegral $ neighbor_score + (heuristicDist neighbor goal)
                modify (\(a,b,c,d) -> (pushPQ n_score neighbor a, b, c,d))
         )
  (openList,_,gScoreMap, d) <- get

  if null openList
    then do return $ fromJust $ M.lookup goal gScoreMap
    --else do return $ fromJust $ M.lookup goal gScoreMap 
    else do go world

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
