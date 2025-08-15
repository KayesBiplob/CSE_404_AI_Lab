%|----------------------------------------|
%| |------------------------------------| |
%| |       Mythology Knowledgebase     | |
%| |------------------------------------| |
%|----------------------------------------|
%|---------------------------------------------------------------------|
%| This Prolog database contains facts about mythological figures,     |
%| their domains, relationships, and origins. It also includes rules   |
%| for finding relationships such as siblings, ancestors, and demigods.|
%|---------------------------------------------------------------------|

%|-------------------------------------------|
%| FACTS: CATEGORY (GOD / MORTAL / CREATURE) |
%|-------------------------------------------|                                                          
god(zeus).
god(poseidon).
god(hades).
god(athena).
god(hermes).
god(apollo).
god(artemis).
god(hera).
god(aphrodite).
god(hephaestus).
god(ares).
god(dionysus).
god(hestia).
god(nike).
god(nemesis).
god(tyche).

mortal(alcmene).
mortal(danae).
mortal(peleus).
mortal(priam).
mortal(andromache).
mortal(odysseus_mortal).
mortal(penelope).
mortal(helen).
mortal(paris).

creature(minotaur).
creature(cerberus).
creature(medusa).
creature(chimera).
creature(hydra).
creature(pegasus).
creature(sphinx).
creature(scylla).

%|-----------------------------------------|
%| FACTS: DOMAIN (DEITY, DOMAIN)           |
%|-----------------------------------------|
domain(zeus, sky).
domain(poseidon, sea).
domain(hades, underworld).
domain(athena, wisdom).
domain(hermes, travel).
domain(apollo, sun).
domain(apollo, music).
domain(artemis, hunt).
domain(hera, marriage).
domain(aphrodite, love).
domain(hephaestus, fire).
domain(ares, war).
domain(dionysus, wine).
domain(hestia, hearth).
domain(nike, victory).
domain(nemesis, retribution).
domain(tyche, fortune).

%|-----------------------------------------|
%| FACTS: PARENT-CHILD RELATIONSHIPS       |
%|-----------------------------------------|
parent(chronos, zeus).
parent(chronos, poseidon).
parent(chronos, hades).

parent(rhea, zeus).
parent(rhea, poseidon).
parent(rhea, hades).

parent(zeus, athena).
parent(zeus, hermes).
parent(zeus, apollo).
parent(zeus, artemis).
parent(zeus, heracles).

parent(alcmene, heracles).
parent(zeus, perseus).
parent(danae, perseus).
parent(zeus, helen).
parent(leto, apollo).
parent(leto, artemis).
parent(zeus, dionysus).
parent(semele, dionysus).
parent(zeus, ares).
parent(hera, ares).

parent(peleus, achilles).
parent(thetis, achilles).
parent(priam, hector).
parent(andromache, astyanax).

parent(aphrodite, aeneas).
parent(anchises, aeneas).

%|-----------------------------------------|
%| FACTS: FAMOUS HEROES                    |
%|-----------------------------------------|
hero(heracles).
hero(perseus).
hero(achilles).
hero(odysseus).
hero(hector).
hero(aeneas).
hero(theseus).
hero(jason).
hero(atalanta).

%|-----------------------------------------|
%| R #1: SIBLING RULE                      |
%|-----------------------------------------|
sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \= Y.

%|-----------------------------------------|
%| R #2: DEMIGOD RULE                      |
%|-----------------------------------------|
demigod(X) :-
    parent(P1, X),
    parent(P2, X),
    god(P1), mortal(P2);
    god(P2), mortal(P1).

%|-----------------------------------------|
%| R #3: ANCESTOR RULE (RECURSIVE)         |
%|-----------------------------------------|
ancestor(X, Y) :-
    parent(X, Y).
ancestor(X, Y) :-
    parent(X, Z),
    ancestor(Z, Y).

%|-----------------------------------------|
%| R #4: DESCENDANT RULE (RECURSIVE)       |
%|-----------------------------------------|
descendant(X, Y) :-
    ancestor(Y, X).

%|-----------------------------------------|
%| R #5: FIND DOMAIN OF A DEITY            |
%|-----------------------------------------|
deity_domain(Deity, Domain) :-
    god(Deity),
    domain(Deity, Domain).

%|-----------------------------------------|
%| R #6: ALL CHILDREN OF A FIGURE          |
%|-----------------------------------------|
children(Parent, ChildrenList) :-
    findall(C, parent(Parent, C), ChildrenList).

%|-----------------------------------------|
%| R #7: LIST ALL GODS IN A DOMAIN         |
%|-----------------------------------------|
gods_in_domain(Domain, Gods) :-
    findall(G, domain(G, Domain), Gods).

%|-----------------------------------------|
%| R #8: IS A HERO A DEMIGOD?              |
%|-----------------------------------------|
hero_is_demigod(Hero) :-
    hero(Hero),
    demigod(Hero).

%|-----------------------------------------|
%| R #9: DISPLAY FULL FAMILY TREE          |
%|-----------------------------------------|
family_tree(Figure) :-
    children(Figure, Children),
    Children \= [],
    write(Figure), write(' has children: '), write(Children), nl,
    display_descendants(Children).

display_descendants([]).
display_descendants([H | T]) :-
    family_tree(H),
    display_descendants(T).

%|-----------------------------------------|
%| R #10: LIST ALL CREATURES               |
%|-----------------------------------------|
list_creatures(Creatures) :-
    findall(C, creature(C), Creatures).

%|-----------------------------------------|
%| R #11: RELATIONSHIP CHECK               |
%|-----------------------------------------|
related(X, Y) :-
    ancestor(X, Y);
    ancestor(Y, X);
    sibling(X, Y).

%|-----------------------------------------|
%| R #12: FIND HEROES RELATED TO GODS      |
%|-----------------------------------------|
god_related_heroes(God, Heroes) :-
    god(God),
    findall(H, (hero(H), ancestor(God, H)), Heroes).

%|-----------------------------------------|
%| R #13: CREATURES DEFEATED BY HEROES     |
%|-----------------------------------------|
defeated(perseus, medusa).
defeated(heracles, hydra).
defeated(theseus, minotaur).
defeated(bellerophon, chimera).
defeated(odysseus, scylla).

hero_defeats(Hero, Creatures) :-
    findall(C, defeated(Hero, C), Creatures).
