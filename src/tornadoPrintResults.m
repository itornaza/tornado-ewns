%*********************************************************************
%                           tornadoPrintResults()
%
% Task:             Print the results of all the network parameters
%                   in a neat format
% Data in:          The Reference Connectivity Measure, the Network
%                   Reach, the Network Reach with the rerouting option
%                   the Network Richness the Network Characteristic 
%                   Tempo and the Network Operational tempo
% Data out:         none
% Data returned:    The Banner containing the results
%*********************************************************************
function tornadoPrintResults(crm, ir, irRerouting, rq, ltau, ooda)

fprintf('\n+--------------------------------------------------+');
fprintf('\n|Reference Connectivity Measure is:      %10d|', crm);
fprintf('\n|Network Reach is:                       %10f|', ir);
fprintf('\n|Network Reach with rerouting option is: %10f|',...
        irRerouting);
fprintf('\n|Network Richness is:                    %10f|', rq);
fprintf('\n|Network Characteristic Tempo is:        %10f|', ltau);
fprintf('\n|Network Operational Tempo is:           %10f|', ooda); 
fprintf('\n+--------------------------------------------------+\n');

% end tornadoPrintResults