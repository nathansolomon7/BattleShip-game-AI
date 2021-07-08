% People on this team: Nathan Solomon and Luke Botsford 


function [n_quer_r,n_quer_n] = playGameHW5 (gridSize, mode, n_iter)
    narginchk(3,3);	% We better have all 3 input parameters.
    assert(strcmp(mode,'r')||strcmp(mode,'n')||strcmp(mode,'b'),...
	   'Mode must be either ''r'', ''n'', or ''b''');
    clearvars -global
    n_quer_r = 0; n_quer_n = 0;

    % Check that the desired board size is big enough.
    assert(gridSize>=5, 'Error, cannot make Battleship grid < 5 squares/side.');

    % This seeds the random-number generator. It makes all runs go identically,
    % to aid in debugging. Uncomment it for debug.
%     rng (23);

    % Set up the two subplots to display. On the left, our hidden view of
    % the opponent's board (for understanding, not for cheating!)
    % On the right, the results of our queries so far.
    make_subplots(gridSize,'All-ships display','Queries display');

    for it=1:n_iter
	% Set up the board and get the list of ships on the board.
	shipList = setupBoardandGetShipList();
	%shipList = setupTestBoardandGetShipList('test1');

	% First, the random algorithm (if it was requested).
	if (strcmp(mode,'r') || strcmp(mode,'b'))
	    % Clear out our history of moves, so we can start a new game.
	    % Then draw both of the boards.
	    resetQueries();
	    displayInitialBoards ();

	    randomSearch();
	    n_quer_r = n_quer_r + n_queries();
	    assert (allShipsAreSunk(), 'All ships are not sunk!');
	end
	% Next, do the same thing for the smart algorithm (if it was requested).
	if (strcmp(mode,'n') || strcmp(mode,'b'))
	    resetQueries();
	    displayInitialBoards ();
	    neighborhoodSearch;
	    n_quer_n = n_quer_n + n_queries();
	    assert (allShipsAreSunk(), 'All ships are not sunk!');
	end
	fprintf ('Finished iteration #%d\n', it);
    end

    % All iterations of all games are now finished. Print out statistics,
    % and we're done.
    if (n_quer_r > 0)
	fprintf ('Random search: %d queries for %d games => %f avg.\n',...
		 n_quer_r, n_iter, n_quer_r/n_iter);
    end
    if (n_quer_n > 0)
	fprintf('Neighborhood search: %d queries for %d games => %f avg.\n',...
		 n_quer_n, n_iter, n_quer_n/n_iter);
    end

    % uncomment this if you want to close your window upon function termination.
    % close all;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


     function randomSearch
global GAME 
while allShipsAreSunk~=true
    [GAME.x,GAME.y]=selectNewRandomXYLocation;

[isHit,isShipSunk,color] = QueryOpponentBoard(GAME.x,GAME.y);
pause(.5);
if isHit==1
    fprintf("hit!")
    fprintf('\n')
elseif isHit==0
    fprintf("miss!")
    fprintf('\n')
end
if isShipSunk==1
    fprintf("ship has sunk!")
    fprintf('\n')
end
  
 
end
 
if allShipsAreSunk==true
    fprintf("All ships are sunk!")
    fprintf('\n')
    fprintf("You win")
    fprintf('\n')
    return
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function neighborhoodSearch

global GAME
isHit=false
while allShipsAreSunk==false
[GAME.x,GAME.y]=selectNewRandomXYLocation
[isHit,isShipSunk,color]=QueryOpponentBoard(GAME.x,GAME.y)
if isHit==true
    sinkTheShip(GAME.x,GAME.y)
end
end

 function sinkTheShip(x,y)
 isSunk = CheckNorthUntilMiss(x,y)
 if isSunk
     return
 end
 if CheckSouthUntilMiss(x,y)==true
     return
 end
 if CheckEastUntilMiss(x,y)==true
     return
 end
 if CheckWestUntilMiss(x,y)==true
     return
 end
 end
end

function [isSunk]= CheckNorthUntilMiss(x,y)
 isSunk=false
 i=1
 isShipSunk=false
isHit=true


 while isPositionValid(x,y+i)==true && (isHit==true) && (isShipSunk==false) 
     [isHit,isShipSunk,color]=QueryOpponentBoard(x,y+i)
     i=i+1;
 end
    if isShipSunk==true
     isSunk=true
    end
 end

 
function [isSunk]= CheckSouthUntilMiss(x,y)
 isSunk=false
 i=1
 isShipSunk=false
isHit=true


 while isPositionValid(x,y-i)==true && (isHit==true) && (isShipSunk==false) 
     [isHit,isShipSunk,color]=QueryOpponentBoard(x,y-i)
     i=i+1;
 end
    if isShipSunk==true
     isSunk=true
    end
 end

       
function [isSunk]= CheckEastUntilMiss(x,y)
 isSunk=false
 i=1
 isShipSunk=false
isHit=true


 while isPositionValid(x+i,y)==true && (isHit==true) && (isShipSunk==false) 
     [isHit,isShipSunk,color]=QueryOpponentBoard(x+i,y)
     i=i+1;
 end
    if isShipSunk==true
     isSunk=true
    end
 end
 
function [isSunk]= CheckWestUntilMiss(x,y)
 isSunk=false
 i=1
 isShipSunk=false
isHit=true


 while isPositionValid(x-i,y)==true && (isHit==true) && (isShipSunk==false) 
     [isHit,isShipSunk,color]=QueryOpponentBoard(x-i,y)
     i=i+1;
 end
    if isShipSunk==true
     isSunk=true
    end
 end

 
 
     
     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the function for you to write.

    




    
    

    


%%%%%%%%%%%%%%%%%%%%
% The rest of the file consists of routines that might be useful to you,
% as well as various other routines that set up your environment but that you
% will not need. Note that the only one you'll need for Lab5 is
% isPositionValid(); the others are only for HW5.
% Here's a list of the functions, along with a short description (a fuller
% description is just above each of the actual functions):
%
% Functions to help pick your next move
%    function [x, y] = selectNewRandomXYLocation ()
%	Return a random location that has not yet been queried.
%    function isValid = isPositionValid(x, y)
%	Return true if the given (x,y) location is within the game grid.
%    function [isQueried,color] = isPositionQueried(x, y)
%	Return true if the given (x,y) location has already been queried.
%	If so, also sets color to the color of the location.
%
% Functions to get information once you've picked your move.
%    function [isHit,isShipSunk,color] = QueryOpponentBoard (x,y)
%	Query function for battleships. It also has the side effects of updating
%	the query board (both the internal version and the displayed one).
%    function all=allShipsAreSunk()
%	Return true if the user has sunk all of the ships
%
%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%
% Look at the list of all locations that have been queried, and randomly pick
% a new location that has not.
function [x, y] = selectNewRandomXYLocation ()
    global GAME;

    % First, just pick a random location and see if it's already queried.
    % This will work well at the beginning of the game, and it's fast & easy.
    % Try it twice.
    for it=1:2
	x = randi (GAME.gridSize);
	y = randi (GAME.gridSize);
	if (~GAME.queries(x,y))
	    return;
	end
    end

    % Our easy strategy didn't work. Let's get fancier (but slower).
    % This can be a bottleneck when the board size gets big.
    % Our trick will be to use find() to build a vector untried_indices[] of
    % the linear indices of the unqueried locations in GAME.queriesp[.
    untried_indices = find (GAME.queries == false);
    n_untried = numel(untried_indices);
    assert (n_untried>0, 'No more untried squares left');

    % Pick a random untried square.
    rnd = randi (n_untried);
    linear_index = untried_indices(rnd);

    % Convert the linear index into GAME.queries[] back to a row and column.
    x = 1 + rem (linear_index-1, GAME.gridSize);
    y = 1 + fix ((linear_index-1) / GAME.gridSize);
    assert (GAME.queries(x,y) == false);
end

%%%%%%%%%%%%%%%%%%%%
% Return true if the given (x,y) location is within the game grid.
function isValid = isPositionValid(x, y)
    global GAME;
    isValid = (x>0) && (y>0) && (x<=GAME.gridSize) && (y<=GAME.gridSize);
end

%%%%%%%%%%%%%%%%%%%%
% function [isQueried,color] = isPositionQueried(x, y)
% Inputs:
%	- (x,y): the location to check on.
% Returns:
%	Return isQueried=true iff the (x,y) location has already been queried.
%	In that case, sets 'color' to the color of the board at that location.
%	If there's a ship at (x,y), color gets the ship's color; else 'w'.
function [isQueried,color] = isPositionQueried(x, y)
    global GAME;
    color = 'xx';	% Just so it's set to something.
    isQueried = GAME.queries(x,y);
    if (isQueried)
	color = colorOfShipAt(x,y);
    end
end

%%%%%%%%%%%%%%%%%%%%
% Query function for battleships.
% Inputs:
%	- (x,y): the location to query.
% Returns:
%	- isHit is true if (x,y) is part of some ship.
%	- isShipSunk is true if (x,y) is the last un-hit square of a ship (which
%	  thus now gets sunk).
%	- color is only valid if isHit=true; in that case, it's the color of the
%	  ship that was hit.
% Side effect: colors the queried square in the queried-board display.
function [isHit,isShipSunk,color] = QueryOpponentBoard (x,y)
    global GAME;
    % Be polite: warn the user is he's wasting queries.
    if (isPositionQueried(x,y))
	fprintf ('Warning: you''ve already queried this point!\n');
    end

    % Remember that we've now queried this location.
    GAME.queries(x,y) = true;

    % Go through the ship list and see if any of them cover this square.
    color = 'k';				% default for no hit.
    isHit=false; isShipSunk=false;
    for i=1:numel(GAME.shipList)		% Check every ship.
	if (is_hit (GAME.shipList(i),x,y))	% and see if the ship is hit.
	    isHit=true;				% If so, update the return
	    color=GAME.shipList(i).color;	% variables accordingly.
	    isShipSunk = is_sunk(GAME.shipList(i));
	    break;
	end
    end

    % Update the query-board display for the one square that got shot at.
    fill ([x-1 x x x-1], [y-1 y-1 y y], color);
    saveIfDesired (x,y,color);
    pause(.2);
end

%%%%%%%%%%%%%%%%%%%%
% Return true if the user has sunk all of the ships (i.e., has queried every
% location that any ship covers).
% We just go through the list of all ships and let is_sunk() do the real work.
function all=allShipsAreSunk()
    global GAME;
    all=false;
    for s=1:numel(GAME.shipList)
	if (~is_sunk(GAME.shipList(s)))
	    return;
	end
    end
    all=true;
end

%%%%%%%%%%%%%%%%%%%%
% The remaining functions are used for infrastructure, but you should not
% need them (and should not use them).
%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%
% Set up the initial board. Specifically,
%	- Create 5 non-overlapping ships of hard-coded colors and sizes (but
%	  random position and orientation), and return them as shipList (also
%	  setting GAME.shipList).
% It does _not_ reset GAME.queries -- you must do that separately (since we
% often want to do both random & neighborhood search on the same shipList).
function shipList = setupBoardandGetShipList()
    global GAME;

    shipList(1) = newShipRandom (5, 'r', []);
    shipList(2) = newShipRandom (4, 'b', shipList);
    shipList(3) = newShipRandom (3, 'g', shipList);
    shipList(4) = newShipRandom (3, 'y', shipList);
    shipList(5) = newShipRandom (2, 'm', shipList);
    GAME.shipList = shipList;
end

% Read a file with one line per ship, in the format
%	x_l y_b n_squares is_horiz color
% This file does exactly the same things as setupBoardandGetShipList(), but
% it gets the ships from a file rather than creating them randomly.
function shipList = setupTestBoardandGetShipList(fileName)
    global GAME;

    % Read the file into a matrix; each row is the info for one ship.
    fileID = fopen(fileName,'r');
    mat = fscanf (fileID, '%d %d %d %d %c', [5 Inf])';
    fclose(fileID);

    % Start with a dummy ship so Matlab knows the type of the shipList vector.
    % Pick crazy numbers that won't conflict with the first real ship.
    % This is a bit delicate: the call to isNoOverlap() below only works if we
    % start with some kind of shipList vector -- but starting with an empty
    % vector would not have the correct type, and would thus break when you add
    % the first ship.
    shipList = newShip (10000,10000,1,1,'r');

    for s=1:size(mat,1)	% for each ship...
	[x_l y_b n_squares is_horiz color] = ...
		deal(mat(s,1),mat(s,2),mat(s,3),mat(s,4),char(mat(s,5)));
	ship = newShip (x_l,y_b, n_squares,is_horiz,color);
	OK = isNoOverlap(ship,shipList) && isPositionValid(ship.x_r,ship.y_t);
	assert (OK, 'Ship #%d in test file is illegal; %s', ...
		s, 'perhaps your gridSize is too small');
	shipList(s) = ship;
    end
    GAME.shipList = shipList;
end

% Make a new ship.
% A little helper function used only by setupBoardandGetShipList().
% The general idea is to keep randomly placing a ship until we find a placement
% that works -- i.e., that doesn't overlap any existing ships.
% A ship's instance variables are x_l, x_r, y_b, y_t, is_horiz and color.
function ship = newShipRandom (shipSize, color, checkList)
    global GAME;
    OK = false;
    while (~OK)
	is_horiz = randi(2) - 1;	% 0 or 1.
	% If horizontal, then x_l is in [1,gridSize+1-shipSize]
	% and y_b is in [1,gridSize].
	x_l = randi (GAME.gridSize - is_horiz   *(shipSize-1));
	y_b = randi (GAME.gridSize - (~is_horiz)*(shipSize-1));
	ship = newShip (x_l,y_b, shipSize, is_horiz, color);
	OK = isNoOverlap (ship,checkList);
    end
end

% Build a new ship from a set of irredundant parameters.
function ship=newShip (x_l,y_b, n_squares,is_horiz,color)
    % Build the ship from our input parameters.
    x_r = x_l + is_horiz*(n_squares-1);
    y_t = y_b + (~is_horiz)*(n_squares-1);
    ship = struct('x_l',x_l, 'y_b',y_b, 'x_r',x_r, 'y_t',y_t, ...
		  'n_squares',n_squares, 'is_horiz',is_horiz, 'color',color);
end

% Inputs:
%	- an array of existing ships 'checkList'
%	- a new 'ship' that's not yet added to 'checkList'
% Returns:
%	- Boolean saying if 'ship' overlaps any existing ship from 'checkList'.
function [OK] = isNoOverlap(ship, checkList)
    OK=false;
    % Check for overlap against all previously-made ships.
    cov = covered(ship);
    for i=1:size(cov,1)	% for each square covered by the ship to be checked...
	for s=1:numel(checkList)	% for each existing ship...
	    if (is_hit(checkList(s),cov(i,1),cov(i,2)))
		return;
	    end
	end
    end

    % We've succeeded; the new ship does not overlap any existing ship.
    OK=true;
    fprintf ('Ship: LL=(%d,%d),size=%d,is_hor=%d,color=%s.\n',...
	     ship.x_l,ship.y_b,ship.n_squares,ship.is_horiz,ship.color);
end

% Allocate the matrix that keeps track of which locations have been queried.
% It will start with all 'false', and then each query of a cell will change
% that cell to 'true'.
function resetQueries ()
    global GAME;
    GAME.queries = repmat(false,GAME.gridSize,GAME.gridSize);
end

%%%%%%%%%%%%%%%%%%%%
% Make sub-plots and return their handles. The caller typically uses each
% sub-plot to display a different version of the game board.
% - The typical usage in Lab 5 (the "structures" lab) is the original board on
%   the left and the "moved" one on the right.
% - The typical usage in Battleships is the reference plot of all ships on the
%   left and the query board on the right.
% - For multi-player Battleships, the reference plot of all ships is still on
%   the left, then then there is one query board for each player.
% Inputs:
%	- gridSize. Used to mark the axes from 0 to gridSize. E.g., with a 5x5
%	  array of cells, we mark the axes from 0-5.
%	- heading1, heading2, ... Used to label the sub-plots.
% Outputs:
%	- [h1, h2, ...]: handles for the subplots (used for Lab5).
%	  The vector of handles is also saved in GAME for HW5.
function handles = make_subplots(gridSize, varargin)
    global GAME;
    GAME.gridSize = gridSize;
    narginchk(2,30);	% User must specify at least one subplot to make.
    figure;
    n_subplots = nargin - 1;

    for i=1:n_subplots
	h = subplot (1,n_subplots, i);
	GAME.subplots(i) = h;
	handles(i) = h;
	hold on;
	axis ([0 gridSize 0 gridSize] );
	axis square;
	xlabel (varargin{i});
    end
end

% Display all boards from scratch. All of the boards get their grid lines
% drawn. The leftmost board also gets all of the ships drawn on it.
function displayInitialBoards ()
    % First display the allShips board.
    global GAME;
    subplot(GAME.subplots(1));
    displayBoard (GAME.shipList);

    % Next display the queries board. This is simple -- it's just all white.
    for i=2:numel(GAME.subplots);
	subplot(GAME.subplots(i));	% Put focus on the queries window.
	displayBoard ([]);
    end
end

% Display a board from scratch, with both its grid lines and the given list
% of ships. 
function displayBoard (shipList)
    % Actually draw the white board, in case we're doing multiple games and
    % there was an old board drawn.
    global GAME;
    gs = GAME.gridSize;
    fill ([0 gs gs 0], [0 0 gs gs], 'w');

    % Next, the gridlines.
    for i=0:gs
	line ([0 gs], [i i], 'Color', 'k');	% Horizontal black line.
	line ([i i], [0 gs], 'Color', 'k');	% Vertical black line.
    end

    % Now draw any ships.
    for s=1:numel(shipList)	% For each ship
	cov = covered(shipList(s));
	for i=1:size(cov,1)		% for each x,y location covered by ship.
	    x = cov(i,1);
	    y = cov(i,2);
	    fill ([x-1, x, x, x-1], [y-1, y-1, y, y], shipList(s).color);
	end
    end
end

%%%%%%%%%%%%%%%%%%%%
% Returns the number of queries that the user has made. It's used mostly for
% keeping statistics.
function n_quer = n_queries()
    global GAME;
    % Count the number of 'true' in GAME.queries;
    n_quer = numel(GAME.queries(GAME.queries));
end

%%%%%%%%%%%%%%%%%%%%
% Given a ship and an (x,y) location, does the ship cover that (x,y)? I.e.,
% does a query at that (x,y) hit the ship?
function hit = is_hit(ship,x,y)
    hit = (x>=ship.x_l) && (x<=ship.x_r) && (y>=ship.y_b) && (y<=ship.y_t);
end

%%%%%%%%%%%%%%%%%%%%
% Global function covered(), not for user use.
% Given a ship, it returns a list of the squares that this ship covers.
% Specifically, it returns an nx2 matrix. Each 1x2 row is an (x,y) pair
% giving the coordinates of one such square.
function squares=covered(ship)
    squares = zeros (ship.n_squares,2);
    x=ship.x_l;
    y=ship.y_b;
    for i=1:ship.n_squares
	squares(i,1) = x;	% Start walking from the lower-left square.
	squares(i,2) = y;	% Then we'll walk upwards or to the right.
	x = x +  ship.is_horiz;	% For a horizontal(vertical) ship, the points
	y = y + ~ship.is_horiz;	% all have the same y(x) but different x(y).
    end
end

% function sunk = is_sunk(ship)
%    Determine if a ship has sunk, by checking if all of the squares it covers
%    have been queried.
function sunk = is_sunk(ship)
    global GAME;
    sunk = true;
    cov = covered(ship);
    for i=1:size(cov,1)			% For each square covered by the ship
	if (~GAME.queries(cov(i,1),cov(i,2)))	% If it was not hit yet,...
	    sunk = false;		% then the ship isn't sunk.
	    break;
	end
    end
end

%%%%%%%%%%%%%%%%%%%%
% This function checks the color of the ship at (x,y).
% It should only be used when location (x,y) has already been queried and
% is a hit.
function color = colorOfShipAt(x,y)
    global GAME;

    assert (GAME.queries(x,y));
    color = 'k';	% Default.
    for s=1:numel(GAME.shipList)		% For each ship
	if (is_hit(GAME.shipList(s),x,y))
	    color = GAME.shipList(s).color;
	end
    end
end

% Check that all of the instance variables of a ship are consistent.
function sanity_check (ship)
    if ((ship.is_horiz  & (ship.y_t ~= ship.y_b)) || ...
	(~ship.is_horiz & (ship.x_l ~= ship.x_r)) || ...
	(ship.x_l > ship.x_r) || (ship.y_b > ship.y_t) || ...
	((ship.x_r+1-ship.x_l)*(ship.y_t+1-ship.y_b) ~= ship.n_squares) || ...
	(length(ship.color) > 1))
	error ('Illegal ship has been created.');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part of the file contains code to save a game into a text file and
% replay it later. You can even (and this is the real goal) save away several
% different games and later replay them all at the same time, giving the
% illusion that multiple players (or, really, multiple algorithms) are all
% playing at the same time, using one all-ships board and one query board per
% algorithm.
% To do this, you must:
% 1. Call saveGameToFile (seed, fileName). This sets a flag so that every query
%    you make in the current game will get recorded into fileName. It then calls
%    rng(seed) immediately and also saves it (and the current gridSize) into the
%    recording file, thus ensuring that you can later reconstruct the
%    correctly-sized grid and ship positions. 
%    The call to saveGameToFile() is not usually in the code; you must add it
%    to playGameHW5(). You do this for the game that is about to be played and
%    that you want to save. The code might look like
%	dir='c:\Users\JoelG\Documents\MATLAB\project_battleships';
%	full_name = [dir,'\record_random.txt'];
%	saveGameToFile (23, full_name, gridSize);
% 2. Call saveIfDesired(). QueryOpponentBoard() already does this; you need not
%    touch anything. It will save the queried location (as well as the resulting
%    grid color) into the recording file for every move.
% 3. Some time later (usually in a different run), call replay(). It takes a
%    list of all of the saved-data files, reads them, and displays the recorded
%    moves as if they were all happening right now. You might thus add the
%    following code to playGameHW5():
%	dir='C:\Users\JoelG\Documents\MATLAB\project_battleships';
%	core = '10_2';
%	replay ([dir '\Matt\record_' core '_Matt.txt'], 'Spiral', ...
%		[dir '\James\record_' core '_James.txt'], 'Prob');
%	return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save all of the queries in a file to be replayed later.
function saveGameToFile (seed, fileName, gridSize)
    rng(seed);

    % Open the recording file and write the header. The header contains the
    % grid size & the initial random seed.
    % (i.e., the gridSize, the random seed, and a dummy color) as the top line.
    global FILESAVE_fileID;
    global GAME;
    fprintf ('Recording to file %s.\n', fileName);
    [FILESAVE_fileID,msg] = fopen(fileName,'w');
    assert (FILESAVE_fileID>3, 'Problem *%s* opening %s', msg, fileName);
    fprintf (FILESAVE_fileID, '%d %d x\n', gridSize, seed);
end

function saveIfDesired (x,y,color)
    global FILESAVE_fileID;
    if (isempty (FILESAVE_fileID))	% Do nothing unless someone has
	return;				% called saveGameToFile().
    end

    % Save the x, y and color for this move (and, one by one, for every move).
    fprintf (FILESAVE_fileID, '%d %d %s\n', x, y, color);
end

% Call this as replay (filename1, label1, filename2, label2, ...).
% It will:
%	- read each filename to get the recorded moves for that game. Ensure
%	  that they all were created with the same gridSize and random seed.
%	- Just once, recreate the ships and the all-ships grid. And create one
%	  query grid for each file (with the appropriate label).
%	- for i=1 to # of moves
%		display the i'th move from every file in its query window
%		pause for a second.
function replay (varargin)
    narginchk(2,30);	% User must specify at least one file/label pair.
    n_players = nargin/2; % Each player gets a data file & label

    gridSize = 0;
    maxMoves = 0;
    seed = 0;
    % First pass: just get gridSize and random seed (making sure they're the
    % same for all players). And record how many moves each game took.
    for player=1:n_players
	fileName = varargin{2*player-1};
	T = readtable (fileName, 'ReadVariableNames',false);
	GSz = T.Var1(1);	% 1st number in top row is the grid size.
	assert ((gridSize==0) | (gridSize==GSz));
	gridSize = GSz;
	assert ((seed==0) | (T.Var2(1)==seed));	% 2nd # is the random seed.
	seed = T.Var2(1);
	nMoves(player) = size(T.Var1,1) - 1;
    end

    % Next pass: build 2D arrays X, Y and color. One row per move, one column
    % per player. They all have the same number of rows: we stop playing once
    % the first player has won.
    minMoves = min (nMoves);
    for player=1:n_players
	fileName = varargin{2*player-1};
	T = readtable (fileName, 'ReadVariableNames',false);
	X(1:minMoves,player) = T.Var1(2:minMoves+1);
	Y(1:minMoves,player) = T.Var2(2:minMoves+1);
	color(1:minMoves,player) = cell2mat(T.Var3(2:minMoves+1));
    end

    % Build the displays.
    vvv{1} = 'All-ships display';
    for player=1:n_players
	vvv{player+1} = varargin{2*player};
    end;
    rng (seed);
    make_subplots(gridSize,vvv{:});
    setupBoardandGetShipList();
    displayInitialBoards ();

    % Run the game.
    global GAME;
    for move=1:minMoves
	for player=1:n_players
	    subplot (GAME.subplots(player+1));
	    x = X(move,player);
	    y = Y(move,player);
	    c = color(move,player);
	    fill ([x-1 x x x-1], [y-1 y-1 y y], c);
	end
	pause(.2);
    end

    % Declare the winner(s)
    for player=1:n_players
	if (nMoves(player) == minMoves)
	    subplot (GAME.subplots(player+1));
	    xlabel ('WINNER!');
	end
    end
end
