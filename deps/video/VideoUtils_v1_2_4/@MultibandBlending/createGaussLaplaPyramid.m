function data = createGaussLaplaPyramid(obj, I)
% Copyright (C) 2012  Marc Vivet - marc.vivet@gmail.com
% All rights reserved.
%
%   $Revision: 16 $
%   $Date: 2012-04-28 12:45:12 +0100 (Sat, 28 Apr 2012) $
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are 
% met: 
%
% 1. Redistributions of source code must retain the above copyright notice, 
%    this list of conditions and the following disclaimer. 
% 2. Redistributions in binary form must reproduce the above copyright 
%    notice, this list of conditions and the following disclaimer in the 
%    documentation and/or other materials provided with the distribution. 
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
% TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER 
% OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% The views and conclusions contained in the software and documentation are
% those of the authors and should not be interpreted as representing 
% official policies, either expressed or implied, of the FreeBSD Project.

    [h w] =  size(I);

    data = cell([obj.NumLevels, 1]);

    % Gaussian Pyramid
    data{1}.gaussian = I;
    data{1}.width    = w;
    data{1}.height   = h;
    for i = 2:obj.NumLevels
        blurred = imfilter(data{i - 1}.gaussian, ...
            obj.PSF,'symmetric','conv');

        data{i}.width  = data{i - 1}.width / 2;
        data{i}.height = data{i - 1}.height / 2;

        data{i}.gaussian       = zeros([data{i}.height, data{i}.width]);
        data{i}.gaussian(:, :) = blurred(1:2:end, 1:2:end);
        
           
    end

    for i = 1:obj.NumLevels-1
        data{i}.laplacian = zeros([data{i}.height, data{i}.width]);
        data{i}.laplacian(1:2:end, 1:2:end) = data{i+1}.gaussian(:, :);
        data{i}.laplacian = data{i}.gaussian - ...
            imfilter(data{i}.laplacian, 4*obj.PSF,'symmetric','conv');
        
    end

    data{obj.NumLevels}.laplacian = data{obj.NumLevels}.gaussian;
end
