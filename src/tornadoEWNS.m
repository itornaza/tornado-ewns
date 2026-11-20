%***********************************************************************
% File:     tornadoEWNS.m
% Name:     Ioannis Tornazakis
% Project:  Electronic Warfare Network Simulation Analysis (EWNS)
% Date:     7 Dec 2007
% 
% Description:
% ============
%
% -  This project simulates a wireless weapons-sensors inhomogeneous
% missile attack and damage assesment network in order to evaluate how
% different network topologies impact the performance metrics. This 
% program can be used to analyze strategic, operational and tactical
% outcomes as well as determine an optimal network topology. 
% Other questions that might be answered include:
%  1) How the network will impact the C2?
%  2) What is the correct ballance of the sensors?
%  3) How well does the network sustain degradation when, for example,
%     one or more of the links is under electronic attack?
%
% -  The program takes as an input the network configuration to be 
% analyzed. This includes:
%  1) The number of nodes
%  2) The connectivity (time independent)
%  3) The node capability values and information rates 
%     (time independent)
%
% -  The program process the configuration and calculates the 
% following:
%  1) Reference Connectivity Measure
%  2) Network Reach
%  3) Network Reach that includes the re-routing option impact
%  4) Network Richness
%  5) Network's Characteristic Tempo
%  6) Network's Operational Tempo
%  
% - Features:
%  1) The program asks for any jammed unidirectional links and 
%     recalculates 1-6
%  2) The results for 1-6 vs the number of linkes jammed are plotted in 
%     a 2 x 2 plot frame for quick conclusions of the networks operation
%     under jamming
% 
%   How to Run the program
%   ======================
%
% -  For the program to run, make sure that you have placed the following
% m-files in the executable path of the matlab interpreter alongside with
% the tornadoEWNS.m
%
%  - findAllRoutes.m
%  - tornadoGetFlowAry.m
%  - tornadoGetLinksAry.m
%  - tornadoNetworkReach.m
%  - tornadoPlotCapability.m
%  - tornadoPlotLinks.m
%  - tornadoPrintResults.m
%  - tornadoPrintSubMenu.m
%
% Warnings: None
% **********************************************************************

% Clear workspace and screen
close all; clear all; clc;

% Set desired format
format long

%------------------
% Global variables
%------------------

global routesAry;       % Hold all the possible routes
global currentRoute;    % Hold the current route in the 
                        % routesAry

%------------------
% Local Variables
%------------------

%----------
% Scalars
%----------

% nodes            % Holds the total number of the Network Nodes
% d1               % X Dimension of the routesAry
% d2               % Y Dimension of the routesAry
% ix               % Loop counter
% jx               % Loop counter
% kx               % Loop counter
% start            % Loop counter
% fin              % Loop counter
% prime            % Intermediate variable in reference connectivity 
%                    calculation
% sum              % Running total 
% sum2             % Running total
% crm              % Reference connectivity calculation
% routeNo          % Loop counter, holds the index of current route
% currentRoute     % Hold the current route in the 
                   % routesAry
% c2               % C2 rate of decision Making capability
% n1               % Action Tempo n1
% n2               % Action Tempo n2
% ir               % Network Reach
% irRerouting      % Network Reach with rerouting option enabled
% rq               % Network Richness
% ltau             % Network Characteristic Tempo
% ooda             % Network Operational Tempo
% resultsCounter   % Loop counter used as an index in the results
% xmin             % Minimum value of the x-axis
% xmax             % Maximum value of the x-axis

%---------
% Vectors
%---------

% connectivityVtr  % Holds the connectivity for each Node
% capabilityVtr    % Holds the capability of each node
% infoRateVtr      % Holds the information rate of each node
% minInfoRateVtr   % Holds the minimum information rate of each node
% singleRouteVtr   % Holds a complete and valid route to be passed to
                   % the routesAry
% resultsJamVtr    % Holds the number of the links cut versus the index
% resultsJamVtr2   % Holds the number of the links cut versus the index
                   % furthermore the size is fixed for proper printing
% resultsCapVtr    % Holds all the capabilities entered for a node

%---------
% Arrays
%---------

% routesAry          % Contains all the possible routes in the network
% linksAry           % Holds the links that are active
% tempAry            % A copy of the linksAry
% flowAry            % Hold the flow parameter for the active links
% resultsAry         % Hold the desired results in an array for plotting
% resultsCutLinksAry % Hold the desired results in an array for plotting
%                    % furthermore the size is fixed for proper printing
% resultsPlotCapAry  % Hold the desired results in an array for plotting


%-----------
% Code
%-----------

% Display programme header
fprintf('**********************************************\n');
fprintf('Electronic Warfare Network Simulation Analysis\n');
fprintf('       Tornado-EWNS Ioannis Tornazakis\n');
fprintf('**********************************************\n\n');

%---------------------------
% Get Network Configuration
%---------------------------

fprintf('Network Initial Configuration:\n');
fprintf('==============================\n\n');
fprintf('Enter the Number of Nodes:');
nodes = input(' ');

% Input validation to ensure that two or more nodes are entered
% to the system
while (nodes < 2)
   fprintf('\nInput Error: Please enter more than one nodes\n\n');
   fprintf('Enter the Number of Nodes:');
   nodes = input(' ');
end % end while

% Initialize the arrays with zero
capabilityVtr   = zeros(1, nodes);
infoRateVtr     = zeros(1, nodes);
minInfoRateVtr  = zeros(1, nodes);

% Loop to get the connectivity, capability and information rate
% for each Node
for ix = 1: nodes
     fprintf('\nNode %d\n', ix);
     fprintf('-----------\n');
     fprintf('Enter capability of Node %d\t\t:', ix);
     capabilityVtr(ix) = input(' ');
     fprintf('Enter information rate of Node %d\t:', ix);
     infoRateVtr(ix) = input(' ');
     fprintf('Enter min information rate of Node %d\t:', ix);
     minInfoRateVtr(ix) = input(' ');
end % End for

% Input the links and specify if they are unidirectional
% or bidirectional. Convention in this program is to indicate
% an active link with a flag set to 1. 0 indicates a non-existing
% link. With that we can also specify which of the links are 
% unidirectional or bidirectional.
linksAry = tornadoGetLinksAry(nodes);

% Count the links in the network
sumLinks = 0;
for ix = 1: nodes
    for jx = 1: nodes
        sumLinks = sumLinks + linksAry(ix, jx);
    end % End inner for
end % End outer for

% Create a results container for plotting
resultsAry = zeros(6, sumLinks);
resultsJamVtr = zeros(1, sumLinks);
resultsCapVtr = zeros(1, 1);

% Get flow parameters for the active links
flowAry = tornadoGetFlowAry(nodes, linksAry);

% Get Operational Tempo related information
fprintf('\nEnter OODA related info\n');
fprintf('-----------------------\n\n');
fprintf('Enter C2 rate of decision Making capability:');
c2 = input(' ');
fprintf('Enter Action Tempo n1                      :');
n1 = input(' ');
fprintf('Enter Action Tempo n2                      :');
n2 = input(' ');

%\\\\\\\\\\\\\\\\\\
% Calculations
%//////////////////

fprintf('\nResults:\n');
fprintf('========\n');

%--------------------------------
% Reference Connectivity Measure
%--------------------------------
prime = nodes;
crm = 0;

for ix = 1: nodes   
    prime = prime * (nodes - ix);
    crm = crm + (prime / ix);
end % End for

%--------------------------------
% Network Reach, and 
% Network Reach that includes 
% the re-routing option impact
%--------------------------------

% Make sure you enter the while loop at least ones
% All the following are flag to ensure one entry
jam = 'y'; 
anotherTry = 'y';
resultsCounter = 0;
selection = 0;
plotPlan = 0;

% Loop to control various jammed links after the initial computation
while (jam == 'y' || anotherTry == 'y')
    % Initialize variables every time you re-enter the loop
    resultsCounter = resultsCounter + 1;
    resultsJamVtr(resultsCounter) = resultsCounter - 1;
    routeNo = 1;
    currentRoute = 1;
    singleRouteVtr = zeros(1, nodes);
    routesAry = zeros(1, nodes);
    tempAry = linksAry;

    % 1) Calculate all the possible routes in the network

    % From all the START nodes
    for start = 1: nodes;   
        % To all the FIN nodes
        for fin = 1: nodes;   
            % Avoid to start and finish at the same point
            if (start ~= fin)
                % Recursive function to calculate all the possible 
                % routes for each pair of nodes
                findAllRoutes(start, fin, tempAry, routeNo, nodes,...
                              singleRouteVtr);
            end % End if
        end % End inner if
    end % End outer for
    
    % Get the dimensions of the routesAry
    [d1, d2] = size(routesAry);

    % 2) Calculate the network reach
    [ir, irRerouting] = tornadoNetworkReach(d1, nodes, routesAry, ...
                             capabilityVtr, flowAry, crm);

    
    %--------------------------------
    % Network Richness
    %--------------------------------
    sum = 0;
    
    for ix = 1: nodes
        sum = sum + infoRateVtr(ix) * log(infoRateVtr(ix)...
                                      / minInfoRateVtr(ix));
    end % End for
    
    rq = sum / nodes;
    
    %--------------------------------
    % Network's Characteristic Tempo
    %--------------------------------
    ltau = ir * rq;
    
    %--------------------------------
    % Network's Operational Tempo
    %--------------------------------
    ooda = c2 / ( 1 + (1 / n1 + 1 / n2) * c2 + 3 * c2 / ltau);
    
    % Update the results
    resultsAry(1, resultsCounter) = crm;
    resultsAry(2, resultsCounter) = ir;
    resultsAry(3, resultsCounter) = irRerouting;
    resultsAry(4, resultsCounter) = rq;
    resultsAry(5, resultsCounter) = ltau;
    resultsAry(6, resultsCounter) = ooda;
    
    % Serve the values to the masses
    tornadoPrintResults(crm, ir, irRerouting, rq, ltau, ooda);
    
    % Main menu selection after the first results are displayed
    while (selection ~= 1 && selection ~= 2 && selection ~=3)
        % Display the Menu to the user and input the selection
        tornadoPrintSubMenu();
        selection = input(' ');

        % Depending on selection check program flow
        if (selection == 1)
            jam = 'n';
            fprintf('\nWhich node              :');
            capabilityNode = input(' ');
            resultsCapVtr(1) = capabilityVtr(capabilityNode);
            fprintf('Plot the results? (y, n):');
            flag = input(' ', 's');
            if flag == 'y'
                plotPlan = 1;
            end
        elseif (selection == 2)
            anotherTry = 'n';
            fprintf('\nPlot the results? (y, n):');
            flag = input(' ', 's');
            if flag == 'y'
                plotPlan = 2;
            end
        elseif (selection == 3) 
            % Exit simulation
            jam = 'n';
            anotherTry = 'n';
            plotPlan = 0;
        else
            fprintf('\nInvalid Menu Input: Please try again,\n');
        end
    end 
    
    %----------------------------------------------
    % Jammed links or Capability change on a node
    %----------------------------------------------
    
    % Added functionality by recalculation of the same problem
    % taking into account any given jammed links entered by the
    % user.
    % CAUTION: The jammed links are additive to the program
    
    if (jam == 'y')
        fprintf('\nIs any link jammed (y, n)?');
        jam = input(' ', 's');
    end
    
    if (jam == 'y')
        sumLinks = 0;
        for ix = 1: nodes
            for jx = 1: nodes
                sumLinks = sumLinks + linksAry(ix, jx);
            end % End inner for
        end % End outer for
        
        if sumLinks > 1
            % Prompt for the jammed nodes
            fprintf('\nEnter jammed link between nodes\n');
            fprintf('Enter "from" node:');
            node1 = input(' ');
            fprintf('Enter "to" node  :');
            node2 = input(' ');
            % Set the corresponding entries in the linksAry to zero
            linksAry(node1, node2) = 0;
        else
            fprintf('\nCAUTION: There is only one link left.');
            fprintf('\n         You are not allowed to delete it.\n');
            % Provide default results for case of no links at all
            resultsCounter = resultsCounter + 1;
            resultsAry(1, resultsCounter) = crm;
            resultsAry(2, resultsCounter) = 0;
            resultsAry(3, resultsCounter) = 0;
            resultsAry(4, resultsCounter) = rq;
            resultsAry(5, resultsCounter) = 0;
            resultsAry(6, resultsCounter) = ooda;
            resultsJamVtr(resultsCounter) = resultsCounter - 1;
            jam = 'n';  % Condition to exit while loop
        end % End inner if else
    % Changing the capability of a node option
    elseif (anotherTry == 'y')
        fprintf('\nEnter capability for node %d (y, n):',...
                  capabilityNode);
        anotherTry = input(' ', 's');
        if (anotherTry == 'y')
            fprintf('Enter capability for node %d       :',...
                     capabilityNode);
            capabilityVtr(capabilityNode) = input(' ');
            resultsCapVtr(resultsCounter + 1) = ...
                                     capabilityVtr(capabilityNode);
        else 
            anotherTry = 'n';
        end % End else
    end % End if-elseif
end % End while

%--------------
% Plots
%--------------

% Use a 2 x 2 plot frame to hold all the plots

% Plot the Capability Plan
if (plotPlan == 1)
   tornadoPlotCapability(resultsCapVtr, resultsAry);

% Plot the Jammed Links Plan
elseif (plotPlan == 2)
   tornadoPlotLinks(resultsCounter, resultsJamVtr, resultsAry);
end % if elseif

% Say Thank you and exit
fprintf('\nThank you for using Tornado-EWNS!\n\n');

% End tornadoEWNS.m