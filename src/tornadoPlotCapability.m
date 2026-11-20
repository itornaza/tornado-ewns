%*********************************************************************
%                           tornadoPlotCapability()
%
% Task:             Plot the requested network characteristic values
%                   as a function of the reduced capability on a 
%                   designated node
% Data in:          The results obtained in the resultsCapVtr and the
%                   resultsAry
% Data out:         none
% Data returned:    Generated 2 x 2 frame to hold the 4 subplots
%*********************************************************************
function tornadoPlotCapability(resultsCapVtr, resultsAry)

% Local variables
ix = 0;  % Holds the length of the resultsCapVtr
jx = 0;  % Loop counter
kx = 0;  % Loop counter

% In the case of the capability changes we need to set up again
% the arrays for proper plotting

ix = length(resultsCapVtr);
resultsPlotCapAry = zeros(6, ix);
for kx = 1: 6
  for jx = 1: ix
      resultsPlotCapAry(kx, jx) = resultsAry(kx, jx);
  end % End inner for
end % End outer for

% Set the range for the x-axis
xmin = 0;
xmax = 1;

% First position
subplot( 2, 2, 1), plot(resultsCapVtr, resultsPlotCapAry(1, :), '*-');
xlim([xmin xmax]);
title('CRM Vs Capability on node');
ylabel('CRM');
xlabel('Capability on node'); 
grid;

% Second position
subplot( 2, 2, 2), plot(resultsCapVtr, resultsPlotCapAry(2, :), '*-');
xlim([xmin xmax]);
title('Network Reach Vs Capability on node');
ylabel('Network Reach');
xlabel('Capability on node'); 
grid;

% Third position
subplot( 2, 2, 3), plot(resultsCapVtr, resultsPlotCapAry(5, :), 'r.-');
xlim([xmin xmax]); hold on;
subplot( 2, 2, 3), plot(resultsCapVtr, resultsPlotCapAry(6, :), 'b*-');
xlim([xmin xmax]); hold on;
xlabel('Capability on node');
legend('Characteristic Tempo', 'Operational Tempo');
grid;

% Fourth position
subplot( 2, 2, 4), plot(resultsCapVtr, resultsPlotCapAry(4, :), '*-');
xlim([xmin xmax]); hold on;
xlabel('Capability on node');
ylabel('Network Richness');
grid;

% end tornadoPlotCapability
