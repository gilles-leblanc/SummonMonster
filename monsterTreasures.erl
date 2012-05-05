-module(monsterTreasures).
-export([generate_treasure/1]).

generate_treasure(Type) -> case Type of
							p -> [integer_to_list(roll_dice(3, 8)), " cp"];
							q -> [integer_to_list(roll_dice(3, 6)), " sp"];
							r -> [integer_to_list(roll_dice(2, 6)), " ep"];
							s -> [integer_to_list(roll_dice(2, 4)), " gp", conditional_treasure(5, 1, "gems")];
							t -> [integer_to_list(roll_dice(1, 6)), " pp", conditional_treasure(5, 1, "gems")];
							u -> [conditional_treasure(10, 100, "cp"), conditional_treasure(10, 100, "sp"),
								  conditional_treasure(5, 100, "gp"), conditional_treasure(5, 2, "gems"),
								  conditional_treasure(5, 4, "jewelry"), conditional_treasure(2, 1, "special treasure"),
								  conditional_treasure(2, 1, "magical items")];
							v -> [conditional_treasure(10, 100, "sp"), conditional_treasure(5, 100, "ep"), 
								  conditional_treasure(10, 100, "gp"), conditional_treasure(5, 100, "pp"),
								  conditional_treasure(10, 2, "gems"), conditional_treasure(10, 4, "jewelry"),
								  conditional_treasure(5, 1, "special treasure"), conditional_treasure(5, 1, "magical items")];
						 	nil -> ["No treasure"];
						 	_ -> " "
						  end.

conditional_treasure(Chance, Number, TreasureName) -> Result = random:uniform(100), 
					     							  if Result =< Chance -> 
					     										  [integer_to_list(random:uniform(Number)), " ", TreasureName];
										                 true -> ""
										              end.

roll_dice(Number, DiceType) -> lists:foldl(fun(_, Sum) -> random:uniform(DiceType) + Sum end, 0, lists:seq(1, Number)).
