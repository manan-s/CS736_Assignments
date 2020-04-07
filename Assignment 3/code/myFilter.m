function filteredImage = myFilter(rdn_img, L, filter)
    N = size(rdn_img, 1);
    f = fft(rdn_img);
    
    w = 2*pi/N*(0:N-1);
    w = (w - w(round(N/2)))';
    
    if filter == "Ram-Lak"
        filterMask = abs(w);
    
    elseif filter == "Shepp-Logan"
        filterMask = abs(w) .* sinc(0.5*w/L);
        
    elseif filter == "Cosine"
        filterMask = abs(w) .* cos(0.5*pi*w/L);
    end
    
    filterMask(abs(w) > L) = 0;
    filterMask = repmat(ifftshift(filterMask), 1, size(rdn_img, 2));
    filteredImage = real(ifft(f .* filterMask));
end