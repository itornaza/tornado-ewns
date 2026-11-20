%*********************************************************************
%                           tornadoGetFlowAry()
%
% Task:             Get the Flow parameter of the nodes from the user
% Data in:          The nodes and the active links (linksAry)
% Data out:         none
% Data returned:    flowAry containing the flow parameter of each node
%*********************************************************************
function [flowAry] = tornadoGetFlowAry(nodes, linksAry)

% Local variables
ix = 0;  % Loop counter
jx = 0;  % Loop counter

flowAry = ones(nodes, nodes);
fprintf('\nEnter the flow parameter for the active links\n');
fprintf('---------------------------------------------\n\n');

for ix = 1: nodes
   for jx = 1: nodes
      % If the link is active assign a flow value
      if (linksAry(ix, jx))
         fprintf('Link%d%d:', ix, jx);
         flowAry(ix, jx) = input(' ');     
      end % End if
   end % End inner for
end % End outer for

% end tornadoGetFlowAry