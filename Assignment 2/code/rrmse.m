function val = rrmse(noiseless, noisy)
    ssum = sum(sum((noiseless - noisy).^2));
    val = sqrt(ssum)/sqrt(sum(sum(noiseless.^2)));
end