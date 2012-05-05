-module(monsterGenerator).
-export([monster/2]).

% Expected input:
%					monster("Kobold", 3).
%
% Expected output:
%					Kobold(3), AC 7, HD 1/2, HP (1, 4, 2), Att 1 weapon, Dmg (Club 1d3-1, Dagger 1d4-1, Dagger 1d4-1), 
%					Save Normal Man, Morale 6, Treasure (2 cp, 12 cp, 21 cp), XP 5
%

monster("Bugbear", Number) -> print_monster("Bugbear", Number, 5, "3 + 1", 3, 1, 
											"1 weapon", large, "+1", "Normal Man", 6, [p, " ", q], 50);
														
monster("Kobold", Number) -> print_monster("Kobold", Number, 7, "1/2", 0.5, 0, 
										   "1 weapon", small, "-1", "Normal Man", 6, [p], 5);		
							
monster("Skeleton", Number) -> print_monster("Skeleton", Number, 7, "1", 1, 0, 
											 "Claws", nil, "1d2", "F1", 12, [nil], 10);		

monster("Goblin", Number) -> print_monster("Goblin", Number, 6, "1 - 1", 1, -1, 
										   "1 weapon", small, "", "Normal Man", 6, [r], 5);	
												  
monster("Centaur", Number) -> print_monster("Centaur", Number, 5, "4", 4, 0, 
											"2 hooves / 1 weapon", medium, "1d6/1d6/by weapon", "F4", 8, [nil], 75);		
												  
monster("Neanderthal", Number) -> print_monster("Neanderthal", Number, 8, "2", 2, 0, 
												"1 weapon", primitive, "", "F2", 8, [nil], 20);	
												  
monster("Harpy", Number) -> print_monster("Harpy", Number, 7, "3", 3, 0, 
										  "2 claws / 1 weapon", medium, "1d4/1d4/", "F2", 8, [nil], 20);			
							
monster(_, _) -> io:format("Unknown.~n").		


print_monster(Name, Number, AC, HdText, HitDice, HpMod, Attacks, WeaponType, Damage, Save, Morale, Treasure, XP)
				-> io:format("~s(~p), AC ~p, HD ~s, HP ~p, Att ~s Dmg ~s ~s ~n", 
							 [Name, Number, AC, HdText, [monster_hp(HitDice, HpMod) || _  <- lists:seq(1, Number)], 
							 Attacks, Damage, [monsterWeapons:generate_weapon(WeaponType) || _ <- lists:seq(1, Number)]]),
				   io:format("Save ~s, Morale ~p, Treasure ~s, XP ~p ~n", 
				   			 [Save, Morale, generate_treasure(Treasure, Number), XP]).


monster_hp(0.5) -> random:uniform(round(4));
monster_hp(HitDice) -> lists:foldl(fun(X, Sum) -> X + Sum end, 0, [random:uniform(round(8)) || _  <- lists:seq(1, HitDice)]).
monster_hp(HitDice, Modifier) -> monster_hp(HitDice) + Modifier.
				       
generate_treasure([nil], _) -> monsterTreasures:generate_treasure(nil);
generate_treasure(Treasure, Number) -> [lists:map(fun(X) -> monsterTreasures:generate_treasure(X) end, Treasure) 
				   			 				 || _ <- lists:seq(1, Number)].
