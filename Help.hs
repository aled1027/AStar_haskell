import Control.Monad.State
import Data.Tuple (swap)



def :: (Int,Int) -> (Int,Int)
def (x,y) = (x+1,y+1)

    
    

idd (x,y) = (x,y)

-- doesn't work
-- idd = (id,id)

go :: State (Int,Int) Int
go = do
    (x,y) <- get
    forM_ [1..10] (\x -> do
       modify idd)
    return x

e = runState go (0,1)


{-
go :: State SearchState Int
go = do
    (nextNode:openList, closedList) <- get
    let neighbors = getNeighbors nextNode
    -- forM_ :: Monad m => [a] -> (a -> m b) -> m ()
    a <- forM neighbors (\x -> x)
    return $ fst nextNode
-}


{-
import Data.List 
import Control.Applicative
type Pos = (Int,Int)
--getNeighbors :: Pos -> [Pos]
getNeighbors p@(x,y) = 
    ((,) <$> xs <*> ys) \\ [p]
    where delta = [-1, 0, 1]
          xs = map (+x) delta
          ys = map (+y) delta


playGame :: String -> State GameState GameValue
layGame []     = do
    (_, score) <- get
    return score
 
playGame (x:xs) = do
    (on, score) <- get
    case x of
         'a' | on -> put (on, score + 1)
         'b' | on -> put (on, score - 1)
         'c'      -> put (not on, score)
         _        -> put (on, score)
    playGame xs
-}


