data Game = Game { scores :: ![Int] , gamedata :: ![Int] }

magic_turn game player turn =
    let current:newGamedata = (let (lead, tail) = splitAt ((length (gamedata game)) - 7) (gamedata game) in tail ++ lead)
        newScores = (let (lead, item:tail) = splitAt player (scores game) in lead ++ [item + turn + current] ++ tail)
    in Game {scores = newScores,
             gamedata = newGamedata}

regular_turn game player turn =
    let newdata = (let (lead, tail) = splitAt 2 (gamedata game) in [turn] ++ tail ++ lead)
    in Game {scores = (scores game),
             gamedata = newdata}

step :: Game -> Int -> Int -> Game
step game player turn
    | mod turn 23 == 0 = magic_turn game player turn
    | otherwise = regular_turn game player turn

run :: Game -> Int -> Int -> Int -> Int -> Game
run game player turn marbles total_players
    | marbles == turn = game
    | otherwise = (let newgame = (step game player turn)
                       nextplayer = (mod (player + 1) total_players)
                   in run newgame nextplayer (turn + 1) marbles total_players)

solve players marbles =
    let game = Game {scores = take players (repeat 0),
                     gamedata = [0]}
    in maximum (scores (run game 0 1 (marbles + 1) players))

main = print (solve 411 71170)
