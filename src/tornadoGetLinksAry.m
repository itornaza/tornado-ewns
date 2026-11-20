%*********************************************************************
%                           tornadoGetLinksAry()
%
% Task:             Get the unidirectional links from the user
% Data in:          The nodes of the network
% Data out:         none
% Data returned:    linksAry, containing the active and non-active
%                   uni-directional links of the network. The rows
%                   and the columns have the size of the nodes and
%                   each entry that has the value of 1 indicates an
%                   active link
%*********************************************************************
function [linksAry] = tornadoGetLinksAry(nodes)

% Local variables
ix = 0;  % Loop counter
jx = 0;  % Loop counter

% Initialize the linksAry
linksAry = zeros(nodes, nodes);
fprintf('\nEnter the existing links,\n');
fprintf('Enter 1 if the link exists or 0 otherwise\n');
fprintf('-----------------------------------------\n\n');

%Loop to get the existing links in the network
for ix = 1: nodes
   for jx = 1: nodes
      % Do not ask for Links with both subscripts equal
      % let them assigned the zero value
      if (ix ~= jx)
         fprintf('Link%d%d', ix, jx);
         linksAry(ix, jx) = input(': ');
         % Input validation
         while ((linksAry(ix, jx) ~= 1) && (linksAry(ix, jx) ~= 0))
            fprintf('Input Error: Enter 1 or 0\n');
            fprintf('Link%d%d:', ix, jx);
            linksAry(ix, jx) = input(' ');
         end % End while  
      end % End if 
   end % end inner for
end % End outer for

% end tornadoGetLinksAry