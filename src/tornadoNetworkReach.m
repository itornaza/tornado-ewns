%*********************************************************************
%                           tornadoNetworkReach()
%
% Task:             Calculate the Network Reach and the Network with
%                   rerouting option
% Data in:          The number of all possible routes (d1), the nodes,
%                   all the possible routes, the capability of each 
%                   node, the flow parameter of each node and the 
%                   Reference Connectivity Measure of the Network
% Data out:         none
% Data returned:    the Network Reach (ir) and the Netrwork Reach with 
%                   the rerouting option
%*********************************************************************
function [ir, irRerouting] = tornadoNetworkReach(d1, nodes, routesAry, ...
                                 capabilityVtr, flowAry, crm)

% Local vaariables
ix = 0;     % Loop counter
jx = 0;     % Loop counter
kx = 0;     % adjusted indexing
sum = 0;    % running total
sum2 = 0;   % running total

% For all the rows of the routesAry
for ix = 1: d1
   for jx = 1: nodes
      % Find the last valid node     
      if routesAry(ix, jx) == 0
         kx = jx - 2;
         break;
      else
         kx = nodes - 1;
      end % End if - else
   end % End inner for
   sum = sum + capabilityVtr(routesAry(ix, 1)) *...
   flowAry(routesAry(ix, 1), routesAry(ix, kx + 1)) / kx;
   % running total for the rerouting option. Assuming all
   % the capabilities to be equal to 1
   sum2 = sum2 + ...
   flowAry(routesAry(ix, 1), routesAry(ix, kx + 1)) / kx;
end % End outer for

ir = sum / crm;
irRerouting = sum2 / crm;

% end tornadoNetworkReach