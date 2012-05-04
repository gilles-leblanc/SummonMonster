-module(monsterWeapons).
-export([generate_weapon/1]).

generate_weapon(small) -> pick_random_from_list(["Hand Axe 1d6 ", "Blackjack 1d2 ", "Torch 1d4 ", "Dagger 1d4 ",
							            	     "Short Sword 1d6 ", "Small club 1d2 ", "Sling 1d4 "]);
									          
generate_weapon(medium) -> pick_random_from_list(["Battle Axe 1d8 ", "Club 1d4 ", "War Hammer 1d6 ", "Mace 1d6 ",
							            		  "Staff 1d6 ", "Trident 1d6 ", "Normal Sword 1d8 ", "Whip 1d2 ",
									              "Bow, Short 1d6 ", "Crossbow, Lt 1d6 ", "Throwing Hammer 1d4 ",
									              "Shield, Sword 1d4 +2 "]);
									                   
generate_weapon(primitive) -> pick_random_from_list(["Blackjack 1d2 ", "Sling 1d4 ", "Small club 1d2 ", 
								            		 "Staff 1d6 ", "Club 1d4 ", "Stone Mace 1d6 ",
										             "Stone Spear 1d6 "]);
									          
generate_weapon(large) -> pick_random_from_list(["Battle Axe 1d8 ", "Halberd 1d10 ", "Polearm 1d10 ", 
							             		 "Two-Handed Sword 1d10 ", "Normal Sword 1d8 ", "Club 1d4 "]);

generate_weapon(_) -> "".
									                  									                  
pick_random_from_list(List) -> Index = random:uniform(length(List)),
							   lists:nth(Index, List).
