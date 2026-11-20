%*********************************************************************
%                           findAllRoutes()
%
% Task:             Get All the possible routes between to nodes in a
%                   given network topology
% Data in:          start node, fin node, tempAry which holds the 
%                   active links, the routeNo that is currently 
%                   evaluated, the total number of nodes and the 
%                   singleRouteVtr which holds the current route
%                   to be evaluated
% Data out:         the routesAry which holds all the possible routes
% Data returned:    none
%*********************************************************************
function findAllRoutes(start, fin ,tempAry, routeNo, nodes,...
                       singleRouteVtr)

%------------------
% Global variables
%------------------
global currentRoute;
global routesAry;

% Initializations that take place in each unfold step
singleRouteVtr(routeNo) = start;
routeNo = routeNo + 1;

% Zeroise the first the first column of the tempAry so there cannot
% not pass from the same point again
tempAry(:, start) = 0;

% If the fin node is reached
if start == fin
    routesAry(currentRoute, 1:length(singleRouteVtr)) =...
                                                  singleRouteVtr; 
    currentRoute = currentRoute + 1;
% First time enters here
else
    for ix = 1: nodes
        if tempAry(start, ix) == 1
            findAllRoutes(ix, fin ,tempAry, routeNo, nodes,...
                          singleRouteVtr);  
        end % End if
    end % End for
end % End if-else

% End findAllRoutes()