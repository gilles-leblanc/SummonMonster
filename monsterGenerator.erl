-module(monsterGenerator).
-export([monster/2]).

% Expected input:
%					monster("Kobold", 3).
%
% Expected output:
%					Kobold(3), AC 7, HD 1/2, HP (1, 4, 2), Att 1 weapon, Dmg (Club 1d3-1, Dagger 1d4-1, Dagger 1d4-1), 
%					Save Normal Man, Morale 6, Treasure (2 cp, 12 cp, 21 cp), XP 5
%

monster(Name, Number) -> case Name of
							"Bugbear" -> io:format("~s(~p), AC 5, HD 3+1, HP ~p, Att 1 weapon, Dmg ~s +1 ~n", 
												  [Name, Number, [monster_hp(3, 1) || _  <- lists:seq(1, Number)], 
												         [monsterWeapons:generate_weapon(large) || _ <- lists:seq(1, Number)]]),
										io:format("Save Normal Man, Morale 6, Treasure ~s ~s, XP 50 ~n",
												  [monsterTreasures:generate_treasure(p), monsterTreasures:generate_treasure(q)]);	

							"Kobold" -> io:format("~s(~p), AC 7, HD 1/2, HP ~p, Att 1 weapon, Dmg ~s -1 ~n", 
												  [Name, Number, [monster_hp(0.5) || _  <- lists:seq(1, Number)], 
												         [monsterWeapons:generate_weapon(small) || _ <- lists:seq(1, Number)]]),
										io:format("Save Normal Man, Morale 6, Treasure ~s, XP 5 ~n",
												  [monsterTreasures:generate_treasure(p)]);			
							
							"Skeleton" -> io:format("~s(~p), AC 7, HD 1, HP ~p, Att 1 weapon, Dmg Claws 1d2 ~n", 
												  [Name, Number, [monster_hp(1) || _  <- lists:seq(1, Number)]]), 
										  io:format("Save F1, Morale 12, Treasure ~s, XP 10 ~n",
												  [monsterTreasures:generate_treasure(nil)]);		

							"Goblin" -> io:format("~s(~p), AC 6, HD 1-1, HP ~p, Att 1 weapon, Dmg ~s ~n", 
												  [Name, Number, [monster_hp(1, -1) || _  <- lists:seq(1, Number)], 
												         [monsterWeapons:generate_weapon(small) || _ <- lists:seq(1, Number)]]),
										io:format("Save Normal Man, Morale 6, Treasure ~s, XP 5 ~n",
												  [[monsterTreasures:generate_treasure(r) || _ <- lists:seq(1, Number)]]);	
												  
							"Centaur" -> io:format("~s(~p), AC 5, HD 4, HP ~p, Att 2 hooves / 1 weapon, Dmg 1d6/1d6/by weapon ~s ~n", 
												  [Name, Number, [monster_hp(4) || _  <- lists:seq(1, Number)], 
												         [monsterWeapons:generate_weapon(medium) || _ <- lists:seq(1, Number)]]),
										io:format("Save Normal F4, Morale 8, Treasure ~s, XP 75 ~n",
												  [monsterTreasures:generate_treasure(nil)]);		
												  
							"Neanderthal" -> io:format("~s(~p), AC 8, HD 2, HP ~p, Att 1 weapon ~s ~n", 
												  [Name, Number, [monster_hp(2) || _  <- lists:seq(1, Number)], 
												         [monsterWeapons:generate_weapon(primitive) || _ <- lists:seq(1, Number)]]),
										io:format("Save Normal F2, Morale 8, Treasure ~s, XP 20 ~n",
												  [monsterTreasures:generate_treasure(nil)]);	
												  
							"Harpy" -> io:format("~s(~p), AC 7, HD 3, HP ~p, Att 3 2 claws / 1 weapon 1d4/1d4/ ~s ~n", 
												  [Name, Number, [monster_hp(3) || _  <- lists:seq(1, Number)], 
												         [monsterWeapons:generate_weapon(medium) || _ <- lists:seq(1, Number)]]),
										io:format("Save Normal F2, Morale 8, Treasure ~s, XP 20 ~n",
												  [monsterTreasures:generate_treasure(nil)]);			
							
							_ -> 		io:format("Unknown.~n")		
						 end.

monster_hp(0.5) -> random:uniform(round(4));
monster_hp(HitDice) -> lists:foldl(fun(X, Sum) -> X + Sum end, 0, [random:uniform(round(8)) || _  <- lists:seq(1, HitDice)]).
monster_hp(HitDice, Modifier) -> monster_hp(HitDice) + Modifier.
				       

							
						

							   
