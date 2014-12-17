import qualified Data.List as DL
import qualified Data.Map as M
import Control.Applicative

main = putStrLn "hi"

type Key = Double
type Value = (Int,Int)
type PQPair = (Key,Value)
type PQ = [PQPair]

a = [(0.5,(1, 2)), (2,(0,1)),(3,(1, 5)), (0,(1, 3)), (2,(2, 5))]


sortKV :: PQPair -> PQPair -> Ordering
sortKV (k1,_) (k2,_) = compare k1 k2

sortPQ xs = DL.sortBy sortKV xs
-- sortPQ' = DL.sortBy . sortKV

headPQ ((a,p):_) = p

popPQ (_:xs) = xs

--pushPQ k v xs = sortPQ ((k,v):xs)
pushPQ k v xs = ((k,v):xs)

elemPQ x xs = x `elem` values
    where values = map (\(_,p) -> p) xs

{-

sortGT (a1,b1) (a2,b2) = 
  case compare a1 a2 of
    EQ -> compare b1 b2
    LT -> GT
    GT -> LT

worldSize = 3

ourMap = M.fromList $ map (\x -> (x, heuristicDist orig x)) allPoints
  where allPoints = (,) <$> [1..worldSize] <*> [1..worldSize]
        startValue = 0
        orig = (0,0)

openListSort p1 p2 
  | d1 < d2     = LT
  | d1 == d2    = EQ
  | otherwise   = GT    
  where d1 = M.lookup p1 m
        d2 = M.lookup p2 m
        m  = ourMap

mySort a b
  | d1 < d2     = LT
  | otherwise   = GT
  where d1 = heuristicDist origin a
        d2 = heuristicDist origin b
        origin = (1,1)

heuristicDist u v = max dx dy
    where dx = abs (fst u - fst v)
          dy = abs (snd u - snd v)
-}
