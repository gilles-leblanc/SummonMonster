-module(monsterGenerator).
-export([monster/2]).

% Expected input:
%					monster("Kobold", 3).
%
% Expected output:
%					Kobold, AC 7, HD 1/2, HP 2, Att 1 weapon, Dmg Club 1d3-1, 
%					Save Normal Man, Morale 6, Treasure 12 cp, XP 5
%
%					Kobold, AC 7, HD 1/2, HP 4, Att 1 weapon, Dmg Dagger 1d4-1, 
%					Save Normal Man, Morale 6, Treasure 23 cp, XP 5
%
%					Kobold, AC 7, HD 1/2, HP 1, Att 1 weapon, Dmg Club 1d3-1, 
%					Save Normal Man, Morale 6, Treasure 2 cp, XP 5
%
% Or better yet :
%					Kobold(3), AC 7, HD 1/2, HP (1, 4, 2), Att 1 weapon, Dmg (Club 1d3-1, Dagger 1d4-1, Dagger 1d4-1), 
%					Save Normal Man, Morale 6, Treasure (2 cp, 12 cp, 21 cp), XP 5
%

% random:seed(erlang:now()),
% [[monster_treasure(p) || X <- lists:seq(1, Number)]]

monster(Name, Number) -> case Name of
							"Kobold" -> io:format("~s(~p), AC 7, HD 1/2, HP ~p, Att 1 weapon, Dmg ~s -1 ~n", 
												  [Name, Number, [monster_hp(0.5) || X  <- lists:seq(1, Number)], 
												         [monster_weapon(small) || X <- lists:seq(1, Number)]]),
										io:format("Save Normal Man, Morale 6, Treasure ~s, XP 5 ~n",
												  [monster_treasure(p)]);			
							
							_ -> 		io:format("Unknown.~n")		
						 end.

monster_hp(HitDice) -> random:uniform(round(8 * HitDice)).
				       
monster_weapon(Size) when Size == small -> Weapons = ["Hand Axe 1d6", "Blackjack 1d2", "Torch 1d4", "Dagger 1d4",
									 				  "Short Sword 1d6", "Small club 1d2"],
									                   pick_random_from_list(Weapons);
									          
monster_weapon(Size) when Size == medium -> Weapons = ["Battle Axe 1d8", "Club 1d4", "War Hammer 1d6", "Mace 1d6",
									 				   "Staff 1d6", "Trident 1d6", "Normal Sword 1d8", "Whip 1d2"],
									                   pick_random_from_list(Weapons);
									          
monster_weapon(Size) when Size == large -> Weapons = ["Halberd 1d10", "Polearm 1d10", "Two-Handed Sword 1d10"],
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
								  conditional_treasure(5, 1, "special treasure "), conditional_treasure(5, 1, "magical items ")]
						  end.

conditional_treasure(Chance, Number, TreasureName) -> Result = random:uniform(100), 
					     							  if Result =< Chance -> 
					     										  [integer_to_list(random:uniform(Number)), " ", TreasureName];
										                 true -> ""
										              end.

pick_random_from_list(List) -> Index = random:uniform(length(List)),
							   lists:nth(Index, List).

dice_roll(Number, DiceType) -> lists:foldl(fun(X, Sum) -> random:uniform(DiceType) + Sum end, 0, lists:seq(1, Number)).
							   
