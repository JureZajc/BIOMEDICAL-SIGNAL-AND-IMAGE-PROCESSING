function indices = QRSDetect(filename, M, WS, WSDecision)

  %Load signal from filename
  signal = load(filename);
  x = signal.val(1,:);

  %Initial plotting.
  figure(1);
  xPlot = x(1:(size(x,2)/300));
  plot(xPlot);

  %1. High-pass filter
  y = zeros(1, size(x,2));
  for i=1:size(x,2) %For convenience, we restrict M to odd values
    if (i >= M)   %In the line beneath, we do "i-M" and we do not want negative array indices.
	  %Casual MAF (moving average filter) can be characterized as y1, rewrite equation from paper
      y1   = (1/M) * sum(x((i - (M - 1)) : i));
	  %We just rewrite equation from paper
      y2   = x(i - ((M + 1)/2));
      y(i) = y2 - y1;
    else
      y(i) = 0;
    end
  end

  %Plotting after HPS. 
  figure(2);
  yPlot = y(1:(size(y,2)/300));
  plot(yPlot);

  %2. Low-pass filter
  for i = 1 : (size(x,2) - WS - 1)
    y(i) = sum(y(i : i + WS).^2);
  end 

  %To correct the offset that we created in LPF phase. We need to use ceil, otherwise program return error
  y = [zeros(1,ceil((WS+1)/2)) y(1:numel(y-3))];
    
  %Plotting after LPS.
  figure(3);
  yPlot = y(1:(size(y,2)/300));
  plot(yPlot);
  
  %Decision making.
  computeTheshold = @(alpha, gamma, peak, threshold) alpha * gamma * peak + (1 - alpha) * threshold;
  %Defining parameters. We used same values as paper
  alpha = 0.05;
  gamma = 0.15;
  
  threshold = max(y(1:WSDecision));
    
  %Iterate through the points with the step of window size.
  for i = 1:WSDecision:length(y)-WSDecision
     [maxV,maxI] = max(y(i:i+WSDecision));
	 %A QRS complex is said to be detected, only if the peak level of the feature signal exceeds the threshold
     if maxV >= threshold
         y(maxI+i) = 1;
         %The value of the threshold is then updated each time when a new QRS complex is detected.
         threshold = computeTheshold(alpha, gamma, maxV, threshold);
     end
  end
  
  indices = find(y==1);
  
 end