%*********************************************************************
%                           tornadoPlotLinks()
%
% Task:             Plot the requested network characteristic values
%                   as a function of the reduced capability on a 
%                   designated node
% Data in:          The results obtained in the resultsCounter the
%                   resultsJamVtr and the resultsAry
% Data out:         none
% Data returned:    Generated 2 x 2 frame to hold the 4 subplots
%*********************************************************************
function tornadoPlotLinks(resultsCounter, resultsJamVtr, ...
                          resultsAry)

% Local variables
ix = 0;  % Loop counter
jx = 0;  % Loop counter
kx = 0;  % Hold the length of the resultsAry

% Extract the valuable parts of the resultsAry and the resultsJamVtr
% which means resize them to exclude the zeroes for proper printing
% Assign those to two new arrays, resultsJamVtr2 and 
% resultsCutLinksAry

kx = length(resultsAry);
for ix = 1:  6
   for jx = 1: kx
         if(resultsAry(1, jx))
            resultsCutLinksAry(ix, jx) = resultsAry(ix, jx);
            if (ix == 1)
               resultsJamVtr2(ix, jx) = resultsJamVtr(ix, jx);
            end % end inner if
         end % end outer if
   end % end inner for
end % end outer for

% Set the range for the x-axis
xmin = 0;
xmax = resultsCounter - 1;
% First position
subplot( 2, 2, 1), plot(resultsJamVtr2, resultsCutLinksAry(1, :), '*-');
xlim([xmin xmax]);
title('CRM Vs Number of Links Cut');
ylabel('CRM');
xlabel('Number of Links Cut'); 
grid;

% Second position
subplot( 2, 2, 2), plot(resultsJamVtr2, resultsCutLinksAry(2, :), '*-');
xlim([xmin xmax]);
title('Network Reach Vs Number of Links Cut');
ylabel('Network Reach');
xlabel('Number of Links Cut'); 
grid;

% Third position
subplot( 2, 2, 3), plot(resultsJamVtr2, resultsCutLinksAry(5, :), 'r.-');
xlim([xmin xmax]); hold on;
subplot( 2, 2, 3), plot(resultsJamVtr2, resultsCutLinksAry(6, :), 'b*-');
xlim([xmin xmax]); hold on;
xlabel('Number of Links Cut');
legend('Characteristic Tempo', 'Operational Tempo');
grid;

% Fourth position
subplot( 2, 2, 4), plot(resultsJamVtr2, resultsCutLinksAry(4, :), '*-');
xlim([xmin xmax]); hold on;
xlabel('Number of Links Cut');
ylabel('Network Richness');
grid;

% end tornadoPlotLinks