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
												  [Name, Number, [monster_hp(3, 1) || X  <- lists:seq(1, Number)], 
												         [monster_weapon(large) || X <- lists:seq(1, Number)]]),
										io:format("Save Normal Man, Morale 6, Treasure ~s ~s, XP 50 ~n",
												  [monster_treasure(p), monster_treasure(q)]);	

							"Kobold" -> io:format("~s(~p), AC 7, HD 1/2, HP ~p, Att 1 weapon, Dmg ~s -1 ~n", 
												  [Name, Number, [monster_hp(0.5) || X  <- lists:seq(1, Number)], 
												         [monster_weapon(small) || X <- lists:seq(1, Number)]]),
										io:format("Save Normal Man, Morale 6, Treasure ~s, XP 5 ~n",
												  [monster_treasure(p)]);			
							
							"Skeleton" -> io:format("~s(~p), AC 7, HD 1, HP ~p, Att 1 weapon, Dmg Claws 1d2 ~n", 
												  [Name, Number, [monster_hp(1) || X  <- lists:seq(1, Number)]]), 
										  io:format("Save F1, Morale 12, Treasure ~s, XP 10 ~n",
												  [monster_treasure(nil)]);		

							"Goblin" -> io:format("~s(~p), AC 6, HD 1-1, HP ~p, Att 1 weapon, Dmg ~s ~n", 
												  [Name, Number, [monster_hp(1, -1) || X  <- lists:seq(1, Number)], 
												         [monster_weapon(small) || X <- lists:seq(1, Number)]]),
										io:format("Save Normal Man, Morale 6, Treasure ~s, XP 5 ~n",
												  [[monster_treasure(r) || X <- lists:seq(1, Number)]]);	
												  
							"Centaur" -> io:format("~s(~p), AC 5, HD 4, HP ~p, Att 2 hooves / 1 weapon, Dmg 1d6/1d6/by weapon ~s ~n", 
												  [Name, Number, [monster_hp(4) || X  <- lists:seq(1, Number)], 
												         [monster_weapon(medium) || X <- lists:seq(1, Number)]]),
										io:format("Save Normal F4, Morale 8, Treasure ~s, XP 75 ~n",
												  [monster_treasure(nil)]);		
												  
							"Neanderthal" -> io:format("~s(~p), AC 8, HD 2, HP ~p, Att 1 weapon ~s ~n", 
												  [Name, Number, [monster_hp(2) || X  <- lists:seq(1, Number)], 
												         [monster_weapon(primitive) || X <- lists:seq(1, Number)]]),
										io:format("Save Normal F2, Morale 8, Treasure ~s, XP 20 ~n",
												  [monster_treasure(nil)]);	
												  
							"Harpy" -> io:format("~s(~p), AC 7, HD 3, HP ~p, Att 3 2 claws / 1 weapon 1d4/1d4/ ~s ~n", 
												  [Name, Number, [monster_hp(3) || X  <- lists:seq(1, Number)], 
												         [monster_weapon(medium) || X <- lists:seq(1, Number)]]),
										io:format("Save Normal F2, Morale 8, Treasure ~s, XP 20 ~n",
												  [monster_treasure(nil)]);			
							
							_ -> 		io:format("Unknown.~n")		
						 end.

monster_hp(HitDice) -> lists:foldl(fun(X, Sum) -> X + Sum end, 0, [random:uniform(round(8)) || Y  <- lists:seq(1, HitDice)]).
monster_hp(HitDice, Modifier) -> monster_hp(HitDice) + Modifier.
				       
monster_weapon(Type) when Type == small -> Weapons = ["Hand Axe 1d6 ", "Blackjack 1d2 ", "Torch 1d4 ", "Dagger 1d4 ",
									 				  "Short Sword 1d6 ", "Small club 1d2 ", "Sling 1d4 "],
									                   pick_random_from_list(Weapons);
									          
monster_weapon(Type) when Type == medium -> Weapons = ["Battle Axe 1d8 ", "Club 1d4 ", "War Hammer 1d6 ", "Mace 1d6 ",
									 				   "Staff 1d6 ", "Trident 1d6 ", "Normal Sword 1d8 ", "Whip 1d2 ",
									 				   "Bow, Short 1d6 ", "Crossbow, Lt 1d6 ", "Throwing Hammer 1d4 ",
									 				   "Shield, Sword 1d4 +2 "],
									                   pick_random_from_list(Weapons);
									                   
monster_weapon(Type) when Type == primitive -> Weapons = ["Blackjack 1d2 ", "Sling 1d4 ", "Small club 1d2 ", 
														  "Staff 1d6 ", "Club 1d4 ", "Stone Mace 1d6 ",
														  "Stone Spear 1d6 "],
														 pick_random_from_list(Weapons);
									          
monster_weapon(Type) when Type == large -> Weapons = ["Battle Axe 1d8 ", "Halberd 1d10 ", "Polearm 1d10 ", 
													  "Two-Handed Sword 1d10 ", "Normal Sword 1d8 ", "Club 1d4 "],
									                  pick_random_from_list(Weapons).
							
						
monster_treasure(Type) -> case Type of
							p -> [integer_to_list(dice_roll(3, 8)), " cp"];
							q -> [integer_to_list(dice_roll(3, 6)), " sp"];
							r -> [integer_to_list(dice_roll(2, 6)), " ep"];
							s -> [integer_to_list(dice_roll(2, 4)), " gp", conditional_treasure(5, 1, "gems")];
							t -> [integer_to_list(dice_roll(1, 6)), " pp", conditional_treasure(5, 1, "gems")];
							u -> [conditional_treasure(10, 100, "cp "), conditional_treasure(10, 100, "sp "),
								  conditional_treasure(5, 100, "gp "), conditional_treasure(5, 2, "gems "),
								  conditional_treasure(5, 4, "jewelry "), conditional_treasure(2, 1, "special treasure "),
								  conditional_treasure(2, 1, "magical items ")];
							v -> [conditional_treasure(10, 100, "sp "), conditional_treasure(5, 100, "ep "), 
								  conditional_treasure(10, 100, "gp "), conditional_treasure(5, 100, "pp "),
								  conditional_treasure(10, 2, "gems "), conditional_treasure(10, 4, "jewelry "),
								  conditional_treasure(5, 1, "special treasure "), conditional_treasure(5, 1, "magical items ")];
						 	_ -> ["No treasure"]
						  end.

conditional_treasure(Chance, Number, TreasureName) -> Result = random:uniform(100), 
					     							  if Result =< Chance -> 
					     										  [integer_to_list(random:uniform(Number)), " ", TreasureName];
										                 true -> ""
										              end.

pick_random_from_list(List) -> Index = random:uniform(length(List)),
							   lists:nth(Index, List).

dice_roll(Number, DiceType) -> lists:foldl(fun(X, Sum) -> random:uniform(DiceType) + Sum end, 0, lists:seq(1, Number)).
							   
